################################################################################
# Macro definitions for creating proper CableSwig input files from wrap_*.cmake
# files.
# This file includes definitions for the macros to call from a CMakeList file
# to cause wrap_*.cmake files to be turned into CXX files, and definitions for
# the macros to use in the wrap_*.cmake files themselves to declare that certain
# classes and template instantiations be wrapped.
# Note on convention: variable names in ALL_CAPS are global, and shared between
# macros or between CMake and files that are configured. Variable names in
# lower_case are local to a given macro.
################################################################################


################################################################################
# Macros for finding and processing wrap_*.cmake files.
################################################################################

MACRO(WRAPPER_LIBRARY_CREATE_WRAP_FILES)
  # Include the wrap_*.cmake files in WRAPPER_LIBRARY_SOURCE_DIR. This causes 
  # corresponding wrap_*.cxx files to be generated WRAPPER_LIBRARY_OUTPUT_DIR, 
  # and added to the WRAPPER_LIBRARY_CABLESWIG_INPUTS list.
  # In addition, this causes the other required wrap_*.cxx files for the entire
  # library and each wrapper language to be created.
  # Finally, this macro causes the language support files for the templates and
  # library here defined to be created.

  # First, include modules already in WRAPPER_LIBRARY_GROUPS, because those are
  # guaranteed to be processed first.
  FOREACH(module ${WRAPPER_LIBRARY_GROUPS})
      INCLUDE_WRAP_CMAKE("${module}")
  ENDFOREACH(module)

  # Now search for other wrap_*.cmake files to include
  FILE(GLOB wrap_cmake_files "${WRAPPER_LIBRARY_SOURCE_DIR}/wrap_*.cmake")
  FOREACH(file ${wrap_cmake_files})
    # get the module name from wrap_module.cmake
    GET_FILENAME_COMPONENT(module "${file}" NAME_WE)
    STRING(REGEX REPLACE "^wrap_" "" module "${module}")

    # if the module is already in the list, it means that it is already included
    # ... and do not include excluded modules
    SET(will_include 1)
    FOREACH(already_included ${WRAPPER_LIBRARY_GROUPS})
      IF("${already_included}" STREQUAL "${module}")
        SET(will_include 0)
      ENDIF("${already_included}" STREQUAL "${module}")
    ENDFOREACH(already_included)

    IF(${will_include})
      # Add the module name to the list. WRITE_MODULE_FILES uses this list
      # to create the master library wrapper file.
      SET(WRAPPER_LIBRARY_GROUPS ${WRAPPER_LIBRARY_GROUPS} "${module}")
      INCLUDE_WRAP_CMAKE("${module}")
    ENDIF(${will_include})
  ENDFOREACH(file)
  
  WRITE_MODULE_FILES()
ENDMACRO(WRAPPER_LIBRARY_CREATE_WRAP_FILES)


MACRO(INCLUDE_WRAP_CMAKE module)
  # include a cmake module file and generate the associated wrap_*.cxx file.
  # This basically sets the global vars that will be added to or modified
  # by the commands in the included wrap_*.cmake module.
  #
  # Global vars used: none
  # Global vars modified: WRAPPER_MODULE_NAME WRAPPER_FILE_NAME WRAPPER_TYPEDEFS
  #                       WRAPPER_INCLUDE_FILES WRAPPER_AUTO_INCLUDE_HEADERS

  # We run into some trouble if there's a module with the same name as the
  # wrapper library. Fix this.
  STRING(TOUPPER "${module}" upper_module)
  STRING(TOUPPER "${WRAPPER_LIBRARY_NAME}" upper_lib)
  IF("${upper_module}" STREQUAL "${upper_lib}")
    SET(module "${module}_module")
  ENDIF("${upper_module}" STREQUAL "${upper_lib}")
 
  # preset the vars before include the file
  SET(WRAPPER_MODULE_NAME "${module}")
  SET(WRAPPER_FILE_NAME "${WRAPPER_LIBRARY_OUTPUT_DIR}/wrap_${module}.cxx")
  SET(WRAPPER_TYPEDEFS)
  SET(WRAPPER_INCLUDE_FILES ${WRAPPER_DEFAULT_INCLUDE})
  SET(WRAPPER_AUTO_INCLUDE_HEADERS ON)

  # now include the file
  INCLUDE("${WRAPPER_LIBRARY_SOURCE_DIR}/wrap_${module}.cmake")

  # and write the file
  WRITE_WRAP_CXX()
ENDMACRO(INCLUDE_WRAP_CMAKE)


MACRO(WRITE_WRAP_CXX)
  # write the wrap_*.cxx file
  #
  # Global vars used: WRAPPER_FILE_NAME WRAPPER_INCLUDE_FILES WRAPPER_MODULE_NAME and WRAPPER_TYPEDEFS
  # Global vars modified: none

  IF(WRAPPER_TYPEDEFS)
    # If no types were defined, don't bother with writing the file or adding it
    # to the list!
    
    # Create the '#include' statements.
    SET(CONFIG_WRAPPER_INCLUDES)
    FOREACH(inc ${WRAPPER_INCLUDE_FILES})
      SET(CONFIG_WRAPPER_INCLUDES "${CONFIG_WRAPPER_INCLUDES}#include \"itk${inc}.h\"\n")
    ENDFOREACH(inc)
    SET(CONFIG_WRAPPER_MODULE_NAME "${WRAPPER_MODULE_NAME}")
    SET(CONFIG_WRAPPER_TYPEDEFS "${WRAPPER_TYPEDEFS}")

    # Create the cxx file
    CONFIGURE_FILE(
      "${WRAP_ITK_CONFIG_DIR}/wrap_.cxx.in"
      "${WRAPPER_FILE_NAME}"
      @ONLY IMMEDIATE)
    
    # And add the cxx file to the list of cableswig inputs.
    SET(WRAPPER_LIBRARY_CABLESWIG_INPUTS 
      ${WRAPPER_LIBRARY_CABLESWIG_INPUTS} "${WRAPPER_FILE_NAME}")
  ENDIF(WRAPPER_TYPEDEFS)
ENDMACRO(WRITE_WRAP_CXX)


################################################################################
# Macros for writing the global module CableSwig inputs which specify all the
# groups to be bundled together into one module. 
################################################################################

MACRO(WRITE_MODULE_FILES)
  # Write the wrap_LIBRARY_NAME.cxx file which specifies all the wrapped groups.
  
  SET(group_list "")
  FOREACH(group_name ${WRAPPER_LIBRARY_GROUPS})
    SET(group_list "${group_list}    \"${group_name}\",\n")
  ENDFOREACH(group_name ${group})
  STRING(REGEX REPLACE ",\n$" "\n" group_list "${group_list}")

  SET(CONFIG_GROUP_LIST "${group_list}")
  CONFIGURE_FILE(
    "${WRAP_ITK_CONFIG_DIR}/wrap_ITK.cxx.in"
    "${WRAPPER_LIBRARY_OUTPUT_DIR}/wrap_${WRAPPER_LIBRARY_NAME}.cxx"
    @ONLY IMMEDIATE)

  IF(WRAP_ITK_TCL)
    WRITE_MODULE_FOR_LANGUAGE("Tcl")
  ENDIF(WRAP_ITK_TCL)
  IF(WRAP_ITK_PYTHON)
    WRITE_MODULE_FOR_LANGUAGE("Python")
  ENDIF(WRAP_ITK_PYTHON)
  IF(WRAP_ITK_JAVA)
    WRITE_MODULE_FOR_LANGUAGE("Java")
  ENDIF(WRAP_ITK_JAVA)
  IF(WRAP_ITK_PERL)
    WRITE_MODULE_FOR_LANGUAGE("Perl")
  ENDIF(WRAP_ITK_PERL)
ENDMACRO(WRITE_MODULE_FILES)

MACRO(WRITE_MODULE_FOR_LANGUAGE language)
  # Write the language specific CableSwig input which declares which language is
  # to be used and includes the general module cableswig input.
  SET(CONFIG_LANGUAGE "${language}")
  SET(CONFIG_MODULE_NAME ${WRAPPER_LIBRARY_NAME})
  STRING(TOUPPER ${language} CONFIG_UPPER_LANG)
  CONFIGURE_FILE(
    "${WRAP_ITK_CONFIG_DIR}/wrap_ITKLang.cxx.in"
    "${WRAPPER_LIBRARY_OUTPUT_DIR}/wrap_${WRAPPER_LIBRARY_NAME}${language}.cxx"
    @ONLY IMMEDIATE)
ENDMACRO(WRITE_MODULE_FOR_LANGUAGE)


################################################################################
# Macros to be used in the wrap_*.cmake files themselves.
# These macros specify that a class is to be wrapped, that certain itk headers
# are to be included, and what specific template instatiations are to be wrapped.
################################################################################

MACRO(WRAP_CLASS class)
  # Begin the wrapping of a new templated class. The 'class' parameter is a 
  # fully-qualified C++ type name. Between WRAP_CLASS and END_WRAP_CLASS
  # various macros should be called to cause certain template instances to be
  # automatically added to the wrap_*.cxx file. END_WRAP_CLASS actually parses
  # through the template instaces that have been recorded and creates the content
  # of that cxx file. WRAP_NON_TEMPLATE_CLASS should be used to create a definition
  # for a non-templated class.
  # This class takes an optional 'wrap method' parameter. Valid values are:
  # POINTER, POINTER_WITH_SUPERCLASS, DEREF and SELF. 
  # TODO: document what each of these methods does!
  #
  # Global vars used: none
  # Global vars modified: WRAPPER_CLASS WRAPPER_TEMPLATES WRAPPER_INCLUDE_FILES
  #                       WRAPPER_WRAP_METHOD

  # first, we must be sure the wrap method is valid
  IF("${ARGC}" EQUAL 1)
    # store the wrap method
    SET(WRAPPER_WRAP_METHOD "")
  ENDIF("${ARGC}" EQUAL 1)

  IF("${ARGC}" EQUAL 2)
    SET(WRAPPER_WRAP_METHOD "${ARGV1}")
    SET(ok 0)
    FOREACH(opt POINTER POINTER_WITH_SUPERCLASS DEREF SELF)
      IF("${opt}" STREQUAL "${WRAPPER_WRAP_METHOD}")
        SET(ok 1)
      ENDIF("${opt}" STREQUAL "${WRAPPER_WRAP_METHOD}")
    ENDFOREACH(opt)
    IF(ok EQUAL 0)
      MESSAGE(SEND_ERROR "WRAP_CLASS: Invalid option '${WRAPPER_WRAP_METHOD}'. Possible values are POINTER, POINTER_WITH_SUPERCLASS, DEREF and SELF")
    ENDIF(ok EQUAL 0)
  ENDIF("${ARGC}" EQUAL 2)

  IF("${ARGC}" EQUAL 3)
    MESSAGE(SEND_ERROR "Too many arguments")
  ENDIF("${ARGC}" EQUAL 3)


  SET(WRAPPER_CLASS ${class})
  # drop the namespace prefix
  STRING(REGEX REPLACE "(.*::)" "" class_name ${class})
  # clear the wrap parameters
  SET(WRAPPER_TEMPLATES)
  # and include the class's header
  IF(WRAPPER_AUTO_INCLUDE_HEADERS)
    WRAP_INCLUDE(${class_name})
  ENDIF(WRAPPER_AUTO_INCLUDE_HEADERS)
ENDMACRO(WRAP_CLASS)


MACRO(WRAP_INCLUDE include_file)
  # Add a header file to the list of files to be #included in the final 
  # cxx file. This list is actually processed in WRITE_WRAP_CXX.
  #
  # Global vars used: WRAPPER_INCLUDE_FILES
  # Global vars modified: WRAPPER_INCLUDE_FILES
  SET(already_included 0)
  FOREACH(included ${WRAPPER_INCLUDE_FILES})
    IF("${include_file}" STREQUAL "${already_included}")
      SET(already_included 1)
    ENDIF("${include_file}" STREQUAL "${already_included}")
  ENDFOREACH(included)
  
  IF(NOT already_included)
    # include order IS important. Default values must be before the other ones
    SET(WRAPPER_INCLUDE_FILES 
      ${WRAPPER_INCLUDE_FILES}
      ${include_file}
    )
  ENDIF(NOT already_included)
ENDMACRO(WRAP_INCLUDE)


MACRO(END_WRAP_CLASS)
  # Parse through the list of WRAPPER_TEMPLATES set up by the macros at the bottom
  # of this file, turning them into proper C++ type definitions suitable for
  # input to CableSwig. The C++ definitions are stored in WRAPPER_TYPEDEFS.
  #
  # TODO: Currently this only supports classes in the itk namespace because
  # the namespace is hard-coded. This should be fixed.
  #
  # Global vars used: WRAPPER_CLASS WRAPPER_WRAP_METHOD WRAPPER_TEMPLATES
  # Global vars modified: WRAPPER_TYPEDEFS

  # remove the namespace prefix
  STRING(REGEX REPLACE "(.*::)" "" class_name ${WRAPPER_CLASS})
  # the regexp used to get the values separated by a #
  SET(sharp_regexp "([0-9A-Za-z]*)[ ]*#[ ]*(.*)")
  SET(wrap_class)
  SET(wrap_pointer 0)

  # insert a blank line to separate the classes
  SET(WRAPPER_TYPEDEFS "${WRAPPER_TYPEDEFS}      \n")
  
  IF("${WRAPPER_WRAP_METHOD}" STREQUAL "")
    FOREACH(wrap ${WRAPPER_TEMPLATES})
      STRING(REGEX REPLACE
        "${sharp_regexp}"
        "typedef itk::${WRAPPER_CLASS}< \\2 > itk${class_name}\\1"
        wrap_class "${wrap}"
      )
      SET(WRAPPER_TYPEDEFS "${WRAPPER_TYPEDEFS}      ${wrap_class};\n")
    ENDFOREACH(wrap)
  ENDIF("${WRAPPER_WRAP_METHOD}" STREQUAL "")

  IF("${WRAPPER_WRAP_METHOD}" STREQUAL "POINTER")
    SET(wrap_pointer 1)
    FOREACH(wrap ${WRAPPER_TEMPLATES})
      STRING(REGEX REPLACE
        "${sharp_regexp}"
        "typedef itk::${WRAPPER_CLASS}< \\2 >::${class_name} itk${class_name}\\1;\n      typedef itk::${WRAPPER_CLASS}< \\2 >::Pointer::SmartPointer itk${class_name}\\1_Pointer"
        wrap_class "${wrap}"
      )
      SET(WRAPPER_TYPEDEFS "${WRAPPER_TYPEDEFS}      ${wrap_class};\n")
    ENDFOREACH(wrap)
  ENDIF("${WRAPPER_WRAP_METHOD}" STREQUAL "POINTER")

  IF("${WRAPPER_WRAP_METHOD}" STREQUAL "POINTER_WITH_SUPERCLASS")
    SET(wrap_pointer 1)
    FOREACH(wrap ${WRAPPER_TEMPLATES})
      STRING(REGEX REPLACE
        "${sharp_regexp}"
        "typedef itk::${WRAPPER_CLASS}< \\2 >::${class_name} itk${class_name}\\1;\n      typedef itk::${WRAPPER_CLASS}< \\2 >::Pointer::SmartPointer itk${class_name}\\1_Pointer;\n      typedef itk::${WRAPPER_CLASS}< \\2 >::Superclass::Self itk${class_name}\\1_Superclass;\n      typedef itk::${WRAPPER_CLASS}< \\2 >::Superclass::Pointer::SmartPointer itk${class_name}\\1_Superclass_Pointer"
        wrap_class "${wrap}"
      )
      SET(WRAPPER_TYPEDEFS "${WRAPPER_TYPEDEFS}      ${wrap_class};\n")
    ENDFOREACH(wrap)
  ENDIF("${WRAPPER_WRAP_METHOD}" STREQUAL "POINTER_WITH_SUPERCLASS")

  IF("${WRAPPER_WRAP_METHOD}" STREQUAL "DEREF")
    FOREACH(wrap ${WRAPPER_TEMPLATES})
      STRING(REGEX REPLACE
        "${sharp_regexp}"
        "typedef itk::${WRAPPER_CLASS}< \\2 >::${class_name} itk${class_name}\\1"
        wrap_class "${wrap}"
      )
      SET(WRAPPER_TYPEDEFS "${WRAPPER_TYPEDEFS}      ${wrap_class};\n")
    ENDFOREACH(wrap)
  ENDIF("${WRAPPER_WRAP_METHOD}" STREQUAL "DEREF")

  IF("${WRAPPER_WRAP_METHOD}" STREQUAL "SELF")
    FOREACH(wrap ${WRAPPER_TEMPLATES})
      STRING(REGEX REPLACE
        "${sharp_regexp}"
        "typedef itk::${WRAPPER_CLASS}< \\2 >::Self itk${class_name}\\1"
        wrap_class "${wrap}"
      )
      SET(WRAPPER_TYPEDEFS "${WRAPPER_TYPEDEFS}      ${wrap_class};\n")
    ENDFOREACH(wrap)
  ENDIF("${WRAPPER_WRAP_METHOD}" STREQUAL "SELF")

  IF(wrap_pointer)
    FOREACH(wrap ${WRAPPER_TEMPLATES})
      STRING(REGEX REPLACE "${sharp_regexp}" "itk::${WRAPPER_CLASS}< \\2 >" typemap_type "${wrap}")
      SMART_POINTER_TYPEMAP(${typemap_type})
    ENDFOREACH(wrap)
  ENDIF(wrap_pointer)
  
  LANGUAGE_SUPPORT_ADD_CLASS("${class_name}" "itk::${WRAPPER_CLASS}" "itk${class_name}"
    "${WRAPPER_TEMPLATES}" ${wrap_pointer})
ENDMACRO(END_WRAP_CLASS)


MACRO(WRAP_NON_TEMPLATE_CLASS class)
  # Similar to END_WRAP_CLASS in that it generates typedefs for CableSwig input.
  # However, since no templates need to be declared, there's no need for 
  # WRAP_CLASS ... (declare templates) .. END_WRAP_CLASS. Instead
  # WRAP_NON_TEMPLATE_CLASS takes care of it all.
  #
  # TODO: Currently this only supports classes in the itk namespace because
  # the namespace is hard-coded. This should be fixed.
  #
  # Global vars used: none 
  # Global vars modified: WRAPPER_WRAP_METHOD

  SET(wrap_pointer 0)
  # first, we must be sure the wrapMethod is valid
  IF("${ARGC}" EQUAL 1)
    # store the wrap method
    SET(WRAPPER_WRAP_METHOD "")
  ENDIF("${ARGC}" EQUAL 1)

  IF("${ARGC}" EQUAL 2)
    SET(WRAPPER_WRAP_METHOD "${ARGV1}")
    SET(ok 0)
    FOREACH(opt POINTER POINTER_WITH_SUPERCLASS DEREF SELF)
      IF("${opt}" STREQUAL "${WRAPPER_WRAP_METHOD}")
        SET(ok 1)
      ENDIF("${opt}" STREQUAL "${WRAPPER_WRAP_METHOD}")
    ENDFOREACH(opt)
    IF(ok EQUAL 0)
      MESSAGE(SEND_ERROR "WRAP_CLASS: Invalid option '${WRAPPER_WRAP_METHOD}'. Possible values are POINTER, POINTER_WITH_SUPERCLASS, DEREF and SELF")
    ENDIF(ok EQUAL 0)
  ENDIF("${ARGC}" EQUAL 2)

  IF("${ARGC}" EQUAL 3)
    MESSAGE(SEND_ERROR "Too much arguments")
  ENDIF("${ARGC}" EQUAL 3)

  STRING(REGEX REPLACE "(.*::)" "" class_name ${class})

  IF(WRAPPER_AUTO_INCLUDE_HEADERS)
    WRAP_INCLUDE(${class_name})
  ENDIF(WRAPPER_AUTO_INCLUDE_HEADERS)

  # insert a blank line to separate the classes
  SET(WRAPPER_TYPEDEFS "${WRAPPER_TYPEDEFS}      \n")
  
  IF("${WRAPPER_WRAP_METHOD}" STREQUAL "")
    SET(WRAPPER_TYPEDEFS "${WRAPPER_TYPEDEFS}      typedef itk::${class} itk${class_name};\n")
  ENDIF("${WRAPPER_WRAP_METHOD}" STREQUAL "")

  IF("${WRAPPER_WRAP_METHOD}" STREQUAL "POINTER")
    SET(wrap_pointer 1)
    SET(WRAPPER_TYPEDEFS "${WRAPPER_TYPEDEFS}      typedef itk::${class}::${class_name} itk${class_name};\n")
    SET(WRAPPER_TYPEDEFS "${WRAPPER_TYPEDEFS}      typedef itk::${class}::Pointer::SmartPointer itk${class_name}_Pointer;\n")
  ENDIF("${WRAPPER_WRAP_METHOD}" STREQUAL "POINTER")

  IF("${WRAPPER_WRAP_METHOD}" STREQUAL "POINTER_WITH_SUPERCLASS")
    SET(wrap_pointer 1)
    SET(WRAPPER_TYPEDEFS "${WRAPPER_TYPEDEFS}      typedef itk::${class}::${class_name} itk${class_name};\n")
    SET(WRAPPER_TYPEDEFS "${WRAPPER_TYPEDEFS}      typedef itk::${class}::Pointer::SmartPointer itk${class_name}_Pointer;\n")
    SET(WRAPPER_TYPEDEFS "${WRAPPER_TYPEDEFS}      typedef itk::${class}::Superclass::Self itk${class_name}_Superclass;\n")
    SET(WRAPPER_TYPEDEFS "${WRAPPER_TYPEDEFS}      typedef itk::${class}::Superclass::Pointer::SmartPointer itk${class_name}_Superclass_Pointer;\n")
  ENDIF("${WRAPPER_WRAP_METHOD}" STREQUAL "POINTER_WITH_SUPERCLASS")

  IF("${WRAPPER_WRAP_METHOD}" STREQUAL "DEREF")
    SET(WRAPPER_TYPEDEFS "${WRAPPER_TYPEDEFS}      typedef itk::${class}::${class_name} itk${class_name};\n")
  ENDIF("${WRAPPER_WRAP_METHOD}" STREQUAL "DEREF")

  IF("${WRAPPER_WRAP_METHOD}" STREQUAL "SELF")
    SET(WRAPPER_TYPEDEFS "${WRAPPER_TYPEDEFS}      typedef itk::${class}::Self itk${class_name};\n")
  ENDIF("${WRAPPER_WRAP_METHOD}" STREQUAL "SELF")
  
  IF(wrap_pointer)
    SMART_POINTER_TYPEMAP("itk::${class}")
  ENDIF(wrap_pointer)

  LANGUAGE_SUPPORT_ADD_NON_TEMPLATE_CLASS("${class_name}" "itk::${class}" "itk${class_name}"
    ${wrap_pointer})
ENDMACRO(WRAP_NON_TEMPLATE_CLASS)


MACRO(SMART_POINTER_TYPEMAP typemap_type)
  SET(WRAP_ITK_TYPEMAP_TEXT "${WRAP_ITK_TYPEMAP_TEXT}%typemap(out) ${typemap_type} * {\n")
  SET(WRAP_ITK_TYPEMAP_TEXT "${WRAP_ITK_TYPEMAP_TEXT}  std::string methodName = \"\$symname\";\n")
  SET(WRAP_ITK_TYPEMAP_TEXT "${WRAP_ITK_TYPEMAP_TEXT}  if(methodName.find(\"GetPointer\") != -1) {\n")
  SET(WRAP_ITK_TYPEMAP_TEXT "${WRAP_ITK_TYPEMAP_TEXT}    // really return a pointer in that case\n")
  SET(WRAP_ITK_TYPEMAP_TEXT "${WRAP_ITK_TYPEMAP_TEXT}    \$result = SWIG_NewPointerObj((void *)(\$1), \$1_descriptor, 1);\n")
  SET(WRAP_ITK_TYPEMAP_TEXT "${WRAP_ITK_TYPEMAP_TEXT}  } else {\n")
  SET(WRAP_ITK_TYPEMAP_TEXT "${WRAP_ITK_TYPEMAP_TEXT}    itk::SmartPointer<${typemap_type} > * ptr;\n")
  SET(WRAP_ITK_TYPEMAP_TEXT "${WRAP_ITK_TYPEMAP_TEXT}    ptr = new itk::SmartPointer<${typemap_type} >(\$1);\n")
  SET(WRAP_ITK_TYPEMAP_TEXT "${WRAP_ITK_TYPEMAP_TEXT}    \$result = SWIG_NewPointerObj((void *)(ptr), \$descriptor(itk::SmartPointer<${typemap_type} > *), 1);\n")
  SET(WRAP_ITK_TYPEMAP_TEXT "${WRAP_ITK_TYPEMAP_TEXT}  }\n")
  SET(WRAP_ITK_TYPEMAP_TEXT "${WRAP_ITK_TYPEMAP_TEXT}}\n")
  SET(WRAP_ITK_TYPEMAP_TEXT "${WRAP_ITK_TYPEMAP_TEXT}%typemap(in) ${typemap_type} * {\n")
  SET(WRAP_ITK_TYPEMAP_TEXT "${WRAP_ITK_TYPEMAP_TEXT}  itk::SmartPointer< ${typemap_type} > * sptr;\n")
  SET(WRAP_ITK_TYPEMAP_TEXT "${WRAP_ITK_TYPEMAP_TEXT}  ${typemap_type} * ptr;\n")
  SET(WRAP_ITK_TYPEMAP_TEXT "${WRAP_ITK_TYPEMAP_TEXT}  if ((SWIG_ConvertPtr($input,(void **) &sptr, $descriptor(itk::SmartPointer< ${typemap_type} > *), SWIG_POINTER_EXCEPTION)) != -1) {\n")
  SET(WRAP_ITK_TYPEMAP_TEXT "${WRAP_ITK_TYPEMAP_TEXT}    // it's a SmartPointer. Get the pointer and return it\n")
  SET(WRAP_ITK_TYPEMAP_TEXT "${WRAP_ITK_TYPEMAP_TEXT}    $1 = sptr->GetPointer();\n")
  SET(WRAP_ITK_TYPEMAP_TEXT "${WRAP_ITK_TYPEMAP_TEXT}  } else if ((SWIG_ConvertPtr($input,(void **) &ptr, $1_descriptor, SWIG_POINTER_EXCEPTION)) != -1) {\n")
  SET(WRAP_ITK_TYPEMAP_TEXT "${WRAP_ITK_TYPEMAP_TEXT}    // we have a simple pointer. Just return it\n")
  SET(WRAP_ITK_TYPEMAP_TEXT "${WRAP_ITK_TYPEMAP_TEXT}    $1 = ptr;\n")
  SET(WRAP_ITK_TYPEMAP_TEXT "${WRAP_ITK_TYPEMAP_TEXT}  } else {\n")
  SET(WRAP_ITK_TYPEMAP_TEXT "${WRAP_ITK_TYPEMAP_TEXT}    // not a pointer nor a SmartPointer... typemap fail !\n")
  SET(WRAP_ITK_TYPEMAP_TEXT "${WRAP_ITK_TYPEMAP_TEXT}    SWIG_fail;\n")
  SET(WRAP_ITK_TYPEMAP_TEXT "${WRAP_ITK_TYPEMAP_TEXT}  }\n")
  SET(WRAP_ITK_TYPEMAP_TEXT "${WRAP_ITK_TYPEMAP_TEXT}  // clean the error before exit\n")
  SET(WRAP_ITK_TYPEMAP_TEXT "${WRAP_ITK_TYPEMAP_TEXT}  PyErr_Clear();\n")
  SET(WRAP_ITK_TYPEMAP_TEXT "${WRAP_ITK_TYPEMAP_TEXT}}\n")
  SET(WRAP_ITK_TYPEMAP_TEXT "${WRAP_ITK_TYPEMAP_TEXT}%typemap(typecheck) ${typemap_type} * {\n")
  SET(WRAP_ITK_TYPEMAP_TEXT "${WRAP_ITK_TYPEMAP_TEXT}  void *ptr;\n")
  SET(WRAP_ITK_TYPEMAP_TEXT "${WRAP_ITK_TYPEMAP_TEXT}  if (SWIG_ConvertPtr(\$input, &ptr, \$1_descriptor, 0) == -1\n")
  SET(WRAP_ITK_TYPEMAP_TEXT "${WRAP_ITK_TYPEMAP_TEXT}      && SWIG_ConvertPtr(\$input, &ptr, \$descriptor(itk::SmartPointer<${typemap_type} > *), 0) == -1) {\n")
  SET(WRAP_ITK_TYPEMAP_TEXT "${WRAP_ITK_TYPEMAP_TEXT}    _v = 0;\n")
  SET(WRAP_ITK_TYPEMAP_TEXT "${WRAP_ITK_TYPEMAP_TEXT}    PyErr_Clear();\n")
  SET(WRAP_ITK_TYPEMAP_TEXT "${WRAP_ITK_TYPEMAP_TEXT}  } else {\n")
  SET(WRAP_ITK_TYPEMAP_TEXT "${WRAP_ITK_TYPEMAP_TEXT}    _v = 1;\n")
  SET(WRAP_ITK_TYPEMAP_TEXT "${WRAP_ITK_TYPEMAP_TEXT}  }\n")
  SET(WRAP_ITK_TYPEMAP_TEXT "${WRAP_ITK_TYPEMAP_TEXT}}\n")
ENDMACRO(SMART_POINTER_TYPEMAP)

################################################################################
# Macros which cause one or more template instantiations to be added to the
# WRAPPER_TEMPLATES list. This list is initialized by the macro WRAP_CLASS above,
# and used by the macro END_WRAP_CLASS to produce the wrap_xxx.cxx files with
# the correct templates. These cxx files serve as the CableSwig inputs.
################################################################################


MACRO(WRAP name types)
  # This is the fundamental macro for adding a template to be wrapped.
  # 'name' is a mangled suffix to be added to the class name (defined in WRAP_CLASS)
  # to uniquely identify this instantiation.
  # 'types' is a comma-separated list of the template parameters (in C++ form),
  # some common parameters (e.g. for images) are stored in variables by 
  # WrapTypeBase.cmake and WrapTypePrefix.cmake.
  # 
  # The format of the WRAPPER_TEMPLATES list is a series of "name # types" strings
  # (because there's no CMake support for nested lists, name and types are 
  # separated out from the strings with a regex).
  #
  # Global vars used: WRAPPER_TEMPLATES
  # Global vars modified: WRAPPER_TEMPLATES

  SET(WRAPPER_TEMPLATES ${WRAPPER_TEMPLATES} "${name} # ${types}")
ENDMACRO(WRAP)


MACRO(COND_WRAP name types conditions)
  # COND_WRAP will call WRAP(name types) only if the wrapping types selected
  # in cmake (e.g. WRAP_unsigned_char) match one of the conditions listed in
  # the 'conditions' parameter.
  
  SET(will_wrap 1)
  FOREACH(t ${conditions})
    IF("${t}" STREQUAL "UC")
      IF(NOT WRAP_unsigned_char)
        SET(will_wrap 0)
      ENDIF(NOT WRAP_unsigned_char)
    ENDIF("${t}" STREQUAL "UC")

    IF("${t}" STREQUAL "US")
      IF(NOT WRAP_unsigned_short)
        SET(will_wrap 0)
      ENDIF(NOT WRAP_unsigned_short)
    ENDIF("${t}" STREQUAL "US")

    IF("${t}" STREQUAL "UL")
      IF(NOT WRAP_unsigned_long)
        SET(will_wrap 0)
      ENDIF(NOT WRAP_unsigned_long)
    ENDIF("${t}" STREQUAL "UL")

    IF("${t}" STREQUAL "SC")
      IF(NOT WRAP_signed_char)
        SET(will_wrap 0)
      ENDIF(NOT WRAP_signed_char)
    ENDIF("${t}" STREQUAL "SC")

    IF("${t}" STREQUAL "SS")
      IF(NOT WRAP_signed_short)
        SET(will_wrap 0)
      ENDIF(NOT WRAP_signed_short)
    ENDIF("${t}" STREQUAL "SS")

    IF("${t}" STREQUAL "SL")
      IF(NOT WRAP_signed_long)
        SET(will_wrap 0)
      ENDIF(NOT WRAP_signed_long)
    ENDIF("${t}" STREQUAL "SL")

    IF("${t}" STREQUAL "F")
      IF(NOT WRAP_float)
        SET(will_wrap 0)
      ENDIF(NOT WRAP_float)
    ENDIF("${t}" STREQUAL "F")

    IF("${t}" STREQUAL "D")
      IF(NOT WRAP_double)
        SET(will_wrap 0)
      ENDIF(NOT WRAP_double)
    ENDIF("${t}" STREQUAL "D")

    IF("${t}" STREQUAL "VF")
      IF(NOT WRAP_vector_float)
        SET(will_wrap 0)
      ENDIF(NOT WRAP_vector_float)
    ENDIF("${t}" STREQUAL "VF")

    IF("${t}" STREQUAL "VD")
      IF(NOT WRAP_vector_double)
        SET(will_wrap 0)
      ENDIF(NOT WRAP_vector_double)
    ENDIF("${t}" STREQUAL "VD")

    IF("${t}" STREQUAL "CVF")
      IF(NOT WRAP_covariant_vector_float)
        SET(will_wrap 0)
      ENDIF(NOT WRAP_covariant_vector_float)
    ENDIF("${t}" STREQUAL "CVF")

    IF("${t}" STREQUAL "CVD")
      IF(NOT WRAP_covariant_vector_double)
        SET(will_wrap 0)
      ENDIF(NOT WRAP_covariant_vector_double)
    ENDIF("${t}" STREQUAL "CVD")

    IF("${t}" STREQUAL "RGBUC")
      IF(NOT WRAP_rgb_unsigned_char)
        SET(will_wrap 0)
      ENDIF(NOT WRAP_rgb_unsigned_char)
    ENDIF("${t}" STREQUAL "RGBUC")

    IF("${t}" STREQUAL "RGBUS")
      IF(NOT WRAP_rgb_unsigned_short)
        SET(will_wrap 0)
      ENDIF(NOT WRAP_rgb_unsigned_short)
    ENDIF("${t}" STREQUAL "RGBUS")
  ENDFOREACH(t)

  IF(${will_wrap})
    WRAP("${name}" "${types}")
  ENDIF(${will_wrap})
ENDMACRO(COND_WRAP)


MACRO(WRAP_TYPES_DIMS size types template_dims)
  # WRAP_TYPES_DIMS filters input to WRAP_TYPES_DIMS_NO_DIM_TEST.
  # The former macro allows a "template_dims" agrument of the format "2+" to
  # specify that a given image filter is only to be instantiated for all of 
  # the user-selected (via cmake) dimensions, provided the dimension is at 
  # least 2. The size parameter refers to the number of Image classes that
  # must be in the template definition. (E.g. Filter<Image, Image> has size of
  # 2. The types parameter refers to the image pixel types to be wrapped.

  IF("${template_dims}" MATCHES "^[0-9]+\\+$")
    # If the parameter is of form '2+', make a list of the user-selected
    # dimensions (WRAP_DIMS) that match this criterion.
    STRING(REGEX REPLACE "^([0-9]+)\\+$" "\\1" MIN_DIM "${template_dims}")
    SET(dims )
    FOREACH(d ${WRAP_DIMS})
      IF("${d}" GREATER "${MIN_DIM}" OR "${d}" EQUAL "${MIN_DIM}")
        SET(dims ${dims} "${d}")
      ENDIF("${d}" GREATER "${MIN_DIM}" OR "${d}" EQUAL "${MIN_DIM}")
    ENDFOREACH(d)
    WRAP_TYPES_DIMS_NO_DIM_TEST("${size}" "${types}" "${dims}")

  ELSE("${template_dims}" MATCHES "^[0-9]+\\+$")
    # Otherwise, jsut make a list of the intersection between the user-selected
    # dimensions and the allowed dimensions provided by the parameter.
    SET(dims )
    FOREACH(d ${WRAP_DIMS})
      FOREACH(td ${template_dims})
        IF(d EQUAL td)
          SET(dims ${dims} ${d})
        ENDIF(d EQUAL td)
      ENDFOREACH(td)
    ENDFOREACH(d)
    WRAP_TYPES_DIMS_NO_DIM_TEST("${size}" "${types}" "${dims}")

  ENDIF("${template_dims}" MATCHES "^[0-9]+\\+$")
ENDMACRO(WRAP_TYPES_DIMS)

MACRO(WRAP_TYPES_DIMS_NO_DIM_TEST size types dims)
  # WRAP_TYPES_DIMS_NO_DIM_TEST wraps a given filter for all of the user-
  # specified wrap dimensions. The size parameter refers to the number of Image 
  # classes that must be in the template definition. (E.g. Filter<Image, Image> 
  # has size of 2. The types parameter refers to the image pixel types to be wrapped.

  FOREACH(dim ${dims})
    FOREACH(type ${types})
      SET(name "")
      SET(params "")
      FOREACH(i RANGE 1 ${size})
        SET(varname "ITKM_I${type}${dim}")
        SET(name "${name}${${varname}}")
        SET(varname "ITKT_I${type}${dim}")
        SET(params "${params}${${varname}}")
        IF(NOT ${i} EQUAL ${size})
          SET(params "${params}, ")
        ENDIF(NOT ${i} EQUAL ${size})
      ENDFOREACH(i)
      COND_WRAP("${name}" "${params}" "${type}")
    ENDFOREACH(type)
  ENDFOREACH(dim)
ENDMACRO(WRAP_TYPES_DIMS_NO_DIM_TEST)


# The following macros specify that a filter is to be wrapped with 
# a specific class of pixel types (say, integral or real types).
# The exact pixel types from the class are selected by the user at 
# configure time. These macros just say, e.g., "if the user has selected 
# any or all integer types, wrap a filter with those types selected."
# As above, the size parameter refers to the number of image types required
# in the template.
# There are also variants that take a dims parameter. This parameter restricts
# the filter instantiation to specific set of dimensions. Those dimensions will
# be further restricted by the user's selection of dimensions at configure time.

MACRO(WRAP_INT_DIMS size dims)
  WRAP_TYPES_DIMS(${size} "UL;US;UC" "${dims}")
ENDMACRO(WRAP_INT_DIMS)

MACRO(WRAP_INT size)
  WRAP_INT_DIMS(${size} "${WRAP_DIMS}")
ENDMACRO(WRAP_INT)

MACRO(WRAP_SIGN_INT_DIMS size dims)
  WRAP_TYPES_DIMS(${size} "SL;SS;SC" "${dims}")
ENDMACRO(WRAP_SIGN_INT_DIMS)

MACRO(WRAP_SIGN_INT size)
  WRAP_SIGN_INT_DIMS(${size} "${WRAP_DIMS}")
ENDMACRO(WRAP_SIGN_INT)


MACRO(WRAP_REAL_DIMS size dims)
  WRAP_TYPES_DIMS(${size} "F;D" "${dims}")
ENDMACRO(WRAP_REAL_DIMS size)

MACRO(WRAP_REAL size)
  WRAP_REAL_DIMS(${size} "${WRAP_DIMS}")
ENDMACRO(WRAP_REAL size)


MACRO(WRAP_VECTOR_REAL_DIMS size dims)
  SET(ddims "")
  FOREACH(d ${dims})
    SET(ddims ${ddims} "${d}${d}")
  ENDFOREACH(d)
  WRAP_TYPES_DIMS_NO_DIM_TEST(${size} "VF;VD" "${ddims}")
ENDMACRO(WRAP_VECTOR_REAL_DIMS size)

MACRO(WRAP_VECTOR_REAL size)
  WRAP_VECTOR_REAL_DIMS(${size} "${WRAP_DIMS}")
ENDMACRO(WRAP_VECTOR_REAL size)


MACRO(WRAP_COV_VECTOR_REAL_DIMS size dims)
  SET(ddims "")
  FOREACH(d ${dims})
    SET(ddims ${ddims} "${d}${d}")
  ENDFOREACH(d)
  WRAP_TYPES_DIMS_NO_DIM_TEST(${size} "CVF;CVD" "${ddims}")
ENDMACRO(WRAP_COV_VECTOR_REAL_DIMS size)

MACRO(WRAP_COV_VECTOR_REAL size)
  WRAP_COV_VECTOR_REAL_DIMS(${size} "${WRAP_DIMS}")
ENDMACRO(WRAP_COV_VECTOR_REAL size)


MACRO(WRAP_RGB_DIMS size dims)
  WRAP_TYPES_DIMS(${size} "RGBUS;RGBUC" "${dims}")
ENDMACRO(WRAP_RGB_DIMS)

MACRO(WRAP_RGB size)
  WRAP_RGB_DIMS(${size} "${WRAP_DIMS}")
ENDMACRO(WRAP_RGB)

