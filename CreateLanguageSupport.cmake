################################################################################
# Macros to collect information about wrapped types and module dependencies
# so that support files for given languages can be created to automatically
# load the modules in the right order and provide support for looking up
# templated types.
# Currently only Python support is implemented.
################################################################################


MACRO(LANGUAGE_SUPPORT_INITIALIZE)
  # Re-set the WRAPPED_CLASSES variable used to collect class and template data.
  # This variable holds a list of strings of the one of two forms:
  #
  # "simple name # c++ name # swig name # c++ template parameters"
  # where 'simple name' is the name the class should have in the wrapped code
  # (e.g. drop the itk), 'c++ name' is the name of the templated class in c++ 
  # (not including the template parameters!), 'swig name' is the name of this
  # particular template instantiation in the swig wrappers (e.g. itkImageF2),
  # and 'c++ template parameters' are the raw text between the template angle
  # brackets (e.g. the ... in itk::Image<...>) for this template instantiation.
  #
  # or "simple name # c++ name # swig name # NO_TEMPLATE"
  # where simple name is the same as above, 'c++ name' is the name of the class
  # in c++, and 'swig name' is the name of the class in the swig wrappers.
  # 
  # Also re-set the WRAPPER_TYPEMAPS variable, which holds the text of SWIG
  # typemaps generated for smart pointers wrapped in this library.

  SET(WRAPPED_CLASSES)
  SET(WRAPPER_TYPEMAPS)
ENDMACRO(LANGUAGE_SUPPORT_INITIALIZE)


MACRO(LANGUAGE_SUPPORT_CONFIGURE_FILES)
  # Create the various files to make it easier to use the ITK wrappers, especially
  # with reference to the multitude of templates.
  # Currently, only Python is supported.
  
  MESSAGE(STATUS "${WRAPPER_LIBRARY_NAME}: Creating language support files.")

  CONFIGURE_TYPEMAPS("${WRAPPER_SWIG_LIBRARY_OUTPUT_DIR}")
  
  IF(WRAP_ITK_PYTHON)
    CONFIGURE_PYTHON_CONFIG_FILES("${PROJECT_BINARY_DIR}/Python/Configuration")      
    IF(CMAKE_CONFIGURATION_TYPES)
      FOREACH(config ${CMAKE_CONFIGURATION_TYPES})
        CONFIGURE_PYTHON_LOADER_FILE("${PROJECT_BINARY_DIR}/Python/${config}")
      ENDFOREACH(config)
    ELSE(CMAKE_CONFIGURATION_TYPES)
      CONFIGURE_PYTHON_LOADER_FILE("${PROJECT_BINARY_DIR}/Python/")
    ENDIF(CMAKE_CONFIGURATION_TYPES)
    # Just install the files once, regardless of how many different places
    # they were configured into. If there are no configuration types, the 
    # intdir expands to '', so no harm done.
    INSTALL_PYTHON_LOADER_FILE("${PROJECT_BINARY_DIR}/Python/${WRAP_ITK_INSTALL_INTDIR}")
  ENDIF(WRAP_ITK_PYTHON)
ENDMACRO(LANGUAGE_SUPPORT_CONFIGURE_FILES)


MACRO(LANGUAGE_SUPPORT_ADD_CLASS simple_name cpp_name swig_name template_params)
  # Add the template definitions to the WRAPPED_CLASSES list,
  # where 'simple_name' is the name the class should have in the wrapped code
  # (e.g. drop the itk), 'cpp_name' is the name of the templated class in c++ 
  # (not including the template parameters!), 'swig_name' is the name of this
  # particular template instantiation in the swig wrappers (e.g. itkImageF2)
  # or just the base name if this isn't a templated class,  and
  # 'template_params' are the raw text between the template angle brackets
  # (e.g. the ... in itk::Image<...>) for this template instantiation.
  # Leave template params empty (e.g. "") for non-template classes.
  #
  # We use this data to create our string of the form
  # "simple name # c++ name # swig name # c++ template parameters"
  # or "simple name # c++ name # swig name # NO_TEMPLATE"
  # as required above.

  IF(NOT template_params)
    SET(template_params "NO_TEMPLATE")
  ENDIF(NOT template_params)

  SET(WRAPPED_CLASSES ${WRAPPED_CLASSES} "${simple_name} # ${cpp_name} # ${swig_name} # ${template_params}")
  IF("${cpp_name}" STREQUAL "itk::SmartPointer")
    ADD_POINTER_TYPEMAP("${template_params}")
  ENDIF("${cpp_name}" STREQUAL "itk::SmartPointer")
ENDMACRO(LANGUAGE_SUPPORT_ADD_CLASS)


MACRO(ADD_POINTER_TYPEMAP template_params)    
  # There is a syntax error if the >> are not separated by at least
  # one whitespace because then the compiler treats that as an operator>>.
  STRING(REGEX REPLACE ">" " > " template_params "${template_params}")
  STRING(REGEX REPLACE "<" " < " template_params "${template_params}")

  SET(text "\n\n")
  SET(text "${text} // Typemaps for Smart Pointers to ${template_params} class. \n\n")
  SET(text "${text}%typemap(out) ${template_params} * {\n")
  SET(text "${text}  std::string methodName = \"\$symname\";\n")
  SET(text "${text}  if(methodName.find(\"GetPointer\") != -1) {\n")
  SET(text "${text}    // really return a pointer in that case\n")
  SET(text "${text}    \$result = SWIG_NewPointerObj((void *)(\$1), \$1_descriptor, 1);\n")
  SET(text "${text}  } else {\n")
  SET(text "${text}    itk::SmartPointer< ${template_params} > * ptr;\n")
  SET(text "${text}    ptr = new itk::SmartPointer< ${template_params} >(\$1);\n")
  SET(text "${text}    \$result = SWIG_NewPointerObj((void *)(ptr), \$descriptor(itk::SmartPointer< ${template_params} > *), 1);\n")
  SET(text "${text}  }\n")
  SET(text "${text}}\n")
  SET(text "${text}%typemap(in) ${template_params} * {\n")
  SET(text "${text}  itk::SmartPointer< ${template_params} > * sptr;\n")
  SET(text "${text}  ${template_params} * ptr;\n")
  SET(text "${text}  if ((SWIG_ConvertPtr($input,(void **) &sptr, $descriptor(itk::SmartPointer< ${template_params} > *), SWIG_POINTER_EXCEPTION)) != -1) {\n")
  SET(text "${text}    // it's a SmartPointer. Get the pointer and return it\n")
  SET(text "${text}    $1 = sptr->GetPointer();\n")
  SET(text "${text}  } else if ((SWIG_ConvertPtr($input,(void **) &ptr, $1_descriptor, SWIG_POINTER_EXCEPTION)) != -1) {\n")
  SET(text "${text}    // we have a simple pointer. Just return it\n")
  SET(text "${text}    $1 = ptr;\n")
  SET(text "${text}  } else {\n")
  SET(text "${text}    // not a pointer nor a SmartPointer... typemap fail !\n")
  SET(text "${text}    SWIG_fail;\n")
  SET(text "${text}  }\n")
  SET(text "${text}  // clean the error before exit\n")
  SET(text "${text}#ifdef SWIGPYTHON\n")
  SET(text "${text}  PyErr_Clear();\n")
  SET(text "${text}#endif // SWIGPYTHON\n")
  SET(text "${text}}\n")
  SET(text "${text}%typemap(typecheck) ${template_params} * {\n")
  SET(text "${text}  void *ptr;\n")
  SET(text "${text}  if (SWIG_ConvertPtr(\$input, &ptr, \$1_descriptor, 0) == -1\n")
  SET(text "${text}      && SWIG_ConvertPtr(\$input, &ptr, \$descriptor(itk::SmartPointer< ${template_params} > *), 0) == -1) {\n")
  SET(text "${text}    _v = 0;\n")
  SET(text "${text}#ifdef SWIGPYTHON\n")
  SET(text "${text}    PyErr_Clear();\n")
  SET(text "${text}#endif // SWIGPYTHON\n")
  SET(text "${text}  } else {\n")
  SET(text "${text}    _v = 1;\n")
  SET(text "${text}  }\n")
  SET(text "${text}}\n")
  SET(text "${text}\n\n")
  
  SET(WRAPPER_TYPEMAPS "${WRAPPER_TYPEMAPS}${text}")
ENDMACRO(ADD_POINTER_TYPEMAP)


MACRO(CONFIGURE_TYPEMAPS outdir)
  SET(CONFIG_TYPEMAP_TEXT "${WRAPPER_TYPEMAPS}")
  CONFIGURE_FILE("${WRAP_ITK_CONFIG_DIR}/typemaps.swg.in"
    "${outdir}/${WRAPPER_LIBRARY_NAME}.swg"
    @ONLY IMMEDIATE)
   INSTALL_FILES("${WRAP_ITK_INSTALL_LOCATION}/SWIG"
     FILES "${outdir}/${WRAPPER_LIBRARY_NAME}.swg")
ENDMACRO(CONFIGURE_TYPEMAPS)

################################################################################
# Language-specific macros to configure various language support files.
################################################################################

MACRO(CONFIGURE_PYTHON_CONFIG_FILES outdir)
  # Pull the WRAPPED_CLASSES list apart and use it to create Python-specific
  # support files. This also uses the global WRAPPER_LIBRARY_DEPENDS,
  # WRAPPER_LIBRARY_NAME, and WRAPPER_LIBRARY_AUTO_LOAD variables.
  
  IF(WRAPPER_LIBRARY_AUTO_LOAD)
    SET(CONFIG_AUTO_LOAD "True")
  ELSE(WRAPPER_LIBRARY_AUTO_LOAD)
    SET(CONFIG_AUTO_LOAD "False")
  ENDIF(WRAPPER_LIBRARY_AUTO_LOAD)
  
    SET(CONFIG_DEPENDS "")
  FOREACH(dep ${WRAPPER_LIBRARY_DEPENDS})
    SET(CONFIG_DEPENDS "${CONFIG_DEPENDS} '${dep}',")
  ENDFOREACH(dep)
  
  # Deal with the WRAPPED_CLASSES strings, which are in the format
  # "simple name # c++ name # swig name # c++ template parameters"    
  # or "simple name # c++ name # swig name # NO_TEMPLATE"
  # We want to change them to the format:
  # "  ('simple name', 'c++ name', 'swig name', 'template params'),\n"
  # or "  ('simple name', 'c++ name', 'swig name'),\n", respectively.
    
  SET(CONFIG_TEMPLATES "")
  FOREACH(wrapped_class ${WRAPPED_CLASSES})
    # first put the internal quotes in place
    STRING(REGEX REPLACE
      " # "
      "', '"
      py_template_def
      "${wrapped_class}")
    # now put the outside parens and quotes, etc. in place
    SET(py_template_def "  ('${py_template_def}'),\n")
    # now strip out the NO_TEMPLATE if there is none
    STRING(REGEX REPLACE
      ", 'NO_TEMPLATE'"
      ""
      py_template_def
      "${py_template_def}")
    SET(CONFIG_TEMPLATES "${CONFIG_TEMPLATES}${py_template_def}")
  ENDFOREACH(wrapped_class)
  
  CONFIGURE_FILE("${WRAP_ITK_CONFIG_DIR}/LanguageSupport/ModuleConfig.py.in"
    "${outdir}/${WRAPPER_LIBRARY_NAME}Config.py"
    @ONLY IMMEDIATE)
  INSTALL_FILES("${WRAP_ITK_INSTALL_LOCATION}/Python/Configuration"
    FILES "${outdir}/${WRAPPER_LIBRARY_NAME}Config.py")

ENDMACRO(CONFIGURE_PYTHON_CONFIG_FILES)


MACRO(CONFIGURE_PYTHON_LOADER_FILE outdir)
  # Create the loader file for importing just the current wrapper library. Uses
  # the global WRAPPER_LIBRARY_NAME variable.
  
  SET(CONFIG_LIBRARY_NAME "${WRAPPER_LIBRARY_NAME}")
  CONFIGURE_FILE("${WRAP_ITK_CONFIG_DIR}/LanguageSupport/ModuleLoader.py.in"
    "${outdir}/${WRAPPER_LIBRARY_NAME}.py"
    @ONLY IMMEDIATE)
ENDMACRO(CONFIGURE_PYTHON_LOADER_FILE)


MACRO(INSTALL_PYTHON_LOADER_FILE outdir)
  # Install the loader file for importing just the current wrapper library.
  # Note that outdir will always have a trailing slash.
  
  INSTALL_FILES("${WRAP_ITK_INSTALL_LOCATION}/Python"
    FILES "${outdir}${WRAPPER_LIBRARY_NAME}.py")
ENDMACRO(INSTALL_PYTHON_LOADER_FILE)