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
  
  # Next, include modules already in WRAPPER_LIBRARY_GROUPS, because those are
  # guaranteed to be processed first.
  FOREACH(module ${WRAPPER_LIBRARY_GROUPS})
    # EXISTS test is to allow groups to be declared in WRAPPER_LIBRARY_GROUPS
    # which aren't represented by cmake files: e.g. groups that are created in
    # custom cableswig cxx inputs stored in WRAPPER_LIBRARY_CABLESWIG_INPUTS.
    IF(EXISTS "${WRAPPER_LIBRARY_SOURCE_DIR}/wrap_${module}.cmake")
        INCLUDE_WRAP_CMAKE("${module}")
    ENDIF(EXISTS "${WRAPPER_LIBRARY_SOURCE_DIR}/wrap_${module}.cmake")
  ENDFOREACH(module)

  # Now search for other wrap_*.cmake files to include
  FILE(GLOB wrap_cmake_files "${WRAPPER_LIBRARY_SOURCE_DIR}/wrap_*.cmake")
  # sort the list of files so we are sure to always get the same order on all system
  # and for all builds. That's important for several reasons:
  # - the order is important for the order of creation of python template
  # - the typemaps files are always the same, and the rebuild can be avoided
  SORT("wrap_cmake_files")
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


MACRO(SORT list_name)
  # Sort the list of strings with the name given in parameter
  SET(tmp1 "")
  FOREACH(l ${${list_name}})
    SET(inserted 0)
    SET(tmp2 "")
    FOREACH(l1 ${tmp1})
      IF("${l}" STRLESS "${l1}" AND ${inserted} EQUAL 0)
        SET(tmp2 ${tmp2} "${l}" "${l1}")
        SET(inserted 1)
      ELSE("${l}" STRLESS "${l1}" AND ${inserted} EQUAL 0)
        SET(tmp2 ${tmp2} "${l1}")
      ENDIF("${l}" STRLESS "${l1}" AND ${inserted} EQUAL 0)
    ENDFOREACH(l1)
    IF(${inserted} EQUAL 0)
      SET(tmp1 ${tmp1} "${l}")
    ELSE(${inserted} EQUAL 0)
      SET(tmp1 ${tmp2})
    ENDIF(${inserted} EQUAL 0)
  ENDFOREACH(l)
  SET(${list_name} ${tmp1})
ENDMACRO(SORT list)


MACRO(INCLUDE_WRAP_CMAKE module)
  # include a cmake module file and generate the associated wrap_*.cxx file.
  # This basically sets the global vars that will be added to or modified
  # by the commands in the included wrap_*.cmake module.
  #
  # Global vars used: none
  # Global vars modified: WRAPPER_MODULE_NAME WRAPPER_TYPEDEFS
  #                       WRAPPER_INCLUDE_FILES WRAPPER_AUTO_INCLUDE_HEADERS
  #                       WRAPPER_DO_NOT_CREATE_CXX

  MESSAGE(STATUS "${WRAPPER_LIBRARY_NAME}: Creating ${module} wrappers.")

  # We run into some trouble if there's a module with the same name as the
  # wrapper library. Fix this.
  STRING(TOUPPER "${module}" upper_module)
  STRING(TOUPPER "${WRAPPER_LIBRARY_NAME}" upper_lib)
  IF("${upper_module}" STREQUAL "${upper_lib}")
    SET(module "${module}_module")
  ENDIF("${upper_module}" STREQUAL "${upper_lib}")
 
  # preset the vars before include the file
  SET(WRAPPER_MODULE_NAME "${module}")
  SET(WRAPPER_TYPEDEFS)
  SET(WRAPPER_INCLUDE_FILES ${WRAPPER_DEFAULT_INCLUDE})
  SET(WRAPPER_AUTO_INCLUDE_HEADERS ON)
  SET(WRAPPER_DO_NOT_CREATE_CXX OFF)

  # Now include the file.
  INCLUDE("${WRAPPER_LIBRARY_SOURCE_DIR}/wrap_${module}.cmake")

  # Write the file, inless the included cmake file told us not to.
  # A file might declare WRAPPER_DO_NOT_CREATE_CXX if that cmake file
  # provides a custom wrap_*.cxx file and manually appends it to the 
  # WRAPPER_LIBRARY_CABLESWIG_INPUTS list; thus that file would not
  # need or want any cxx file generated.
  IF(NOT WRAPPER_DO_NOT_CREATE_CXX)
    WRITE_WRAP_CXX("wrap_${module}.cxx")
  ENDIF(NOT WRAPPER_DO_NOT_CREATE_CXX)
ENDMACRO(INCLUDE_WRAP_CMAKE)


MACRO(WRITE_WRAP_CXX file_name)
  # write the wrap_*.cxx file
  #
  # Global vars used: WRAPPER_INCLUDE_FILES WRAPPER_MODULE_NAME and WRAPPER_TYPEDEFS
  # Global vars modified: none
  
  # Create the '#include' statements.
  SET(CONFIG_WRAPPER_INCLUDES)
  FOREACH(inc ${WRAPPER_INCLUDE_FILES})
    IF("${inc}" MATCHES "<.*>")
      # if the include file is a <stdlib> include file, don't surround the name with qotes.
      SET(include "${inc}")
    ELSE("${inc}" MATCHES "<.*>")
      SET(include "\"${inc}\"")
    ENDIF("${inc}" MATCHES "<.*>")
    SET(CONFIG_WRAPPER_INCLUDES "${CONFIG_WRAPPER_INCLUDES}#include ${include}\n")
  ENDFOREACH(inc)
  SET(CONFIG_WRAPPER_MODULE_NAME "${WRAPPER_MODULE_NAME}")
  SET(CONFIG_WRAPPER_TYPEDEFS "${WRAPPER_TYPEDEFS}")

  # Create the cxx file.
  SET(cxx_file "${WRAPPER_LIBRARY_OUTPUT_DIR}/${file_name}")

  CONFIGURE_FILE("${WRAP_ITK_CONFIG_DIR}/wrap_.cxx.in"
    "${cxx_file}" @ONLY IMMEDIATE)
  
  # And add the cxx file to the list of cableswig inputs.
  SET(WRAPPER_LIBRARY_CABLESWIG_INPUTS 
    ${WRAPPER_LIBRARY_CABLESWIG_INPUTS} "${cxx_file}")
ENDMACRO(WRITE_WRAP_CXX)


################################################################################
# Macros for writing the global module CableSwig inputs which specify all the
# groups to be bundled together into one module. 
################################################################################

MACRO(WRITE_MODULE_FILES)
  # Write the wrap_LIBRARY_NAME.cxx file which specifies all the wrapped groups.
  
  MESSAGE(STATUS "${WRAPPER_LIBRARY_NAME}: Creating module wrapper files.")

  
  SET(group_list "")
  FOREACH(group_name ${WRAPPER_LIBRARY_GROUPS})
    SET(group_list "${group_list}    \"${group_name}\",\n")
  ENDFOREACH(group_name ${group})
  STRING(REGEX REPLACE ",\n$" "\n" group_list "${group_list}")

  SET(CONFIG_GROUP_LIST "${group_list}")
  
  # Create the cxx file.
  SET(cxx_file "${WRAPPER_LIBRARY_OUTPUT_DIR}/wrap_${WRAPPER_LIBRARY_NAME}.cxx")
  CONFIGURE_FILE("${WRAP_ITK_CONFIG_DIR}/wrap_ITK.cxx.in"
    "${cxx_file}" @ONLY IMMEDIATE)
  

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
  
  # Create the cxx file.
  SET(cxx_file "${WRAPPER_LIBRARY_OUTPUT_DIR}/wrap_${WRAPPER_LIBRARY_NAME}${language}.cxx")  
  CONFIGURE_FILE("${WRAP_ITK_CONFIG_DIR}/wrap_ITKLang.cxx.in"
    "${cxx_file}" @ONLY IMMEDIATE)
  
ENDMACRO(WRITE_MODULE_FOR_LANGUAGE)


################################################################################
# Macros to be used in the wrap_*.cmake files themselves.
# These macros specify that a class is to be wrapped, that certain itk headers
# are to be included, and what specific template instatiations are to be wrapped.
################################################################################

MACRO(WRAP_CLASS class)
  # Wraps the c++ class 'class'. This parameter must be a fully-qualified c++ 
  # name.
  # The class will be named in the SWIG wrappers as the top-level namespace
  # concatenated to the base class name. E.g. itk::Image -> itkImage or 
  # itk::Statistics::Sample -> itkSample.
  # If the top-level namespace is 'itk' amd WRAPPER_AUTO_INCLUDE_HEADERS is ON
  # then the appropriate itk header for this class will be included. Otherwise
  # WRAP_INCLUDE should be manually called from the wrap_*.cmake file that calls
  # this macro.
  # Lastly, this class takes an optional 'wrap method' parameter. Valid values are:
  # POINTER, POINTER_WITH_SUPERCLASS, DEREF and SELF.
  #
  # Global vars used: none
  # Global vars modified: WRAPPER_INCLUDE_FILES
  # drop the namespace prefix
  IF("${class}" MATCHES "::")
    # there's at least one namespace in the name
    STRING(REGEX REPLACE ".*::" "" base_name "${class}")
    STRING(REGEX REPLACE "^([^:]*::)?.+" "\\1" top_namespace "${class}")
    STRING(REGEX REPLACE "::" "" top_namespace "${top_namespace}") # drop the :: from the namespace
    SET(swig_name "${top_namespace}${base_name}")
  ELSE("${class}" MATCHES "::")
    # no namespaces
    SET(swig_name "${class}")
  ENDIF("${class}" MATCHES "::")

  # Call the WRAP_NAMED_CLASS macro, including any optional arguments
  WRAP_NAMED_CLASS("${class}" "${swig_name}" ${ARGN})

  # and include the class's header
  IF(WRAPPER_AUTO_INCLUDE_HEADERS)
    WRAP_INCLUDE("${swig_name}.h")
  ENDIF(WRAPPER_AUTO_INCLUDE_HEADERS)
ENDMACRO(WRAP_CLASS)

MACRO(WRAP_NAMED_CLASS class swig_name)
  # Begin the wrapping of a new templated class. The 'class' parameter is a 
  # fully-qualified C++ type name, including the namespace. Between WRAP_CLASS 
  # and END_WRAP_CLASS various macros should be called to cause certain template 
  # instances to be automatically added to the wrap_*.cxx file. END_WRAP_CLASS 
  # actually parses through the template instaces that have been recorded and 
  # creates the content of that cxx file. WRAP_NON_TEMPLATE_CLASS should be used
  # to create a definition for a non-templated class. (Note that internally, 
  # WRAP_NON_TEMPLATE_CLASS eventually calls this macro. This macro should never
  # be called directly for a non-templated class though.)
  #
  # The second parameter of this macro is the name that the class should be given 
  # in SWIG (with template definitions providing additional mangled suffixes to this name)
  #
  # Lastly, this class takes an optional 'wrap method' parameter. Valid values are:
  # POINTER and POINTER_WITH_SUPERCLASS.
  # If no parameter is given, the class is simply wrapped as-is. If the parameter
  # is "POINTER" then the class is wrapped and so is the SmartPointer template type
  # that is typedef'd as class::Pointer.
  # If POINTER_WITH_SUPERCLASS is given, class, class::Pointer, class::Superclass,
  # and class::Superclass::Pointer are wrapped. This requires that the class
  # has a typedef'd "Superclass" and that that superclass has Pointer and Self
  # typedefs.
  #
  # Global vars used: none
  # Global vars modified: WRAPPER_CLASS WRAPPER_TEMPLATES WRAPPER_INCLUDE_FILES
  #                       WRAPPER_WRAP_METHOD WRAPPER_SWIG_NAME

  # first, we must be sure the wrap method is valid
  IF("${ARGC}" EQUAL 2)
    # store the wrap method
    SET(WRAPPER_WRAP_METHOD "")
  ENDIF("${ARGC}" EQUAL 2)

  IF("${ARGC}" EQUAL 3)
    SET(WRAPPER_WRAP_METHOD "${ARGV2}")
    SET(ok 0)
    FOREACH(opt POINTER POINTER_WITH_SUPERCLASS)
      IF("${opt}" STREQUAL "${WRAPPER_WRAP_METHOD}")
        SET(ok 1)
      ENDIF("${opt}" STREQUAL "${WRAPPER_WRAP_METHOD}")
    ENDFOREACH(opt)
    IF(ok EQUAL 0)
      MESSAGE(SEND_ERROR "WRAP_CLASS: Invalid option '${WRAPPER_WRAP_METHOD}'. Possible values are POINTER and POINTER_WITH_SUPERCLASS")
    ENDIF(ok EQUAL 0)
  ENDIF("${ARGC}" EQUAL 3)

  IF("${ARGC}" GREATER 3)
    MESSAGE(SEND_ERROR "Too many arguments")
  ENDIF("${ARGC}" GREATER 3)

  SET(WRAPPER_CLASS "${class}")
  SET(WRAPPER_SWIG_NAME "${swig_name}")
  # clear the wrap parameters
  SET(WRAPPER_TEMPLATES)
ENDMACRO(WRAP_NAMED_CLASS)

MACRO(WRAP_NON_TEMPLATE_CLASS class)
  # Similar to WRAP_CLASS in that it generates typedefs for CableSwig input.
  # However, since no templates need to be declared, there's no need for 
  # WRAP_CLASS ... (declare templates) .. END_WRAP_CLASS. Instead
  # WRAP_NON_TEMPLATE_CLASS takes care of it all.
  # A fully-qualified 'class' parameter is required as above. The swig name for
  # this class is generated as in WRAP_CLASS.
  # Lastly, this class takes an optional 'wrap method' parameter. Valid values are:
  # POINTER and POINTER_WITH_SUPERCLASS.

  WRAP_CLASS("${class}" ${ARGN})
  ADD_ONE_TYPEDEF("${WRAPPER_WRAP_METHOD}" "${WRAPPER_CLASS}" "${WRAPPER_SWIG_NAME}")
ENDMACRO(WRAP_NON_TEMPLATE_CLASS class)


MACRO(WRAP_NAMED_NON_TEMPLATE_CLASS class swig_name)
  # Similar to WRAP_NAMED_CLASS in that it generates typedefs for CableSwig input.
  # However, since no templates need to be declared, there's no need for 
  # WRAP_CLASS ... (declare templates) .. END_WRAP_CLASS. Instead
  # WRAP_NAMED_NON_TEMPLATE_CLASS takes care of it all.
  # A fully-qualified 'class' parameter is required as above. The swig name for
  # this class is provided by the second parameter.
  # Lastly, this class takes an optional 'wrap method' parameter. Valid values are:
  # POINTER and POINTER_WITH_SUPERCLASS.

  WRAP_NAMED_CLASS("${class}" "${swig_name}" ${ARGN})
  ADD_ONE_TYPEDEF("${WRAPPER_WRAP_METHOD}" "${WRAPPER_CLASS}" "${WRAPPER_SWIG_NAME}")
ENDMACRO(WRAP_NAMED_NON_TEMPLATE_CLASS class)


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
  # Global vars used: WRAPPER_CLASS WRAPPER_WRAP_METHOD WRAPPER_TEMPLATES WRAPPER_SWIG_NAME
  # Global vars modified: WRAPPER_TYPEDEFS
  
  # the regexp used to get the values separated by a #
  SET(sharp_regexp "([0-9A-Za-z_]*)[ ]*#[ ]*(.*)")
  FOREACH(wrap ${WRAPPER_TEMPLATES})
    STRING(REGEX REPLACE "${sharp_regexp}" "\\1" mangled_suffix "${wrap}")
    STRING(REGEX REPLACE "${sharp_regexp}" "\\2" template_params "${wrap}")
    ADD_ONE_TYPEDEF("${WRAPPER_WRAP_METHOD}" "${WRAPPER_CLASS}" "${WRAPPER_SWIG_NAME}${mangled_suffix}" "${template_params}")
  ENDFOREACH(wrap)  
ENDMACRO(END_WRAP_CLASS)

MACRO(ADD_ONE_TYPEDEF wrap_method wrap_class swig_name)
  # Add one  typedef to WRAPPER_TYPEDEFS
  # 'wrap_method' is the one of the valid WRAPPER_WRAP_METHODS from WRAP_CLASS,
  # 'wrap_class' is the fully-qualified C++ name of the class
  # 'swig_name' is what the swigged class should be called
  # The optional last argument is the template parameters that should go between 
  # the < > brackets in the C++ template definition.
  # Only pass 3 parameters to wrap a non-templated class
  #
  # Global vars used: none
  # Global vars modified: WRAPPER_TYPEDEFS
  
  # get the base C++ class name (no namespaces) from wrap_class:
  STRING(REGEX REPLACE "(.*::)" "" base_name "${wrap_class}")

  SET(wrap_pointer 0)
  SET(template_parameters "${ARGV3}")
  IF(template_parameters)
    SET(full_class_name "${wrap_class}< ${template_parameters} >")
  ELSE(template_parameters)
    SET(full_class_name "${wrap_class}")
  ENDIF(template_parameters)
  
  # Add a typedef for the class. We have this funny looking full_name::base_name
  # thing (it expands to, for example "typedef itk::Foo<baz, 2>::Foo"), to 
  # trick gcc_xml into creating code for the class. If we left off the trailing
  # base_name, then gcc_xml wouldn't see the typedef as a class instantiation,
  # and thus wouldn't create XML for any of the methods, etc.
  SET(typedefs "typedef ${full_class_name}::${base_name} ${swig_name}")

  IF("${wrap_method}" MATCHES "POINTER")
    # add a pointer typedef if we are so asked
    SET(typedefs ${typedefs} "typedef ${full_class_name}::Pointer::SmartPointer ${swig_name}_Pointer")
  ENDIF("${wrap_method}" MATCHES "POINTER")
 
  IF("${wrap_method}" MATCHES "SUPERCLASS")
    SET(typedefs ${typedefs} "typedef ${full_class_name}::Superclass::Self ${swig_name}_Superclass")
    SET(typedefs ${typedefs} "typedef ${full_class_name}::Superclass::Pointer::SmartPointer ${swig_name}_Superclass_Pointer")
  ENDIF("${wrap_method}" MATCHES "SUPERCLASS")

  # insert a blank line to separate the classes
  SET(WRAPPER_TYPEDEFS "${WRAPPER_TYPEDEFS}\n")
  FOREACH(typedef ${typedefs})
    SET(WRAPPER_TYPEDEFS "${WRAPPER_TYPEDEFS}      ${typedef};\n")
  ENDFOREACH(typedef)
  
  # Note: if there's no template_parameters set, this will just pass an empty  
  # list as the template_params parameter of LANGUAGE_SUPPORT_ADD_CLASS, as required
  # in non-template cases.
  LANGUAGE_SUPPORT_ADD_CLASS("${base_name}" "${wrap_class}" "${swig_name}" "${template_parameters}")
  
  IF("${wrap_method}" MATCHES "POINTER")
    LANGUAGE_SUPPORT_ADD_CLASS("SmartPointer" "itk::SmartPointer" "${swig_name}_Pointer" "${full_class_name}")
  ENDIF("${wrap_method}" MATCHES "POINTER")
ENDMACRO(ADD_ONE_TYPEDEF)



################################################################################
# Macros which cause one or more template instantiations to be added to the
# WRAPPER_TEMPLATES list. This list is initialized by the macro WRAP_CLASS above,
# and used by the macro END_WRAP_CLASS to produce the wrap_xxx.cxx files with
# the correct templates. These cxx files serve as the CableSwig inputs.
################################################################################


MACRO(UNIQUE list var_name)
  SET(${var_name} "")
  FOREACH(t ${list})
    SET(must_add ON)
    FOREACH(t2 ${${var_name}})
      IF(t STREQUAL t2)
        SET(must_add OFF)
      ENDIF(t STREQUAL t2)
    ENDFOREACH(t2)
    IF(must_add)
      SET(${var_name} ${${var_name}} ${t})
    ENDIF(must_add)
  ENDFOREACH(t)
ENDMACRO(UNIQUE)


MACRO(WRAP_TEMPLATE name types)
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
ENDMACRO(WRAP_TEMPLATE)


MACRO(WRAP_TEMPLATE_IF_TYPES name types conditions)
  # WRAP_TEMPLATE_IF_TYPES will call WRAP_TEMPLATE(name types) only if the wrapping types selected
  # in cmake (e.g. WRAP_unsigned_char) match one of the conditions listed in
  # the 'conditions' parameter.

  TEST_TYPES(will_wrap "${conditions}")

  IF(will_wrap)
    WRAP_TEMPLATE("${name}" "${types}")
  ENDIF(will_wrap)
ENDMACRO(WRAP_TEMPLATE_IF_TYPES)
  

MACRO(TEST_TYPES var_name conditions)
  SET(${var_name} ON)
  FOREACH(t ${conditions})
    IF("${t}" STREQUAL "UC")
      IF(NOT WRAP_unsigned_char)
        SET(${var_name} OFF)
      ENDIF(NOT WRAP_unsigned_char)
    ENDIF("${t}" STREQUAL "UC")

    IF("${t}" STREQUAL "US")
      IF(NOT WRAP_unsigned_short)
        SET(${var_name} OFF)
      ENDIF(NOT WRAP_unsigned_short)
    ENDIF("${t}" STREQUAL "US")

    IF("${t}" STREQUAL "UL")
      IF(NOT WRAP_unsigned_long)
        SET(${var_name} OFF)
      ENDIF(NOT WRAP_unsigned_long)
    ENDIF("${t}" STREQUAL "UL")

    IF("${t}" STREQUAL "SC")
      IF(NOT WRAP_signed_char)
        SET(${var_name} OFF)
      ENDIF(NOT WRAP_signed_char)
    ENDIF("${t}" STREQUAL "SC")

    IF("${t}" STREQUAL "SS")
      IF(NOT WRAP_signed_short)
        SET(${var_name} OFF)
      ENDIF(NOT WRAP_signed_short)
    ENDIF("${t}" STREQUAL "SS")

    IF("${t}" STREQUAL "SL")
      IF(NOT WRAP_signed_long)
        SET(${var_name} OFF)
      ENDIF(NOT WRAP_signed_long)
    ENDIF("${t}" STREQUAL "SL")

    IF("${t}" STREQUAL "F")
      IF(NOT WRAP_float)
        SET(${var_name} OFF)
      ENDIF(NOT WRAP_float)
    ENDIF("${t}" STREQUAL "F")

    IF("${t}" STREQUAL "D")
      IF(NOT WRAP_double)
        SET(${var_name} OFF)
      ENDIF(NOT WRAP_double)
    ENDIF("${t}" STREQUAL "D")

    IF("${t}" STREQUAL "VF")
      IF(NOT WRAP_vector_float)
        SET(${var_name} OFF)
      ENDIF(NOT WRAP_vector_float)
    ENDIF("${t}" STREQUAL "VF")

    IF("${t}" STREQUAL "VD")
      IF(NOT WRAP_vector_double)
        SET(${var_name} OFF)
      ENDIF(NOT WRAP_vector_double)
    ENDIF("${t}" STREQUAL "VD")

    IF("${t}" STREQUAL "CVF")
      IF(NOT WRAP_covariant_vector_float)
        SET(${var_name} OFF)
      ENDIF(NOT WRAP_covariant_vector_float)
    ENDIF("${t}" STREQUAL "CVF")

    IF("${t}" STREQUAL "CVD")
      IF(NOT WRAP_covariant_vector_double)
        SET(${var_name} OFF)
      ENDIF(NOT WRAP_covariant_vector_double)
    ENDIF("${t}" STREQUAL "CVD")

    IF("${t}" STREQUAL "RGBUC")
      IF(NOT WRAP_rgb_unsigned_char)
        SET(${var_name} OFF)
      ENDIF(NOT WRAP_rgb_unsigned_char)
    ENDIF("${t}" STREQUAL "RGBUC")

    IF("${t}" STREQUAL "RGBUS")
      IF(NOT WRAP_rgb_unsigned_short)
        SET(${var_name} OFF)
      ENDIF(NOT WRAP_rgb_unsigned_short)
    ENDIF("${t}" STREQUAL "RGBUS")
  ENDFOREACH(t)
ENDMACRO(TEST_TYPES)


MACRO(FILTER_TYPES list types var_name)
  SET(${var_name} "")
  FOREACH(t ${list})
    FOREACH(t2 ${types})
      IF(t STREQUAL t2)
        SET(${var_name} ${${var_name}} ${t})
      ENDIF(t STREQUAL t2)
    ENDFOREACH(t2)
  ENDFOREACH(t)
ENDMACRO(FILTER_TYPES)


MACRO(WRAP_TEMPLATE_IF_DIMS name types conditions)
  # WRAP_TEMPLATE_IF_TYPES will call WRAP_TEMPLATE(name types) only if the wrapping types selected
  # in cmake (e.g. WRAP_unsigned_char) match one of the conditions listed in
  # the 'conditions' parameter.

  TEST_DIMS(will_wrap "${conditions}")

  IF(will_wrap)
    WRAP_TEMPLATE("${name}" "${types}")
  ENDIF(will_wrap)
ENDMACRO(WRAP_TEMPLATE_IF_DIMS)


MACRO(TEST_DIMS var_name dims)
  IF("${dims}" MATCHES "^[0-9]+\\+$")
    # If the parameter is of form '2+', make a list of the user-selected
    # dimensions (WRAP_ITK_DIMS) that match this criterion.
    SET(${var_name} OFF)
    STRING(REGEX REPLACE "^([0-9]+)\\+$" "\\1" min_dim "${dims}")
    FOREACH(d ${WRAP_ITK_DIMS})
      IF("${d}" GREATER "${min_dim}" OR "${d}" EQUAL "${min_dim}")
        SET(${var_name} ON)
      ENDIF("${d}" GREATER "${min_dim}" OR "${d}" EQUAL "${min_dim}")
    ENDFOREACH(d)

  ELSE("${dims}" MATCHES "^[0-9]+\\+$")
    # Otherwise, jsut make a list of the intersection between the user-selected
    # dimensions and the allowed dimensions provided by the parameter.
    SET(${var_name} ON)
    FOREACH(d ${WRAP_ITK_DIMS})
      SET(hop OFF)
      FOREACH(td ${dims})
        IF(d EQUAL td)
          SET(hop ON)
        ENDIF(d EQUAL td)
      ENDFOREACH(td)
      IF(NOT hop)
        SET(${var_name} OFF)
      IF(NOT hop)
    ENDFOREACH(d)

  ENDIF("${dims}" MATCHES "^[0-9]+\\+$")
ENDMACRO(TEST_DIMS)


MACRO(FILTER_DIMS list dims var_name)
  SET(${var_name} "")
  IF("${dims}" MATCHES "^[0-9]+\\+$")
    STRING(REGEX REPLACE "^([0-9]+)\\+$" "\\1" min_dim "${dims}")
    FOREACH(d ${list})
      IF("${d}" GREATER "${min_dim}" OR "${d}" EQUAL "${min_dim}")
        SET(${var_name} ${${var_name}} ${d})
      ENDIF("${d}" GREATER "${min_dim}" OR "${d}" EQUAL "${min_dim}")
    ENDFOREACH(d)
  ELSE("${dims}" MATCHES "^[0-9]+\\+$")
    FOREACH(t ${list})
      FOREACH(d ${dims})
        IF(d EQUAL t)
          SET(${var_name} ${${var_name}} ${t})
        ENDIF(d EQUAL t)
      ENDFOREACH(d)
    ENDFOREACH(t)
  ENDIF("${dims}" MATCHES "^[0-9]+\\+$")
ENDMACRO(FILTER_DIMS)


MACRO(WRAP_TEMPLATE_IF_TYPES_DIMS name types type_cond dims_cond)
  # WRAP_TEMPLATE_IF_TYPES_DIMS filters input to WRAP_TEMPLATE_IF_TYPES_DIMS_NO_DIM_TEST.
  # The former macro allows a "template_dims" agrument of the format "2+" to
  # specify that a given image filter is only to be instantiated for all of 
  # the user-selected (via cmake) dimensions, provided the dimension is at 
  # least 2. The size parameter refers to the number of Image classes that
  # must be in the template definition. (E.g. Filter<Image, Image> has size of
  # 2. The types parameter refers to the image pixel types to be wrapped.

  TEST_TYPES(will_wrap "${type_cond}")

  IF(will_wrap)
    TEST_DIMS(will_wrap "${dims_cond}")
  ENDIF(will_wrap)

  IF(will_wrap)
    WRAP_TEMPLATE("${name}" "${types}")
  ENDIF(will_wrap)

ENDMACRO(WRAP_TEMPLATE_IF_TYPES_DIMS)



MACRO(WRAP_ALL_TYPES_AND_DIMS size types dims)
  # WRAP_TEMPLATE_IF_TYPES_DIMS_NO_DIM_TEST wraps a given filter for all of the user-
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
      WRAP_TEMPLATE("${name}" "${params}")
    ENDFOREACH(type)
  ENDFOREACH(dim)
ENDMACRO(WRAP_ALL_TYPES_AND_DIMS)


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

MACRO(WRAP_IMAGE_FILTER_INT size)
  IF("${ARGC}" EQUAL 3)
    FILTER_DIMS("${WRAP_ITK_DIMS}" "${ARGV2}" dim_list)
  ELSE("${ARGC}" EQUAL 3)
    SET(dim_list ${WRAP_ITK_DIMS})
  ENDIF("${ARGC}" EQUAL 3)

  WRAP_ALL_TYPES_AND_DIMS(${size} "${WRAP_ITK_INT}" "${dim_list}")
ENDMACRO(WRAP_IMAGE_FILTER_INT)


MACRO(WRAP_IMAGE_FILTER_SIGN_INT size)
  IF("${ARGC}" EQUAL 3)
    FILTER_DIMS("${WRAP_ITK_DIMS}" "${ARGV2}" dim_list)
  ELSE("${ARGC}" EQUAL 3)
    SET(dim_list ${WRAP_ITK_DIMS})
  ENDIF("${ARGC}" EQUAL 3)

  WRAP_ALL_TYPES_AND_DIMS(${size} "${WRAP_ITK_SIGN_INT}" "${dim_list}")
ENDMACRO(WRAP_IMAGE_FILTER_SIGN_INT)


MACRO(WRAP_IMAGE_FILTER_REAL size)
  IF("${ARGC}" EQUAL 3)
    FILTER_DIMS("${WRAP_ITK_DIMS}" "${ARGV2}" dim_list)
  ELSE("${ARGC}" EQUAL 3)
    SET(dim_list ${WRAP_ITK_DIMS})
  ENDIF("${ARGC}" EQUAL 3)

  WRAP_ALL_TYPES_AND_DIMS(${size} "${WRAP_ITK_REAL}" "${dim_list}")
ENDMACRO(WRAP_IMAGE_FILTER_REAL)


MACRO(WRAP_IMAGE_FILTER_RGB size)
  IF("${ARGC}" EQUAL 3)
    FILTER_DIMS("${WRAP_ITK_DIMS}" "${ARGV2}" dim_list)
  ELSE("${ARGC}" EQUAL 3)
    SET(dim_list ${WRAP_ITK_DIMS})
  ENDIF("${ARGC}" EQUAL 3)

  WRAP_ALL_TYPES_AND_DIMS(${size} "${WRAP_ITK_RGB}" "${dim_list}")
ENDMACRO(WRAP_IMAGE_FILTER_RGB)


MACRO(WRAP_IMAGE_FILTER_VECTOR_REAL size)
  IF("${ARGC}" EQUAL 3)
    FILTER_DIMS("${WRAP_ITK_DIMS}" "${ARGV2}" dim_list)
  ELSE("${ARGC}" EQUAL 3)
    SET(dim_list ${WRAP_ITK_DIMS})
  ENDIF("${ARGC}" EQUAL 3)

  SET(ddims "")
  FOREACH(d ${dim_list})
    SET(ddims ${ddims} "${d}${d}")
  ENDFOREACH(d)

  WRAP_ALL_TYPES_AND_DIMS(${size} "${WRAP_ITK_VECTOR_REAL}" "${ddims}")
ENDMACRO(WRAP_IMAGE_FILTER_VECTOR_REAL)


MACRO(WRAP_IMAGE_FILTER_COV_VECTOR_REAL size)
  IF("${ARGC}" EQUAL 3)
    FILTER_DIMS("${WRAP_ITK_DIMS}" "${ARGV2}" dim_list)
  ELSE("${ARGC}" EQUAL 3)
    SET(dim_list ${WRAP_ITK_DIMS})
  ENDIF("${ARGC}" EQUAL 3)

  SET(ddims "")
  FOREACH(d ${dim_list})
    SET(ddims ${ddims} "${d}${d}")
  ENDFOREACH(d)

  WRAP_ALL_TYPES_AND_DIMS(${size} "${WRAP_ITK_COV_VECTOR_REAL}" "${ddims}")
ENDMACRO(WRAP_IMAGE_FILTER_COV_VECTOR_REAL)



MACRO(WRAP_IMAGE_FILTER_TYPES1 type_list)
  IF("${ARGC}" EQUAL 3)
    FILTER_DIMS("${WRAP_ITK_DIMS}" "${ARGV2}" dim_list)
  ELSE("${ARGC}" EQUAL 3)
    SET(dim_list ${WRAP_ITK_DIMS})
  ENDIF("${ARGC}" EQUAL 3)

  FOREACH(dim ${dim_list})
    FOREACH(type ${type_list})
      WRAP_TEMPLATE("${ITKM_I${type}${dim}}" "${ITKT_I${type}${dim}}")
    ENDFOREACH(type)
  ENDFOREACH(dim)

ENDMACRO(WRAP_IMAGE_FILTER_TYPES1)


MACRO(WRAP_IMAGE_FILTER_TYPES2 type_list1 type_list2)
  IF("${ARGC}" EQUAL 4)
    FILTER_DIMS("${WRAP_ITK_DIMS}" "${ARGV3}" dim_list)
  ELSE("${ARGC}" EQUAL 4)
    SET(dim_list ${WRAP_ITK_DIMS})
  ENDIF("${ARGC}" EQUAL 4)

  FOREACH(dim ${dim_list})
    FOREACH(type1 ${type_list1})
      FOREACH(type2 ${type_list2})
MESSAGE("${type1}--${type2}")
        WRAP_TEMPLATE("${ITKM_I${type1}${dim}}${ITKM_I${type2}${dim}}" "${ITKT_I${type1}${dim}},${ITKT_I${type2}${dim}}")
      ENDFOREACH(type2)
    ENDFOREACH(type1)
  ENDFOREACH(dim)

ENDMACRO(WRAP_IMAGE_FILTER_TYPES2)


MACRO(WRAP_IMAGE_FILTER_TYPES3 type_list1 type_list2 type_list3)
  IF("${ARGC}" EQUAL 5)
    FILTER_DIMS("${WRAP_ITK_DIMS}" "${ARGV4}" dim_list)
  ELSE("${ARGC}" EQUAL 5)
    SET(dim_list ${WRAP_ITK_DIMS})
  ENDIF("${ARGC}" EQUAL 5)

  FOREACH(dim ${dim_list})
    FOREACH(type1 ${type_list1})
      FOREACH(type2 ${type_list2})
        FOREACH(type3 ${type_list3})
          WRAP_TEMPLATE("${ITKM_I${type1}${dim}}${ITKM_I${type2}${dim}}${ITKM_I${type3}${dim}}" "${ITKT_I${type1}${dim}},${ITKT_I${type2}${dim}},${ITKT_I${type3}${dim}}")
        ENDFOREACH(type3)
      ENDFOREACH(type2)
    ENDFOREACH(type1)
  ENDFOREACH(dim)

ENDMACRO(WRAP_IMAGE_FILTER_TYPES3)


MACRO(WRAP_IMAGE_FILTER_TYPES4 type_list1 type_list2 type_list3 type_list4)
  IF("${ARGC}" EQUAL 6)
    FILTER_DIMS("${WRAP_ITK_DIMS}" "${ARGV5}" dim_list)
  ELSE("${ARGC}" EQUAL 6)
    SET(dim_list ${WRAP_ITK_DIMS})
  ENDIF("${ARGC}" EQUAL 6)

  FOREACH(dim ${dim_list})
    FOREACH(type1 ${type_list1})
      FOREACH(type2 ${type_list2})
        FOREACH(type3 ${type_list3})
          FOREACH(type4 ${type_list4})
            WRAP_TEMPLATE("${ITKM_I${type1}${dim}}${ITKM_I${type2}${dim}}${ITKM_I${type3}${dim}}${ITKM_I${type4}${dim}}" "${ITKT_I${type1}${dim}}$,{ITKT_I${type2}${dim}},${ITKT_I${type3}${dim}},${ITKT_I${type4}${dim}}")
          ENDFOREACH(type4)
        ENDFOREACH(type3)
      ENDFOREACH(type2)
    ENDFOREACH(type1)
  ENDFOREACH(dim)

ENDMACRO(WRAP_IMAGE_FILTER_TYPES4)




