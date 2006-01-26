#------------------------------------------------------------------------------
MACRO(CREATE_WRAP_TYPE CLASS PREFIX WRAP)
   # Create wrapping types : ITKT_Xxx & ITKM_Xxx
   FOREACH(wrap ${WRAP})
      STRING(REGEX REPLACE
         "([0-9A-Za-z]*)[ ]*#[ ]*(.*)"
         "\\1"
         wrapTpl "${wrap}"
      )
      STRING(REGEX REPLACE
         "([0-9A-Za-z]*)[ ]*#[ ]*(.*)"
         "\\2"
         wrapType "${wrap}"
      )
      SET(ITKT_${PREFIX}${wrapTpl} "itk::${CLASS}< ${wrapType} >")
      SET(ITKM_${PREFIX}${wrapTpl} "${PREFIX}${wrapTpl}")
   ENDFOREACH(wrap ${WRAP})
ENDMACRO(CREATE_WRAP_TYPE)

MACRO(WRAP_TYPE class prefix)
   SET(WRAPPER_TEMPLATES "")
   SET(itk_Wrap_Prefix "${prefix}")
   SET(itk_Wrap_Class "${class}")
ENDMACRO(WRAP_TYPE)

MACRO(END_WRAP_TYPE)
   CREATE_WRAP_TYPE("${itk_Wrap_Class}" "${itk_Wrap_Prefix}" "${WRAPPER_TEMPLATES}")
ENDMACRO(END_WRAP_TYPE)

WRAP_TYPE("Offset" "O")
  FOREACH(d ${WRAP_DIMS})
    WRAP("${d}"  "${d}")
  ENDFOREACH(d)
END_WRAP_TYPE()
SET(itk_Wrap_Offset ${WRAPPER_TEMPLATES})

#------------------------------------------------------------------------------
WRAP_TYPE("Vector" "V")
  FOREACH(d ${WRAP_DIMS})
    WRAP("${ITKM_F}${d}"  "${ITKT_F},${d}")
    WRAP("${ITKM_D}${d}"  "${ITKT_D},${d}")
  ENDFOREACH(d)
END_WRAP_TYPE()
SET(itk_Wrap_Vector ${WRAPPER_TEMPLATES})

#------------------------------------------------------------------------------
WRAP_TYPE("CovariantVector" "CV")
  FOREACH(d ${WRAP_DIMS})
    WRAP("${ITKM_F}${d}"  "${ITKT_F},${d}")
    WRAP("${ITKM_D}${d}"  "${ITKT_D},${d}")
  ENDFOREACH(d)
END_WRAP_TYPE()
SET(itk_Wrap_CovariantVector ${WRAPPER_TEMPLATES})

#------------------------------------------------------------------------------
WRAP_TYPE("ContinuousIndex" "CI")
  FOREACH(d ${WRAP_DIMS})
    WRAP("${ITKM_F}${d}"  "${ITKT_F},${d}")
    WRAP("${ITKM_D}${d}"  "${ITKT_D},${d}")
  ENDFOREACH(d)
END_WRAP_TYPE()
SET(itk_Wrap_ContinuousIndex ${WRAPPER_TEMPLATES})

#------------------------------------------------------------------------------
SET(WRAP_PREFIX_Array "A")
SET(itk_Wrap_Array
   "${ITKM_D}  # ${ITKT_D}"
   "${ITKM_F}  # ${ITKT_F}"
)
CREATE_WRAP_TYPE("Array" ${WRAP_PREFIX_Array} "${itk_Wrap_Array}")

#------------------------------------------------------------------------------
SET(WRAP_PREFIX_FixedArray "FA")
SET(itk_Wrap_FixedArray
   "${ITKM_D}1  # ${ITKT_D},1"
   "${ITKM_F}1  # ${ITKT_F},1"
   "${ITKM_UL}1 # ${ITKT_UL},1"
   "${ITKM_US}1 # ${ITKT_US},1"
   "${ITKM_UC}1 # ${ITKT_UC},1"
   "${ITKM_UI}1 # ${ITKT_UI},1"
   "${ITKM_SL}1 # ${ITKT_SL},1"
   "${ITKM_SS}1 # ${ITKT_SS},1"
   "${ITKM_SC}1 # ${ITKT_SC},1"
   "${ITKM_B}1 # ${ITKT_B},1"

   "${ITKM_D}2  # ${ITKT_D},2"
   "${ITKM_F}2  # ${ITKT_F},2"
   "${ITKM_UL}2 # ${ITKT_UL},2"
   "${ITKM_US}2 # ${ITKT_US},2"
   "${ITKM_UC}2 # ${ITKT_UC},2"
   "${ITKM_UI}2 # ${ITKT_UI},2"
   "${ITKM_SL}2 # ${ITKT_SL},2"
   "${ITKM_SS}2 # ${ITKT_SS},2"
   "${ITKM_SC}2 # ${ITKT_SC},2"
   "${ITKM_B}2 # ${ITKT_B},2"

   "${ITKM_D}3  # ${ITKT_D},3"
   "${ITKM_F}3  # ${ITKT_F},3"
   "${ITKM_UL}3 # ${ITKT_UL},3"
   "${ITKM_US}3 # ${ITKT_US},3"
   "${ITKM_UC}3 # ${ITKT_UC},3"
   "${ITKM_UI}3 # ${ITKT_UI},3"
   "${ITKM_SL}3 # ${ITKT_SL},3"
   "${ITKM_SS}3 # ${ITKT_SS},3"
   "${ITKM_SC}3 # ${ITKT_SC},3"
   "${ITKM_B}3 # ${ITKT_B},3"
)
CREATE_WRAP_TYPE("FixedArray" ${WRAP_PREFIX_FixedArray} "${itk_Wrap_FixedArray}")

#------------------------------------------------------------------------------
WRAP_TYPE("RGBPixel" "RGB")
  COND_WRAP("${ITKM_UC}" "${ITKT_UC}" "RGBUC")
  COND_WRAP("${ITKM_US}" "${ITKT_US}" "RGBUS")
END_WRAP_TYPE()
SET(itk_Wrap_RGBPixel ${WRAPPER_TEMPLATES})


#------------------------------------------------------------------------------
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


#------------------------------------------------------------------------------
WRAP_TYPE("Point" "P")
  FOREACH(d ${WRAP_DIMS})
    WRAP("${ITKM_F}${d}"  "${ITKT_F},${d}")
    WRAP("${ITKM_D}${d}"  "${ITKT_D},${d}")
  ENDFOREACH(d)
END_WRAP_TYPE()
SET(itk_Wrap_Point ${WRAPPER_TEMPLATES})

#------------------------------------------------------------------------------
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


#------------------------------------------------------------------------------
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

#------------------------------------------------------------------------------
WRAP_TYPE("SpatialObject" "SO")
  FOREACH(d ${WRAP_DIMS})
    WRAP("${d}"  "${d}")
  ENDFOREACH(d)
END_WRAP_TYPE()
SET(itk_Wrap_SpatialObject ${WRAPPER_TEMPLATES})

#------------------------------------------------------------------------------
