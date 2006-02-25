#------------------------------------------------------------------------------

# define some macro to help creation of types vars

MACRO(WRAP_TYPE class prefix)
   # begin the creation of a type vars
   # call to this macro should be followed by one or several call to WRAP_TEMPLATE()
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
  FOREACH(d ${WRAP_ITK_DIMS})
    WRAP_TEMPLATE("${d}"  "${d}")
  ENDFOREACH(d)
END_WRAP_TYPE()
SET(itk_Wrap_Offset ${WRAPPER_TEMPLATES})

WRAP_TYPE("Vector" "V")
  FOREACH(d ${WRAP_ITK_DIMS})
    WRAP_TEMPLATE("${ITKM_F}${d}"  "${ITKT_F},${d}")
    WRAP_TEMPLATE("${ITKM_D}${d}"  "${ITKT_D},${d}")
  ENDFOREACH(d)
END_WRAP_TYPE()
SET(itk_Wrap_Vector ${WRAPPER_TEMPLATES})

WRAP_TYPE("CovariantVector" "CV")
  FOREACH(d ${WRAP_ITK_DIMS})
    WRAP_TEMPLATE("${ITKM_F}${d}"  "${ITKT_F},${d}")
    WRAP_TEMPLATE("${ITKM_D}${d}"  "${ITKT_D},${d}")
  ENDFOREACH(d)
END_WRAP_TYPE()
SET(itk_Wrap_CovariantVector ${WRAPPER_TEMPLATES})

WRAP_TYPE("ContinuousIndex" "CI")
  FOREACH(d ${WRAP_ITK_DIMS})
    WRAP_TEMPLATE("${ITKM_F}${d}"  "${ITKT_F},${d}")
    WRAP_TEMPLATE("${ITKM_D}${d}"  "${ITKT_D},${d}")
  ENDFOREACH(d)
END_WRAP_TYPE()
SET(itk_Wrap_ContinuousIndex ${WRAPPER_TEMPLATES})

WRAP_TYPE("Array" "A")
  WRAP_TEMPLATE("${ITKM_D}" "${ITKT_D}")
  WRAP_TEMPLATE("${ITKM_F}" "${ITKT_F}")
END_WRAP_TYPE()
SET(itk_Wrap_Array ${WRAPPER_TEMPLATES})

WRAP_TYPE("FixedArray" "FA")
   WRAP_TEMPLATE("${ITKM_D}1"  "${ITKT_D},1")
   WRAP_TEMPLATE("${ITKM_F}1"  "${ITKT_F},1")
   WRAP_TEMPLATE("${ITKM_UL}1" "${ITKT_UL},1")
   WRAP_TEMPLATE("${ITKM_US}1" "${ITKT_US},1")
   WRAP_TEMPLATE("${ITKM_UC}1" "${ITKT_UC},1")
   WRAP_TEMPLATE("${ITKM_UI}1" "${ITKT_UI},1")
   WRAP_TEMPLATE("${ITKM_SL}1" "${ITKT_SL},1")
   WRAP_TEMPLATE("${ITKM_SS}1" "${ITKT_SS},1")
   WRAP_TEMPLATE("${ITKM_SC}1" "${ITKT_SC},1")
   WRAP_TEMPLATE("${ITKM_B}1"  "${ITKT_B},1")

  FOREACH(d ${WRAP_ITK_DIMS})
    IF(NOT "${d}" EQUAL 1)
      WRAP_TEMPLATE("${ITKM_D}${d}"  "${ITKT_D},${d}")
      WRAP_TEMPLATE("${ITKM_F}${d}"  "${ITKT_F},${d}")
      WRAP_TEMPLATE("${ITKM_UL}${d}" "${ITKT_UL},${d}")
      WRAP_TEMPLATE("${ITKM_US}${d}" "${ITKT_US},${d}")
      WRAP_TEMPLATE("${ITKM_UC}${d}" "${ITKT_UC},${d}")
      WRAP_TEMPLATE("${ITKM_UI}${d}" "${ITKT_UI},${d}")
      WRAP_TEMPLATE("${ITKM_SL}${d}" "${ITKT_SL},${d}")
      WRAP_TEMPLATE("${ITKM_SS}${d}" "${ITKT_SS},${d}")
      WRAP_TEMPLATE("${ITKM_SC}${d}" "${ITKT_SC},${d}")
      WRAP_TEMPLATE("${ITKM_B}${d}"  "${ITKT_B},${d}")
    ENDIF(NOT "${d}" EQUAL 1)
  ENDFOREACH(d)
END_WRAP_TYPE()
SET(itk_Wrap_FixedArray ${WRAPPER_TEMPLATES})

WRAP_TYPE("RGBPixel" "RGB")
  WRAP_TEMPLATE_IF_TYPES("${ITKM_UC}" "${ITKT_UC}" "RGBUC")
  WRAP_TEMPLATE_IF_TYPES("${ITKM_US}" "${ITKT_US}" "RGBUS")
END_WRAP_TYPE()
SET(itk_Wrap_RGBPixel ${WRAPPER_TEMPLATES})

WRAP_TYPE("Image" "I")
  FOREACH(d ${WRAP_ITK_DIMS})
    WRAP_TEMPLATE_IF_TYPES("${ITKM_F}${d}"  "${ITKT_F},${d}"  "F")
    WRAP_TEMPLATE_IF_TYPES("${ITKM_D}${d}"  "${ITKT_D},${d}"  "") # needed for BSplineDeformableTransform
    WRAP_TEMPLATE_IF_TYPES("${ITKM_UC}${d}" "${ITKT_UC},${d}" "") # needed to save in 8 bits
    WRAP_TEMPLATE_IF_TYPES("${ITKM_US}${d}" "${ITKT_US},${d}" "US")
    WRAP_TEMPLATE_IF_TYPES("${ITKM_UL}${d}" "${ITKT_UL},${d}" "") # needed for watershed and relabel filters
    WRAP_TEMPLATE_IF_TYPES("${ITKM_SC}${d}" "${ITKT_SC},${d}" "SC")
    WRAP_TEMPLATE_IF_TYPES("${ITKM_SS}${d}" "${ITKT_SS},${d}" "SS")
    WRAP_TEMPLATE_IF_TYPES("${ITKM_SL}${d}" "${ITKT_SL},${d}" "SL")
    WRAP_TEMPLATE_IF_TYPES("${ITKM_VF${d}}${d}" "${ITKT_VF${d}},${d}" "VF")
    WRAP_TEMPLATE_IF_TYPES("${ITKM_VD${d}}${d}" "${ITKT_VD${d}},${d}" "VD")
    WRAP_TEMPLATE_IF_TYPES("${ITKM_CVF${d}}${d}" "${ITKT_CVF${d}},${d}" "CVF")
    WRAP_TEMPLATE_IF_TYPES("${ITKM_CVD${d}}${d}" "${ITKT_CVD${d}},${d}" "CVD")
    WRAP_TEMPLATE("${ITKM_O${d}}${d}" "${ITKT_O${d}},${d}")
    WRAP_TEMPLATE_IF_TYPES("${ITKM_RGBUC}${d}" "${ITKT_RGBUC},${d}" "RGBUC")
    WRAP_TEMPLATE_IF_TYPES("${ITKM_RGBUS}${d}" "${ITKT_RGBUS},${d}" "RGBUS")
  ENDFOREACH(d)
END_WRAP_TYPE()
SET(itk_Wrap_Image ${WRAPPER_TEMPLATES})

WRAP_TYPE("Point" "P")
  FOREACH(d ${WRAP_ITK_DIMS})
    WRAP_TEMPLATE("${ITKM_F}${d}"  "${ITKT_F},${d}")
    WRAP_TEMPLATE("${ITKM_D}${d}"  "${ITKT_D},${d}")
  ENDFOREACH(d)
END_WRAP_TYPE()
SET(itk_Wrap_Point ${WRAPPER_TEMPLATES})

WRAP_TYPE("LevelSetNode" "LSN")
  FOREACH(d ${WRAP_ITK_DIMS})
    WRAP_TEMPLATE("${ITKM_F}${d}"  "${ITKT_F},${d}")
    WRAP_TEMPLATE("${ITKM_D}${d}"  "${ITKT_D},${d}")
    WRAP_TEMPLATE("${ITKM_UC}${d}" "${ITKT_UC},${d}")
    WRAP_TEMPLATE("${ITKM_US}${d}" "${ITKT_US},${d}")
    WRAP_TEMPLATE("${ITKM_UL}${d}" "${ITKT_UL},${d}")
    WRAP_TEMPLATE("${ITKM_SC}${d}" "${ITKT_SC},${d}")
    WRAP_TEMPLATE("${ITKM_SS}${d}" "${ITKT_SS},${d}")
    WRAP_TEMPLATE("${ITKM_SL}${d}" "${ITKT_SL},${d}")
  ENDFOREACH(d)
END_WRAP_TYPE()
SET(itk_Wrap_LevelSetNode ${WRAPPER_TEMPLATES})

WRAP_TYPE("BinaryBallStructuringElement" "SE")
  FOREACH(d ${WRAP_ITK_DIMS})
    WRAP_TEMPLATE_IF_TYPES("${ITKM_F}${d}"  "${ITKT_F},${d}"  "F")
    WRAP_TEMPLATE_IF_TYPES("${ITKM_D}${d}"  "${ITKT_D},${d}"  "D")
    WRAP_TEMPLATE_IF_TYPES("${ITKM_UC}${d}" "${ITKT_UC},${d}" "UC")
    WRAP_TEMPLATE_IF_TYPES("${ITKM_US}${d}" "${ITKT_US},${d}" "US")
    WRAP_TEMPLATE_IF_TYPES("${ITKM_UL}${d}" "${ITKT_UL},${d}" "UL")
    WRAP_TEMPLATE_IF_TYPES("${ITKM_SC}${d}" "${ITKT_SC},${d}" "SC")
    WRAP_TEMPLATE_IF_TYPES("${ITKM_SS}${d}" "${ITKT_SS},${d}" "SS")
    WRAP_TEMPLATE_IF_TYPES("${ITKM_SL}${d}" "${ITKT_SL},${d}" "SL")
  ENDFOREACH(d)
END_WRAP_TYPE()
SET(itk_Wrap_StructuringElement ${WRAPPER_TEMPLATES})

WRAP_TYPE("SpatialObject" "SO")
  FOREACH(d ${WRAP_ITK_DIMS})
    WRAP_TEMPLATE("${d}"  "${d}")
  ENDFOREACH(d)
END_WRAP_TYPE()
SET(itk_Wrap_SpatialObject ${WRAPPER_TEMPLATES})

#------------------------------------------------------------------------------

# set the default include files for the generated wrapper files
SET(WRAPPER_DEFAULT_INCLUDE
  "itkOffset.h"
  "itkVector.h"
  "itkCovariantVector.h"
  "itkContinuousIndex.h"
  "itkArray.h"
  "itkFixedArray.h"
  "itkRGBPixel.h"
  "itkImage.h"
  "itkPoint.h"
  "itkLevelSet.h"
  "itkBinaryBallStructuringElement.h"
  "itkSpatialObject.h"
  "itkCommand.h"
)

