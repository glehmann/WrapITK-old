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
  
  SET(CONFIG_TEMPLATES "")
  
  
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



#------------------------------------------------------------------------------
MACRO(WRITE_SIMPLE_LANG_BEGIN MODULE)
# 'Simple' macro automatically appends the language to the end of the module
# name to import, as cswig produces library modules with the same naming 
# convention. In addition, this macro assumes that the lang module will be
# placed in the same place the libraries are.
# Use the non-simple macro to support more complex library structures.
  WRITE_LANG_BEGIN("${MODULE}#MODULE_LANG#" "${LIBRARY_OUTPUT_PATH}/${MODULE}")
ENDMACRO(WRITE_SIMPLE_LANG_BEGIN)

MACRO(WRITE_LANG_BEGIN MODULE MODULE_PATH)
# Placing '#MODULE_LANG#' in the MODULE or MODULE_PATH string will cause that
# sequence to be replaced by the current language.
   IF(WRAP_ITK_PYTHON)
      STRING(REGEX REPLACE "#MODULE_LANG#" "Python" PYTHON_MODULE_PATH "${MODULE_PATH}")
      STRING(REGEX REPLACE "#MODULE_LANG#" "Python" PYTHON_MODULE "${MODULE}")
      WRITE_PY_BEGIN("${PYTHON_MODULE_PATH}Py.py" ${PYTHON_MODULE})
   ENDIF(WRAP_ITK_PYTHON)
ENDMACRO(WRITE_LANG_BEGIN)

MACRO(WRITE_LANG_END)
   IF(WRAP_ITK_PYTHON)
      # python
      WRITE_PY_END("${PYTHON_MODULE_PATH}Py.py")
      INSTALL_FILES("${WRAP_ITK_INSTALL_LOCATION}/Python" FILES "${PYTHON_MODULE_PATH}Py.py")
   ENDIF(WRAP_ITK_PYTHON)
ENDMACRO(WRITE_LANG_END)

MACRO(WRITE_LANG_WRAP CLASS WRAP wrapPointer)
   IF(WRAP_ITK_PYTHON)
      # python
      WRITE_PY_WRAP("${PYTHON_MODULE_PATH}Py.py" ${CLASS} "${WRAP}" ${wrapPointer})
   ENDIF(WRAP_ITK_PYTHON)
ENDMACRO(WRITE_LANG_WRAP)

MACRO(WRITE_LANG_WRAP_NOTPL CLASS)
   IF(WRAP_ITK_PYTHON)
      # python
      WRITE_PY_WRAP_NOTPL("${PYTHON_MODULE_PATH}Py.py" ${CLASS} ${wrapPointer})
   ENDIF(WRAP_ITK_PYTHON)
ENDMACRO(WRITE_LANG_WRAP_NOTPL)

#------------------------------------------------------------------------------
MACRO(WRITE_PY_BEGIN FILE MODULE)
   WRITE_FILE("${FILE}"
      "# This file is generated by cmake.\n"
      "# Don't modify this file, modify the cmake files instead.\n"
      "\n"
      "import itkPyTemplate, itkbase\n"
      "__itk_import_data__ = itkbase.preimport()\n"
      "import ${MODULE} as itkModule\n"
      "itkbase.postimport(__itk_import_data__)\n"
      "del __itk_import_data__, itkbase\n"
   )
ENDMACRO(WRITE_PY_BEGIN)

MACRO(WRITE_PY_END FILE)
   WRITE_FILE("${FILE}"
      "\n"
      "del itkModule\n"
      "del itkPyTemplate\n"
      APPEND
   )
ENDMACRO(WRITE_PY_END)

MACRO(WRITE_PY_WRAP FILE CLASS WRAP wrapPointer)
   STRING(REGEX REPLACE "(.*::)" "" class_name ${CLASS})

    SET(itk_PyWrap "")
    FOREACH(wrap ${WRAP})
      STRING(REGEX REPLACE
          "([0-9A-Za-z]*)[ ]*#[ ]*(.*)"
          "try:\n       ${class_name}.__set__(\"\\2\",itkModule.itk${class_name}\\1)\nexcept:\n       print \"Warning: itk${class_name}\\1 not found\"\n"
          wrapClass "${wrap}"
      )
      SET(itk_PyWrap "${itk_PyWrap}${wrapClass}\n")
    ENDFOREACH(wrap ${WRAP})

    WRITE_FILE("${FILE}"
      "try:\n"
      "   if(not isinstance(${class_name},itkPyTemplate.itkPyTemplate)):\n"
      "      raise AttributeError\n"
      "except:\n"
      "   ${class_name} = itkPyTemplate.itkPyTemplate(\"itk${class_name}\")\n"
      "${itk_PyWrap}"
      APPEND
    )
    IF(wrapPointer)
      SET(itk_PyWrap "")
      FOREACH(wrap ${WRAP})
        STRING(REGEX REPLACE
            "([0-9A-Za-z]*)[ ]*#[ ]*(.*)"
            "try:\n       SmartPointer.__set__(\"itk::${class_name}<\\2>\",itkModule.itk${class_name}\\1_Pointer)\nexcept:\n       print \"Warning: itk${class_name}\\1_Pointer not found\"\n"
            wrapClass "${wrap}"
        )
        SET(itk_PyWrap "${itk_PyWrap}${wrapClass}\n")
      ENDFOREACH(wrap ${WRAP})
  
      WRITE_FILE("${FILE}"
        "try:\n"
        "   if(not isinstance(SmartPointer,itkPyTemplate.itkPyTemplate)):\n"
        "      raise AttributeError\n"
        "except:\n"
        "   SmartPointer = itkPyTemplate.itkPyTemplate(\"itkSmartPointer\")\n"
        "${itk_PyWrap}"
        APPEND
      )
    ENDIF(wrapPointer)
ENDMACRO(WRITE_PY_WRAP)

MACRO(WRITE_PY_WRAP_NOTPL FILE CLASS wrapPointer)
  STRING(REGEX REPLACE "(.*::)" "" class_name ${CLASS})

  # Find Tcl or Tk references... unvailable in python
  SET(tcltk_class FALSE)
  IF("${CLASS}" MATCHES "^Tcl.*")
    SET(tcltk_class TRUE)
  ENDIF("${CLASS}" MATCHES "^Tcl.*")
  IF("${CLASS}" MATCHES "^Tk.*")
    SET(tcltk_class TRUE)
  ENDIF("${CLASS}" MATCHES "^Tk.*")

  IF(NOT tcltk_class)
    WRITE_FILE("${FILE}"
      "try:\n"
      "   if(not ${class_name}==itkModule.itk${class_name}):\n"
      "      raise AttributeError\n"
      "except:\n"
      "   try:\n"
      "      ${class_name} = itkModule.itk${class_name}\n"
      "      itkPyTemplate.registerNoTpl(\"itk::${class_name}\", itkModule.itk${class_name})\n"
      "   except:\n"
      "      print \"Warning: itk${class_name} not found\"\n"
      APPEND
    )
    IF(wrapPointer)
      WRITE_FILE("${FILE}"
        "try:\n"
        "   if(not isinstance(SmartPointer,itkPyTemplate.itkPyTemplate)):\n"
        "      raise AttributeError\n"
        "except:\n"
        "   SmartPointer = itkPyTemplate.itkPyTemplate(\"itkSmartPointer\")\n"
        "try:\n"
        "   SmartPointer.__set__(\"itk::${class_name}\",itkModule.itk${class_name}_Pointer)\n"
        "except:\n"
        "   print \"Warning: itk${class_name}_Pointer not found\"\n"
        APPEND
      )
    ENDIF(wrapPointer)
  ENDIF(NOT tcltk_class)
ENDMACRO(WRITE_PY_WRAP_NOTPL)

#------------------------------------------------------------------------------

