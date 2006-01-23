################################################################################
# Macros to collect information about wrapped types and module dependencies
# so that support files for given languages can be created to automatically
# load the modules in the right order and provide support for looking up
# templated types.
# Currently only Python support is implemented.
################################################################################


MACRO(LANGUAGE_SUPPORT_INITIALIZE)
  # Re-set the global variable used to collect class and template data.
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

  SET(WRAPPED_CLASSES)
ENDMACRO(LANGUAGE_SUPPORT_INITIALIZE)


MACRO(LANGUAGE_SUPPORT_CONFIGURE_FILES)
  # Create the various files to make it easier to use the ITK wrappers, especially
  # with reference to the multitude of templates.
  # Currently, only Python is supported.
  
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
      # cfg_intdir expands to '.', so no harm done.
      INSTALL_PYTHON_LOADER_FILE("${PROJECT_BINARY_DIR}/Python/${CMAKE_CFG_INTDIR}")
   ENDIF(WRAP_ITK_PYTHON)
ENDMACRO(LANGUAGE_SUPPORT_CONFIGURE_FILES)


MACRO(LANGUAGE_SUPPORT_ADD_CLASS simple_name cpp_name swig_name templates wrap_pointer)
  # Add the template definitions to the WRAPPED_CLASSES list. See above for 
  # description of the format of this list.
  
  SET(sharp_regexp "([0-9A-Za-z]*)[ ]*#[ ]*(.*)")
  FOREACH(template ${templates})
    # Recall that 'templates' is a list of strings of the format "name # types"
    # where 'name' is a mangled suffix to be added to the class name, and
    # 'types' is a comma-separated list of the template parameters (in C++ form).
    # 
    # We use this data to create our string of the form
    # "simple name # c++ name # swig name # c++ template parameters"
    
    STRING(REGEX REPLACE
      "${sharp_regexp}"
      "${simple_name} # ${cpp_name} # ${swig_name}\\1 # \\2"
      wrapped_class 
      "${template}")
    SET(WRAPPED_CLASSES ${WRAPPED_CLASSES} "${wrapped_class}")
    
    IF(wrap_pointer)
      STRING(REGEX REPLACE
        "${sharp_regexp}"
        "SmartPointer # itk::SmartPointer # ${swig_name}\\1_Pointer # ${cpp_name}<\\2>"
        wrapped_class 
        "${template}")
      SET(WRAPPED_CLASSES ${WRAPPED_CLASSES} "${wrapped_class}")
    ENDIF(wrap_pointer)
  ENDFOREACH(template)
  
ENDMACRO(LANGUAGE_SUPPORT_ADD_CLASS)


MACRO(LANGUAGE_SUPPORT_ADD_NON_TEMPLATE_CLASS simple_name cpp_name swig_name wrap_pointer)
  # Add the template definitions to the WRAPPED_CLASSES list. See above for 
  # description of the format of this list.
  
  SET(WRAPPED_CLASSES ${WRAPPED_CLASSES}
    "${simple_name} # ${cpp_name} # ${swig_name} # NO_TEMPLATE")
    
  IF(wrap_pointer)
    SET(WRAPPED_CLASSES ${WRAPPED_CLASSES} 
      "SmartPointer # itk::SmartPointer # ${swig_name}_Pointer # ${cpp_name}")
  ENDIF(wrap_pointer)
  
ENDMACRO(LANGUAGE_SUPPORT_ADD_CLASS)


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
      "${wrapped_class})
    # now put the outside parens and quotes, etc. in place
    SET(py_template_def "  ('${py_template_def}'),\n")
    # now strip out the NO_TEMPLATE if there is none
    STRING(REGEX REPLACE
      ", 'NO_TEMPLATE'"
      ""
      py_template_def
      "${py_template_def})
    SET(CONFIG_TEMPLATES "${CONFIG_TEMPLATES}${py_template_def}"
  ENDFOREACH(wrapped_class)
  
  CONFIGURE_FILE("${WRAP_ITK_CONFIG_DIR}/LanguageSupport/ModuleConfig.py.in"
    "${outdir}/${WRAPPER_MODULE_NAME}Config.py"
    @ONLY IMMEDIATE)
  INSTALL_FILES("${WRAP_ITK_INSTALL_LOCATION}/Python/Configuration"
    FILES "${outdir}/${WRAPPER_MODULE_NAME}Config.py")
ENDMACRO(CONFIGURE_PYTHON_CONFIG_FILES)


MACRO(CONFIGURE_PYTHON_LOADER_FILE outdir)
  # Create the loader file for importing just the current wrapper library. Uses
  # the global WRAPPER_LIBRARY_NAME variable.
  
  SET(CONFIG_MODULE_NAME "${WRAPPER_MODULE_NAME}")
  CONFIGURE_FILE("${WRAP_ITK_CONFIG_DIR}/LanguageSupport/ModuleLoader.py.in"
    "${outdir}/${WRAPPER_MODULE_NAME}.py"
    @ONLY IMMEDIATE)
ENDMACRO(CONFIGURE_PYTHON_LOADER_FILE)


MACRO(INSTALL_PYTHON_LOADER_FILE outdir)
  # Install the loader file for importing just the current wrapper library.
  
  INSTALL_FILES("${WRAP_ITK_INSTALL_LOCATION}/Python"
    FILES "${outdir}/${WRAPPER_MODULE_NAME}.py")
ENDMACRO(INSTALL_PYTHON_LOADER_FILE)
