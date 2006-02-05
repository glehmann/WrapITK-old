#------------------------------------------------------------------------------

# define some macro to help creation of types vars

MACRO(WRAP_TYPE class prefix)
   # begin the creation of a type vars
   # call to this macro should be followed by one or several call to WRAP()
   # and one call to END_WRAP_TYPE to really create the vars
   SET(WRAPPER_TEMPLATES "")
   SET(itk_Wrap_Prefix "${prefix}")
   SET(itk_Wrap_Class "${class}")
ENDMACRO(WRAP_TYPE)

MACRO(END_WRAP_TYPE)
   # create the type vars.
   # must be called after END_WRAP_TYPE
   # Create the vars used for to designe types in all the cmake
   # files. This method ensure all the type names are constructed
   # with the same method
   FOREACH(wrap ${WRAPPER_TEMPLATES})
      STRING(REGEX REPLACE "([0-9A-Za-z]*)[ ]*#[ ]*(.*)" "\\1" wrapTpl "${wrap}")
      STRING(REGEX REPLACE "([0-9A-Za-z]*)[ ]*#[ ]*(.*)" "\\2" wrapType "${wrap}")
      SET(ITKT_${itk_Wrap_Prefix}${wrapTpl} "itk::${itk_Wrap_Class}< ${wrapType} >")
      SET(ITKM_${itk_Wrap_Prefix}${wrapTpl} "${itk_Wrap_Prefix}${wrapTpl}")
   ENDFOREACH(wrap)
ENDMACRO(END_WRAP_TYPE)

#------------------------------------------------------------------------------

# now, define types vars
# the result is stored in itk_Wrap_XXX where XXX is the name of the class
# to be wrapped in there own file, most of the time in CommonA


WRAP_TYPE("Offset" "O")
  FOREACH(d ${WRAP_DIMS})
    WRAP("${d}"  "${d}")
  ENDFOREACH(d)
END_WRAP_TYPE()
SET(itk_Wrap_Offset ${WRAPPER_TEMPLATES})

WRAP_TYPE("Vector" "V")
  FOREACH(d ${WRAP_DIMS})
    WRAP("${ITKM_F}${d}"  "${ITKT_F},${d}")
    WRAP("${ITKM_D}${d}"  "${ITKT_D},${d}")
  ENDFOREACH(d)
END_WRAP_TYPE()
SET(itk_Wrap_Vector ${WRAPPER_TEMPLATES})

WRAP_TYPE("CovariantVector" "CV")
  FOREACH(d ${WRAP_DIMS})
    WRAP("${ITKM_F}${d}"  "${ITKT_F},${d}")
    WRAP("${ITKM_D}${d}"  "${ITKT_D},${d}")
  ENDFOREACH(d)
END_WRAP_TYPE()
SET(itk_Wrap_CovariantVector ${WRAPPER_TEMPLATES})

WRAP_TYPE("ContinuousIndex" "CI")
  FOREACH(d ${WRAP_DIMS})
    WRAP("${ITKM_F}${d}"  "${ITKT_F},${d}")
    WRAP("${ITKM_D}${d}"  "${ITKT_D},${d}")
  ENDFOREACH(d)
END_WRAP_TYPE()
SET(itk_Wrap_ContinuousIndex ${WRAPPER_TEMPLATES})

WRAP_TYPE("Array" "A")
  WRAP("${ITKM_D}" "${ITKT_D}")
  WRAP("${ITKM_F}" "${ITKT_F}")
END_WRAP_TYPE()
SET(itk_Wrap_Array ${WRAPPER_TEMPLATES})

WRAP_TYPE("FixedArray" "FA")
   WRAP("${ITKM_D}1"  "${ITKT_D},1")
   WRAP("${ITKM_F}1"  "${ITKT_F},1")
   WRAP("${ITKM_UL}1" "${ITKT_UL},1")
   WRAP("${ITKM_US}1" "${ITKT_US},1")
   WRAP("${ITKM_UC}1" "${ITKT_UC},1")
   WRAP("${ITKM_UI}1" "${ITKT_UI},1")
   WRAP("${ITKM_SL}1" "${ITKT_SL},1")
   WRAP("${ITKM_SS}1" "${ITKT_SS},1")
   WRAP("${ITKM_SC}1" "${ITKT_SC},1")
   WRAP("${ITKM_B}1"  "${ITKT_B},1")

  FOREACH(d ${WRAP_DIMS})
    IF(NOT "${d}" EQUAL 1)
      WRAP("${ITKM_D}${d}"  "${ITKT_D},${d}")
      WRAP("${ITKM_F}${d}"  "${ITKT_F},${d}")
      WRAP("${ITKM_UL}${d}" "${ITKT_UL},${d}")
      WRAP("${ITKM_US}${d}" "${ITKT_US},${d}")
      WRAP("${ITKM_UC}${d}" "${ITKT_UC},${d}")
      WRAP("${ITKM_UI}${d}" "${ITKT_UI},${d}")
      WRAP("${ITKM_SL}${d}" "${ITKT_SL},${d}")
      WRAP("${ITKM_SS}${d}" "${ITKT_SS},${d}")
      WRAP("${ITKM_SC}${d}" "${ITKT_SC},${d}")
      WRAP("${ITKM_B}${d}"  "${ITKT_B},${d}")
    ENDIF(NOT "${d}" EQUAL 1)
  ENDFOREACH(d)
END_WRAP_TYPE()
SET(itk_Wrap_FixedArray ${WRAPPER_TEMPLATES})

WRAP_TYPE("RGBPixel" "RGB")
  COND_WRAP("${ITKM_UC}" "${ITKT_UC}" "RGBUC")
  COND_WRAP("${ITKM_US}" "${ITKT_US}" "RGBUS")
END_WRAP_TYPE()
SET(itk_Wrap_RGBPixel ${WRAPPER_TEMPLATES})

WRAP_TYPE("Image" "I")
  FOREACH(d ${WRAP_DIMS})
    COND_WRAP("${ITKM_F}${d}"  "${ITKT_F},${d}"  "F")
    COND_WRAP("${ITKM_D}${d}"  "${ITKT_D},${d}"  "") # needed for BSplineDeformableTransform
    COND_WRAP("${ITKM_UC}${d}" "${ITKT_UC},${d}" "") # needed to save in 8 bits
    COND_WRAP("${ITKM_US}${d}" "${ITKT_US},${d}" "US")
    COND_WRAP("${ITKM_UL}${d}" "${ITKT_UL},${d}" "") # needed for watershed and relabel filters
    COND_WRAP("${ITKM_SC}${d}" "${ITKT_SC},${d}" "SC")
    COND_WRAP("${ITKM_SS}${d}" "${ITKT_SS},${d}" "SS")
    COND_WRAP("${ITKM_SL}${d}" "${ITKT_SL},${d}" "SL")
    COND_WRAP("${ITKM_VF${d}}${d}" "${ITKT_VF${d}},${d}" "VF")
    COND_WRAP("${ITKM_VD${d}}${d}" "${ITKT_VD${d}},${d}" "VD")
    COND_WRAP("${ITKM_CVF${d}}${d}" "${ITKT_CVF${d}},${d}" "CVF")
    COND_WRAP("${ITKM_CVD${d}}${d}" "${ITKT_CVD${d}},${d}" "CVD")
    WRAP("${ITKM_O${d}}${d}" "${ITKT_O${d}},${d}")
    COND_WRAP("${ITKM_RGBUC}${d}" "${ITKT_RGBUC},${d}" "RGBUC")
    COND_WRAP("${ITKM_RGBUS}${d}" "${ITKT_RGBUS},${d}" "RGBUS")
  ENDFOREACH(d)
END_WRAP_TYPE()
SET(itk_Wrap_Image ${WRAPPER_TEMPLATES})

WRAP_TYPE("Point" "P")
  FOREACH(d ${WRAP_DIMS})
    WRAP("${ITKM_F}${d}"  "${ITKT_F},${d}")
    WRAP("${ITKM_D}${d}"  "${ITKT_D},${d}")
  ENDFOREACH(d)
END_WRAP_TYPE()
SET(itk_Wrap_Point ${WRAPPER_TEMPLATES})

WRAP_TYPE("LevelSetNode" "LSN")
  FOREACH(d ${WRAP_DIMS})
    WRAP("${ITKM_F}${d}"  "${ITKT_F},${d}")
    WRAP("${ITKM_D}${d}"  "${ITKT_D},${d}")
    WRAP("${ITKM_UC}${d}" "${ITKT_UC},${d}")
    WRAP("${ITKM_US}${d}" "${ITKT_US},${d}")
    WRAP("${ITKM_UL}${d}" "${ITKT_UL},${d}")
    WRAP("${ITKM_SC}${d}" "${ITKT_SC},${d}")
    WRAP("${ITKM_SS}${d}" "${ITKT_SS},${d}")
    WRAP("${ITKM_SL}${d}" "${ITKT_SL},${d}")
  ENDFOREACH(d)
END_WRAP_TYPE()
SET(itk_Wrap_LevelSetNode ${WRAPPER_TEMPLATES})

WRAP_TYPE("BinaryBallStructuringElement" "SE")
  FOREACH(d ${WRAP_DIMS})
    COND_WRAP("${ITKM_F}${d}"  "${ITKT_F},${d}"  "F")
    COND_WRAP("${ITKM_D}${d}"  "${ITKT_D},${d}"  "D")
    COND_WRAP("${ITKM_UC}${d}" "${ITKT_UC},${d}" "UC")
    COND_WRAP("${ITKM_US}${d}" "${ITKT_US},${d}" "US")
    COND_WRAP("${ITKM_UL}${d}" "${ITKT_UL},${d}" "UL")
    COND_WRAP("${ITKM_SC}${d}" "${ITKT_SC},${d}" "SC")
    COND_WRAP("${ITKM_SS}${d}" "${ITKT_SS},${d}" "SS")
    COND_WRAP("${ITKM_SL}${d}" "${ITKT_SL},${d}" "SL")
  ENDFOREACH(d)
END_WRAP_TYPE()
SET(itk_Wrap_StructuringElement ${WRAPPER_TEMPLATES})

WRAP_TYPE("SpatialObject" "SO")
  FOREACH(d ${WRAP_DIMS})
    WRAP("${d}"  "${d}")
  ENDFOREACH(d)
END_WRAP_TYPE()
SET(itk_Wrap_SpatialObject ${WRAPPER_TEMPLATES})
