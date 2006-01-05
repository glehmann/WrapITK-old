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
   SET(itk_Wrap "")
   SET(itk_Wrap_Prefix "${prefix}")
   SET(itk_Wrap_Class "${class}")
ENDMACRO(WRAP_TYPE)

MACRO(END_WRAP_TYPE)
   CREATE_WRAP_TYPE("${itk_Wrap_Class}" "${itk_Wrap_Prefix}" "${itk_Wrap}")
ENDMACRO(END_WRAP_TYPE)

SET(itk_DefaultInclude
  Offset
  Vector
  CovariantVector
  ContinuousIndex
  Array
  FixedArray
  Image
  Point
  LevelSet
  BinaryBallStructuringElement
  SpatialObject
)

WRAP_TYPE("Offset" "O")
  WRAP(2 2)
  WRAP(3 3)
END_WRAP_TYPE()
SET(itk_Wrap_Offset ${itk_Wrap})

#------------------------------------------------------------------------------
SET(WRAP_PREFIX_Vector "V")
SET(itk_Wrap_Vector
   "${ITKM_F}2  # ${ITKT_F},2"
   "${ITKM_F}3  # ${ITKT_F},3"
   "${ITKM_D}2  # ${ITKT_D},2"
   "${ITKM_D}3  # ${ITKT_D},3"
)
CREATE_WRAP_TYPE("Vector" ${WRAP_PREFIX_Vector} "${itk_Wrap_Vector}")

#------------------------------------------------------------------------------
SET(WRAP_PREFIX_CovariantVector "CV")
SET(itk_Wrap_CovariantVector
   "${ITKM_F}2  # ${ITKT_F},2"
   "${ITKM_F}3  # ${ITKT_F},3"
   "${ITKM_D}2  # ${ITKT_D},2"
   "${ITKM_D}3  # ${ITKT_D},3"
)
CREATE_WRAP_TYPE("CovariantVector" ${WRAP_PREFIX_CovariantVector} "${itk_Wrap_CovariantVector}")

#------------------------------------------------------------------------------
SET(WRAP_PREFIX_ContinuousIndex "CI")
SET(itk_Wrap_ContinuousIndex
    "${ITKM_F}2 # ${ITKT_F},2"
    "${ITKM_F}3 # ${ITKT_F},3"
    "${ITKM_D}2 # ${ITKT_D},2"
    "${ITKM_D}3 # ${ITKT_D},3"
)
CREATE_WRAP_TYPE("ContinuousIndex" ${WRAP_PREFIX_ContinuousIndex} "${itk_Wrap_ContinuousIndex}")

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
   "${ITKM_SL}1 # ${ITKT_SL},1"
   "${ITKM_SS}1 # ${ITKT_SS},1"
   "${ITKM_SC}1 # ${ITKT_SC},1"
   "${ITKM_B}1 # ${ITKT_B},1"

   "${ITKM_D}2  # ${ITKT_D},2"
   "${ITKM_F}2  # ${ITKT_F},2"
   "${ITKM_UL}2 # ${ITKT_UL},2"
   "${ITKM_US}2 # ${ITKT_US},2"
   "${ITKM_UC}2 # ${ITKT_UC},2"
   "${ITKM_SL}2 # ${ITKT_SL},2"
   "${ITKM_SS}2 # ${ITKT_SS},2"
   "${ITKM_SC}2 # ${ITKT_SC},2"
   "${ITKM_B}2 # ${ITKT_B},2"

   "${ITKM_D}3  # ${ITKT_D},3"
   "${ITKM_F}3  # ${ITKT_F},3"
   "${ITKM_UL}3 # ${ITKT_UL},3"
   "${ITKM_US}3 # ${ITKT_US},3"
   "${ITKM_UC}3 # ${ITKT_UC},3"
   "${ITKM_SL}3 # ${ITKT_SL},3"
   "${ITKM_SS}3 # ${ITKT_SS},3"
   "${ITKM_SC}3 # ${ITKT_SC},3"
   "${ITKM_B}3 # ${ITKT_B},3"
)
CREATE_WRAP_TYPE("FixedArray" ${WRAP_PREFIX_FixedArray} "${itk_Wrap_FixedArray}")

#------------------------------------------------------------------------------
WRAP_TYPE("Image" "I")
  COND_WRAP("${ITKM_F}2"  "${ITKT_F},2"  "F")
  COND_WRAP("${ITKM_D}2"  "${ITKT_D},2"  "") # needed for BSplineDeformableTransform
  COND_WRAP("${ITKM_UC}2" "${ITKT_UC},2" "") # needed to save in 8 bits
  COND_WRAP("${ITKM_US}2" "${ITKT_US},2" "US")
  COND_WRAP("${ITKM_UL}2" "${ITKT_UL},2" "") # needed for watershed and relabel filters
  COND_WRAP("${ITKM_SC}2" "${ITKT_SC},2" "SC")
  COND_WRAP("${ITKM_SS}2" "${ITKT_SS},2" "SS")
  COND_WRAP("${ITKM_SL}2" "${ITKT_SL},2" "SL")
  COND_WRAP("${ITKM_VF2}2" "${ITKT_VF2},2" "VF")
  COND_WRAP("${ITKM_VD2}2" "${ITKT_VD2},2" "VD")
  COND_WRAP("${ITKM_CVF2}2" "${ITKT_CVF2},2" "CVF")
  COND_WRAP("${ITKM_CVD2}2" "${ITKT_CVD2},2" "CVD")
  WRAP("${ITKM_O2}2" "${ITKT_O2},2")
END_WRAP_TYPE()
SET(itk_Wrap_Image_2D ${itk_Wrap})

WRAP_TYPE("Image" "I")
  COND_WRAP("${ITKM_F}3"  "${ITKT_F},3"  "F")
  COND_WRAP("${ITKM_D}3"  "${ITKT_D},3"  "") # needed for BSplineDeformableTransform
  COND_WRAP("${ITKM_UC}3" "${ITKT_UC},3" "") # needed to save in 8 bits
  COND_WRAP("${ITKM_US}3" "${ITKT_US},3" "US")
  COND_WRAP("${ITKM_UL}3" "${ITKT_UL},3" "") # needed for watershed and relabel filters
  COND_WRAP("${ITKM_SC}3" "${ITKT_SC},3" "SC")
  COND_WRAP("${ITKM_SS}3" "${ITKT_SS},3" "SS")
  COND_WRAP("${ITKM_SL}3" "${ITKT_SL},3" "SL")
  COND_WRAP("${ITKM_VF3}3" "${ITKT_VF3},3" "VF")
  COND_WRAP("${ITKM_VD3}3" "${ITKT_VD3},3" "VD")
  COND_WRAP("${ITKM_CVF3}3" "${ITKT_CVF3},3" "CVF")
  COND_WRAP("${ITKM_CVD3}3" "${ITKT_CVD3},3" "CVD")
  WRAP("${ITKM_O3}3" "${ITKT_O3},3")
END_WRAP_TYPE()
SET(itk_Wrap_Image_3D ${itk_Wrap})

#------------------------------------------------------------------------------
SET(WRAP_PREFIX_Point "P")
SET(itk_Wrap_Point
   "${ITKM_F}2  # ${ITKT_F},2"
   "${ITKM_F}3  # ${ITKT_F},3"
   "${ITKM_D}2  # ${ITKT_D},2"
   "${ITKM_D}3  # ${ITKT_D},3"
)
CREATE_WRAP_TYPE("Point" ${WRAP_PREFIX_Point} "${itk_Wrap_Point}")

#------------------------------------------------------------------------------
SET(WRAP_PREFIX_LevelSetNode "LSN")
SET(itk_Wrap_LevelSetNode
   "${ITKM_F}2    # ${ITKT_F},2"
   "${ITKM_D}2    # ${ITKT_D},2"
   "${ITKM_UC}2   # ${ITKT_UC},2"
   "${ITKM_US}2   # ${ITKT_US},2"
   "${ITKM_UL}2   # ${ITKT_UL},2"
   "${ITKM_SC}2   # ${ITKT_SC},2"
   "${ITKM_SS}2   # ${ITKT_SS},2"
   "${ITKM_SL}2   # ${ITKT_SL},2"

   "${ITKM_F}3    # ${ITKT_F},3"
   "${ITKM_D}3    # ${ITKT_D},3"
   "${ITKM_UC}3   # ${ITKT_UC},3"
   "${ITKM_US}3   # ${ITKT_US},3"
   "${ITKM_UL}3   # ${ITKT_UL},3"
   "${ITKM_SC}3   # ${ITKT_SC},3"
   "${ITKM_SS}3   # ${ITKT_SS},3"
   "${ITKM_SL}3   # ${ITKT_SL},3"
)
CREATE_WRAP_TYPE("LevelSetNode" ${WRAP_PREFIX_LevelSetNode} "${itk_Wrap_LevelSetNode}")

#------------------------------------------------------------------------------
WRAP_TYPE("BinaryBallStructuringElement" "SE")
  COND_WRAP("${ITKM_F}2"  "${ITKT_F},2"  "F")
  COND_WRAP("${ITKM_D}2"  "${ITKT_D},2"  "D")
  COND_WRAP("${ITKM_UC}2" "${ITKT_UC},2" "UC")
  COND_WRAP("${ITKM_US}2" "${ITKT_US},2" "US")
  COND_WRAP("${ITKM_UL}2" "${ITKT_UL},2" "UL")
  COND_WRAP("${ITKM_SC}2" "${ITKT_SC},2" "SC")
  COND_WRAP("${ITKM_SS}2" "${ITKT_SS},2" "SS")
  COND_WRAP("${ITKM_SL}2" "${ITKT_SL},2" "SL")
  COND_WRAP("${ITKM_F}3"  "${ITKT_F},3"  "F")
  COND_WRAP("${ITKM_D}3"  "${ITKT_D},3"  "D")
  COND_WRAP("${ITKM_UC}3" "${ITKT_UC},3" "UC")
  COND_WRAP("${ITKM_US}3" "${ITKT_US},3" "US")
  COND_WRAP("${ITKM_UL}3" "${ITKT_UL},3" "UL")
  COND_WRAP("${ITKM_SC}3" "${ITKT_SC},3" "SC")
  COND_WRAP("${ITKM_SS}3" "${ITKT_SS},3" "SS")
  COND_WRAP("${ITKM_SL}3" "${ITKT_SL},3" "SL")
END_WRAP_TYPE()
SET(itk_Wrap_StructuringElement ${itk_Wrap})

#------------------------------------------------------------------------------
SET(WRAP_PREFIX_SpatialObject "SO")
SET(itk_Wrap_SpatialObject
    "2 # 2"
    "3 # 3"
)
CREATE_WRAP_TYPE("SpatialObject" ${WRAP_PREFIX_SpatialObject} "${itk_Wrap_SpatialObject}")

#------------------------------------------------------------------------------
