#------------------------------------------------------------------------------
# Macros for modules
#------------------------------------------------------------------------------
MACRO(WRITE_MODULE MODULE_NAME PATH GROUP)
   SET(GROUP_LIST "")
   FOREACH(group_name ${GROUP})
      SET(GROUP_LIST "${GROUP_LIST}    \"${group_name}\",\n")
   ENDFOREACH(group_name ${GROUP})
   STRING(REGEX REPLACE ",\n$" "\n" GROUP_LIST "${GROUP_LIST}")

   CONFIGURE_FILE(
      "${WRAP_ITK_CONFIG_DIR}/wrap_ITK.cxx.in"
      "${PATH}/wrap_${MODULE_NAME}.cxx"
      @ONLY IMMEDIATE
   )

   WRITE_MODULE_LANG(${MODULE_NAME} ${PATH})
ENDMACRO(WRITE_MODULE)

MACRO(WRITE_MODULE_LANG MODULE_NAME PATH)
  IF(WRAP_ITK_TCL)
    WRITE_MODULE_TCL(${MODULE_NAME} ${PATH})
  ENDIF(WRAP_ITK_TCL)
  IF(WRAP_ITK_PYTHON)
    WRITE_MODULE_PYTHON(${MODULE_NAME} ${PATH})
  ENDIF(WRAP_ITK_PYTHON)
  IF(WRAP_ITK_JAVA)
    WRITE_MODULE_JAVA(${MODULE_NAME} ${PATH})
  ENDIF(WRAP_ITK_JAVA)
  # Need perl stuff too
ENDMACRO(WRITE_MODULE_LANG)

MACRO(WRITE_MODULE_TCL MODULE_NAME PATH)
   SET(lang "Tcl")
   SET(module_name ${MODULE_NAME})
   SET(extra_headers "")
   STRING(TOUPPER ${lang} lang_TOUPPER)
   CONFIGURE_FILE(
      "${WRAP_ITK_CONFIG_DIR}/wrap_ITKLang.cxx.in"
      "${PATH}/wrap_${MODULE_NAME}${lang}.cxx"
      IMMEDIATE
   )
ENDMACRO(WRITE_MODULE_TCL)

MACRO(WRITE_MODULE_PYTHON MODULE_NAME PATH)
   SET(lang "Python")
   SET(module_name ${MODULE_NAME})
   SET(extra_headers "")
   STRING(TOUPPER ${lang} lang_TOUPPER)
   CONFIGURE_FILE(
      "${WRAP_ITK_CONFIG_DIR}/wrap_ITKLang.cxx.in"
      "${PATH}/wrap_${MODULE_NAME}${lang}.cxx"
      IMMEDIATE
   )
ENDMACRO(WRITE_MODULE_PYTHON)

MACRO(WRITE_MODULE_JAVA MODULE_NAME PATH)
   SET(lang "Java")
   SET(module_name ${MODULE_NAME})
   SET(extra_headers "")
   STRING(TOUPPER ${lang} lang_TOUPPER)
   CONFIGURE_FILE(
      "${WRAP_ITK_CONFIG_DIR}/wrap_ITKLang.cxx.in"
      "${PATH}/wrap_${MODULE_NAME}${lang}.cxx"
      IMMEDIATE
   )
ENDMACRO(WRITE_MODULE_JAVA)



#------------------------------------------------------------------------------
# macros to generate the wrap_*.cxx files
#------------------------------------------------------------------------------
MACRO(WRITE_WRAP_CXX)
  # write the wrap_???.cxx file
  #
  # Global vars used: itk_File itk_Include itk_Module and itk_Typedef
  # Global vars modified: none
  #
  SET(WRAP_INCLUDE_FILE)
  FOREACH(inc ${itk_Include})
    SET(WRAP_INCLUDE_FILE "${WRAP_INCLUDE_FILE}#include \"itk${inc}.h\"\n")
  ENDFOREACH(inc)

  CONFIGURE_FILE(
    "${WRAP_ITK_CONFIG_DIR}/wrap_.cxx.in"
    "${itk_File}"
    IMMEDIATE
  )
ENDMACRO(WRITE_WRAP_CXX)


MACRO(WRAP_CLASS CLASS)
  # begin the wrapping of a new class
  #
  # Global vars used: none
  # Global vars modified: itk_Class itk_Wrap itk_Include
  #

  # first, we must be sure the wrapMethod is valid
  IF("${ARGC}" EQUAL 1)
    # store the wrap method
    SET(itk_WrapMethod "")
  ENDIF("${ARGC}" EQUAL 1)

  IF("${ARGC}" EQUAL 2)
    SET(itk_WrapMethod "${ARGV1}")
    SET(ok 0)
    FOREACH(opt POINTER POINTER_WITH_SUPERCLASS DEREF SELF)
      IF("${opt}" STREQUAL "${itk_WrapMethod}")
        SET(ok 1)
      ENDIF("${opt}" STREQUAL "${itk_WrapMethod}")
    ENDFOREACH(opt)
    IF(ok EQUAL 0)
      MESSAGE(SEND_ERROR "WRAP_CLASS: Invalid option '${itk_WrapMethod}'. Possible values are POINTER, POINTER_WITH_SUPERCLASS, DEREF and SELF")
    ENDIF(ok EQUAL 0)
  ENDIF("${ARGC}" EQUAL 2)

  IF("${ARGC}" EQUAL 3)
    MESSAGE(SEND_ERROR "Too much arguments")
  ENDIF("${ARGC}" EQUAL 3)


  SET(itk_Class ${CLASS})
  # drop the namespace prefix
  STRING(REGEX REPLACE "(.*::)" "" class_name ${CLASS})
  # clear the wrap parameters
  SET(itk_Wrap)
  # and include the class
  IF(${itk_AutoInclude})
    WRAP_INCLUDE(${class_name})
  ENDIF(${itk_AutoInclude})
ENDMACRO(WRAP_CLASS)


MACRO(END_WRAP_CLASS)
  # remove the namespace prefix
  STRING(REGEX REPLACE "(.*::)" "" class_name ${itk_Class})
  # the regexp used to get the values separated by a #
  SET(sharpRegexp "([0-9A-Za-z]*)[ ]*#[ ]*(.*)")
  SET(wrapClass)

  # insert a blank line to separate the classes
  SET(itk_Typedef "${itk_Typedef}      \n")
  
  IF("${itk_WrapMethod}" STREQUAL "")
    FOREACH(wrap ${itk_Wrap})
      STRING(REGEX REPLACE
        "${sharpRegexp}"
        "typedef itk::${itk_Class}< \\2 > itk${class_name}\\1"
        wrapClass "${wrap}"
      )
      SET(itk_Typedef "${itk_Typedef}      ${wrapClass};\n")
    ENDFOREACH(wrap)
  ENDIF("${itk_WrapMethod}" STREQUAL "")

  IF("${itk_WrapMethod}" STREQUAL "POINTER")
    FOREACH(wrap ${itk_Wrap})
      STRING(REGEX REPLACE
        "${sharpRegexp}"
        "typedef itk::${itk_Class}< \\2 >::${class_name} itk${class_name}\\1;\n      typedef itk::${itk_Class}< \\2 >::Pointer::SmartPointer itk${class_name}\\1_Pointer"
        wrapClass "${wrap}"
      )
      SET(itk_Typedef "${itk_Typedef}      ${wrapClass};\n")
    ENDFOREACH(wrap)
  ENDIF("${itk_WrapMethod}" STREQUAL "POINTER")

  IF("${itk_WrapMethod}" STREQUAL "POINTER_WITH_SUPERCLASS")
    FOREACH(wrap ${itk_Wrap})
      STRING(REGEX REPLACE
        "${sharpRegexp}"
        "typedef itk::${itk_Class}< \\2 >::${class_name} itk${class_name}\\1;\n      typedef itk::${itk_Class}< \\2 >::Pointer::SmartPointer itk${class_name}\\1_Pointer;\n      typedef itk::${itk_Class}< \\2 >::Superclass::Self itk${class_name}\\1_Superclass;\n      typedef itk::${itk_Class}< \\2 >::Superclass::Pointer::SmartPointer itk${class_name}\\1_Superclass_Pointer"
        wrapClass "${wrap}"
      )
      SET(itk_Typedef "${itk_Typedef}      ${wrapClass};\n")
    ENDFOREACH(wrap)
  ENDIF("${itk_WrapMethod}" STREQUAL "POINTER_WITH_SUPERCLASS")

  IF("${itk_WrapMethod}" STREQUAL "DEREF")
    FOREACH(wrap ${itk_Wrap})
      STRING(REGEX REPLACE
        "${sharpRegexp}"
        "typedef itk::${itk_Class}< \\2 >::${class_name} itk${class_name}\\1"
        wrapClass "${wrap}"
      )
      SET(itk_Typedef "${itk_Typedef}      ${wrapClass};\n")
    ENDFOREACH(wrap)
  ENDIF("${itk_WrapMethod}" STREQUAL "DEREF")

  IF("${itk_WrapMethod}" STREQUAL "SELF")
    FOREACH(wrap ${itk_Wrap})
      STRING(REGEX REPLACE
        "${sharpRegexp}"
        "typedef itk::${itk_Class}< \\2 >::Self itk${class_name}\\1"
        wrapClass "${wrap}"
      )
      SET(itk_Typedef "${itk_Typedef}      ${wrapClass};\n")
    ENDFOREACH(wrap)
  ENDIF("${itk_WrapMethod}" STREQUAL "SELF")
  
  WRITE_LANG_WRAP("${itk_Class}" "${itk_Wrap}")
ENDMACRO(END_WRAP_CLASS)



MACRO(WRAP_CLASS_NOTPL CLASS)
  # first, we must be sure the wrapMethod is valid
  IF("${ARGC}" EQUAL 1)
    # store the wrap method
    SET(itk_WrapMethod "")
  ENDIF("${ARGC}" EQUAL 1)

  IF("${ARGC}" EQUAL 2)
    SET(itk_WrapMethod "${ARGV1}")
    SET(ok 0)
    FOREACH(opt POINTER POINTER_WITH_SUPERCLASS DEREF SELF)
      IF("${opt}" STREQUAL "${itk_WrapMethod}")
        SET(ok 1)
      ENDIF("${opt}" STREQUAL "${itk_WrapMethod}")
    ENDFOREACH(opt)
    IF(ok EQUAL 0)
      MESSAGE(SEND_ERROR "WRAP_CLASS: Invalid option '${itk_WrapMethod}'. Possible values are POINTER, POINTER_WITH_SUPERCLASS, DEREF and SELF")
    ENDIF(ok EQUAL 0)
  ENDIF("${ARGC}" EQUAL 2)

  IF("${ARGC}" EQUAL 3)
    MESSAGE(SEND_ERROR "Too much arguments")
  ENDIF("${ARGC}" EQUAL 3)

  STRING(REGEX REPLACE "(.*::)" "" class_name ${CLASS})

  IF(${itk_AutoInclude})
    WRAP_INCLUDE(${class_name})
  ENDIF(${itk_AutoInclude})

  # insert a blank line to separate the classes
  SET(itk_Typedef "${itk_Typedef}      \n")
  
  IF("${itk_WrapMethod}" STREQUAL "")
    SET(itk_Typedef "${itk_Typedef}      typedef itk::${CLASS} itk${class_name};\n")
  ENDIF("${itk_WrapMethod}" STREQUAL "")

  IF("${itk_WrapMethod}" STREQUAL "POINTER")
    SET(itk_Typedef "${itk_Typedef}      typedef itk::${CLASS}::${class_name} itk${class_name};\n")
    SET(itk_Typedef "${itk_Typedef}      typedef itk::${CLASS}::Pointer::SmartPointer itk${class_name}_Pointer;\n")
  ENDIF("${itk_WrapMethod}" STREQUAL "POINTER")

  IF("${itk_WrapMethod}" STREQUAL "POINTER_WITH_SUPERCLASS")
    SET(itk_Typedef "${itk_Typedef}      typedef itk::${CLASS}::${class_name} itk${class_name};\n")
    SET(itk_Typedef "${itk_Typedef}      typedef itk::${CLASS}::Pointer::SmartPointer itk${class_name}_Pointer;\n")
    SET(itk_Typedef "${itk_Typedef}      typedef itk::${CLASS}::Superclass::Self itk${class_name}_Superclass;\n")
    SET(itk_Typedef "${itk_Typedef}      typedef itk::${CLASS}::Superclass::Pointer::SmartPointer itk${class_name}_Superclass_Pointer;\n")
  ENDIF("${itk_WrapMethod}" STREQUAL "POINTER_WITH_SUPERCLASS")

  IF("${itk_WrapMethod}" STREQUAL "DEREF")
    SET(itk_Typedef "${itk_Typedef}      typedef itk::${CLASS}::${class_name} itk${class_name};\n")
  ENDIF("${itk_WrapMethod}" STREQUAL "DEREF")

  IF("${itk_WrapMethod}" STREQUAL "SELF")
    SET(itk_Typedef "${itk_Typedef}      typedef itk::${CLASS}::Self itk${class_name};\n")
  ENDIF("${itk_WrapMethod}" STREQUAL "SELF")
  
  WRITE_LANG_WRAP_NOTPL("${CLASS}")
ENDMACRO(WRAP_CLASS_NOTPL)




MACRO(INCLUDE_WRAP_CMAKE module output_dir)
  # include a cmake module file and generate the associated wrap_???.cxx file
  #
  # Global vars used: none
  # Global vars modified: itk_Module itk_File itk_WrapMethod
  #

  # preset the vars before include the file 
  SET(itk_Module "${module}")
  SET(itk_File "${output_dir}/wrap_${itk_Module}.cxx")
  SET(itk_Typedef)
  SET(itk_Include ${itk_DefaultInclude})
  SET(itk_AutoInclude 1)

  # now include the file
  INCLUDE("wrap_${module}.cmake")

  # and write the file
  WRITE_WRAP_CXX()
ENDMACRO(INCLUDE_WRAP_CMAKE)


MACRO(AUTO_INCLUDE_WRAP_CMAKE LISTNAME EXCLUDE_LIST CXX_OUTPUT_DIR)
  # automatically include the wrap_*.cmake file in the current directory"
  # 
  # first, include modules already in list
  FOREACH(module ${${LISTNAME}})
      INCLUDE_WRAP_CMAKE("${module}" "${CXX_OUTPUT_DIR}")
  ENDFOREACH(module)

  # search files to include
  FILE(GLOB filesToInclude "wrap_*.cmake")
  FOREACH(file ${filesToInclude})
    # get the module name: wrap_module.cmake
    STRING(REGEX REPLACE ".*wrap_" "" module "${file}")
    STRING(REGEX REPLACE ".cmake$" "" module "${module}")

    # if the module is already in the list, it mean that it is already included
    # ... and do not include excluded modules
    SET(willInclude 1)
    FOREACH(alreadyIncl ${${LISTNAME}} ${EXCLUDE_LIST})
      IF("${alreadyIncl}" STREQUAL "${module}")
        SET(willInclude 0)
      ENDIF("${alreadyIncl}" STREQUAL "${module}")
      IF("${excluded}" STREQUAL "${module}")
        SET(willInclude 0)
      ENDIF("${excluded}" STREQUAL "${module}")
    ENDFOREACH(alreadyIncl)

    IF(${willInclude})
      # add the module name to the list
      SET(${LISTNAME} ${${LISTNAME}} "${module}")
      INCLUDE_WRAP_CMAKE("${module}" "${CXX_OUTPUT_DIR}")
    ENDIF(${willInclude})
  ENDFOREACH(file)
ENDMACRO(AUTO_INCLUDE_WRAP_CMAKE)





MACRO(WRAP_INCLUDE INC)
  SET(alreadyInclude 0)
  FOREACH(inc ${itk_Include})
    IF("${INC}" STREQUAL "${inc}")
      SET(alreadyInclude 1)
    ENDIF("${INC}" STREQUAL "${inc}")
  ENDFOREACH(inc)
  IF(NOT ${alreadyInclude})
    # include order IS important. Default values must be before the other ones
    SET(itk_Include 
      ${itk_Include}
      ${INC}
    )
  ENDIF(NOT ${alreadyInclude})
ENDMACRO(WRAP_INCLUDE)


MACRO(WRAP NAME TYPES)
  # add a wrapped type and mask the not so clean notation "name # types"
  #
  # Global vars used: itk_Wrap
  # Global vars modified: itk_Wrap
  #
  SET(itk_Wrap ${itk_Wrap} "${NAME} # ${TYPES}")
ENDMACRO(WRAP)


MACRO(COND_WRAP NAME TYPES CONDS)
  SET(will_wrap 1)
  FOREACH(t ${CONDS})
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
    WRAP("${NAME}" "${TYPES}")
  ENDIF(${will_wrap})
ENDMACRO(COND_WRAP)


MACRO(WRAP_TYPES_DIMS SIZE TYPES TMP_DIMS)
  # implement an argument of type 2+ to say all dims equal or above 2

  IF("${TMP_DIMS}" MATCHES "^[0-9]+\\+$")
    STRING(REGEX REPLACE "^([0-9]+)\\+$" "\\1" MAX_DIM "${TMP_DIMS}")
    SET(DIMS "")
    FOREACH(d "${WRAP_DIMS}")
      IF("${d}" GREATER "${MAX_DIM}" OR "${d}" EQUAL "${MAX_DIM}")
        SET(DIMS "${DIMS}" "${d}")
      ENDIF("${d}" GREATER "${MAX_DIM}" OR "${d}" EQUAL "${MAX_DIM}")
    ENDFOREACH(d)
    WRAP_TYPES_DIMS_NO_DIM_TEST("${SIZE}" "${TYPES}" "${DIMS}")

  ELSE("${TMP_DIMS}" MATCHES "^[0-9]+\\+$")
    WRAP_TYPES_DIMS_NO_DIM_TEST("${SIZE}" "${TYPES}" "${WRAP_DIMS}")

  ENDIF("${TMP_DIMS}" MATCHES "^[0-9]+\\+$")

ENDMACRO(WRAP_TYPES_DIMS)


MACRO(WRAP_TYPES_DIMS_NO_DIM_TEST SIZE TYPES DIMS)
  FOREACH(dim ${DIMS})
    FOREACH(type ${TYPES})
      SET(name "")
      SET(params "")
      FOREACH(i RANGE 1 ${SIZE})
        SET(varname "ITKM_I${type}${dim}")
        SET(name "${name}${${varname}}")
        SET(varname "ITKT_I${type}${dim}")
        SET(params "${params}${${varname}}")
        IF(NOT ${i} EQUAL ${SIZE})
          SET(params "${params}, ")
        ENDIF(NOT ${i} EQUAL ${SIZE})
      ENDFOREACH(i)
      COND_WRAP("${name}" "${params}" "${type}")
    ENDFOREACH(type)
  ENDFOREACH(dim)
ENDMACRO(WRAP_TYPES_DIMS_NO_DIM_TEST)

MACRO(WRAP_INT_DIMS SIZE DIMS)
  WRAP_TYPES_DIMS(${SIZE} "UL;US;UC" "${DIMS}")
ENDMACRO(WRAP_INT_DIMS)

MACRO(WRAP_INT SIZE)
  WRAP_INT_DIMS(${SIZE} "${WRAP_DIMS}")
ENDMACRO(WRAP_INT)


MACRO(WRAP_SIGN_INT_DIMS SIZE DIMS)
  WRAP_TYPES_DIMS(${SIZE} "SL;SS;SC" "${DIMS}")
ENDMACRO(WRAP_SIGN_INT_DIMS)

MACRO(WRAP_SIGN_INT SIZE)
  WRAP_SIGN_INT_DIMS(${SIZE} "${WRAP_DIMS}")
ENDMACRO(WRAP_SIGN_INT)


MACRO(WRAP_REAL_DIMS SIZE DIMS)
  WRAP_TYPES_DIMS(${SIZE} "F;D" "${DIMS}")
ENDMACRO(WRAP_REAL_DIMS SIZE)

MACRO(WRAP_REAL SIZE)
  WRAP_REAL_DIMS(${SIZE} "${WRAP_DIMS}")
ENDMACRO(WRAP_REAL SIZE)


MACRO(WRAP_VECTOR_REAL_DIMS SIZE DIMS)
  SET(ddims "")
  FOREACH(d ${DIMS})
    SET(ddims ${ddims} "${d}${d}")
  ENDFOREACH(d)
  WRAP_TYPES_DIMS_NO_DIM_TEST(${SIZE} "VF;VD" "${ddims}")
ENDMACRO(WRAP_VECTOR_REAL_DIMS SIZE)

MACRO(WRAP_VECTOR_REAL SIZE)
  WRAP_VECTOR_REAL_DIMS(${SIZE} "${WRAP_DIMS}")
ENDMACRO(WRAP_VECTOR_REAL SIZE)


MACRO(WRAP_COV_VECTOR_REAL_DIMS SIZE DIMS)
  SET(ddims "")
  FOREACH(d ${DIMS})
    SET(ddims ${ddims} "${d}${d}")
  ENDFOREACH(d)
  WRAP_TYPES_DIMS_NO_DIM_TEST(${SIZE} "CVF;CVD" "${ddims}")
ENDMACRO(WRAP_COV_VECTOR_REAL_DIMS SIZE)

MACRO(WRAP_COV_VECTOR_REAL SIZE)
  WRAP_COV_VECTOR_REAL_DIMS(${SIZE} "${WRAP_DIMS}")
ENDMACRO(WRAP_COV_VECTOR_REAL SIZE)


MACRO(WRAP_RGB_DIMS SIZE DIMS)
  WRAP_TYPES_DIMS(${SIZE} "RGBUS;RGBUC" "${DIMS}")
ENDMACRO(WRAP_RGB_DIMS)

MACRO(WRAP_RGB SIZE)
  WRAP_RGB_DIMS(${SIZE} "${WRAP_DIMS}")
ENDMACRO(WRAP_RGB)


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
      INSTALL_FILES("${WRAPPER_INSTALL_LOCATION}/Python" FILES "${PYTHON_MODULE_PATH}Py.py")
   ENDIF(WRAP_ITK_PYTHON)
ENDMACRO(WRITE_LANG_END)

MACRO(WRITE_LANG_WRAP CLASS WRAP)
   IF(WRAP_ITK_PYTHON)
      # python
      WRITE_PY_WRAP("${PYTHON_MODULE_PATH}Py.py" ${CLASS} "${WRAP}")
   ENDIF(WRAP_ITK_PYTHON)
ENDMACRO(WRITE_LANG_WRAP)

MACRO(WRITE_LANG_WRAP_NOTPL CLASS)
   IF(WRAP_ITK_PYTHON)
      # python
      WRITE_PY_WRAP_NOTPL("${PYTHON_MODULE_PATH}Py.py" ${CLASS})
   ENDIF(WRAP_ITK_PYTHON)
ENDMACRO(WRITE_LANG_WRAP_NOTPL)

