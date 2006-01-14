SET(ITK_LIBRARY "ITKCommonA")
STRING(TOLOWER ${ITK_LIBRARY} ITK_LIBRARY_LANG)
SET(ITK_LANG_FILE "${WrapITK_BINARY_DIR}/#MODULE_LANG#/${ITK_LIBRARY_LANG}")
WRITE_LANG_BEGIN("itkcommon" "${ITK_LANG_FILE}")

SET(CXX_OUTPUT_DIR "${WrapITK_BINARY_DIR}/CommonA")

#------------------------------------------------------------------------------
# create a list of groups
# IMPORTANT : order has consequences
SET(WRAP_GROUPS
    itkOffset
    itkArray
    itkContinuousIndex
    itkVector
    itkPoint
    itkRGBPixel
    itkImage
    itkLevelSet
    itkDefaultStaticMeshTraits

    ITKCommonBase
    ITKRegions
    itkBinaryBallStructuringElement
    itkDenseFiniteDifferenceImageFilter
    itkDifferenceImageFilter
    itkEventObjects
    itkFiniteDifferenceFunction
    itkFiniteDifferenceImageFilter
    itkFixedArray
    itkFunctionBase
    itkImageConstIterator
    itkImageFunction
    itkImageRegionIterator
    itkImageRegionConstIterator
    itkImageSource
    itkImageToImageFilter
    itkIndex
    itkInPlaceImageFilter
    ITKInterpolators
    itkNeighborhood
    itkSize
    itkMatrix
    itkVectorContainer
    itkSimpleDataObjectDecorator
    itkImageBoundaryCondition
    itkPointSet
)

#------------------------------------------------------------------------------
# create the wrap_ITKCommon*.cxx files
WRITE_MODULE_LANG("ITKCommonA" "${CXX_OUTPUT_DIR}" "${WRAP_GROUPS}")

#------------------------------------------------------------------------------
# create a list of files for templating
# IMPORTANT : order has consequences
SET(WRAP_CXX_EXTRA
    ITKUtils
    ITKPyUtils
)

FOREACH(file ${WRAP_GROUPS} ${WRAP_CXX_EXTRA})
   INCLUDE_WRAP_CMAKE(${file} "${CXX_OUTPUT_DIR}")
ENDFOREACH(file ${WRAP_CXX_SOURCES})

#------------------------------------------------------------------------------
# create a list of cable config files for wrapping
SET(WRAP_SOURCES
  ${WRAP_CXX_SOURCES}
  wrap_SwigExtras
)

INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR})

SET(MASTER_INDEX_FILES "${WrapITK_BINARY_DIR}/VXLNumerics/VXLNumerics.mdx"
                       "${WrapITK_BINARY_DIR}/CommonA/ITKCommonA.mdx"
)
SET(ITK_SWIG_FILE ${WrapITK_SOURCE_DIR}/CommonA/SwigExtras.i)
SET(ITK_SWIG_FILE_CXX ${WrapITK_BINARY_DIR}/CommonA/SwigExtras_wrap)

SET(ITK_EXTRA_TCL_SOURCES itkTclCommand.cxx)
SET(ITK_EXTRA_PYTHON_SOURCES itkPyCommand.cxx)

SET(ITK_EXTRA_PYTHON_WRAP wrap_ITKPyUtils )
SET(ITK_EXTRA_TCL_WRAP wrap_ITKUtils)

ITK_WRAP_LIBRARY("${WRAP_GROUPS}" ITKCommonA CommonA "VXLNumerics" itkStringStream.cxx "ITKCommon"
  "${MASTER_INDEX_FILES}" "${WrapITK_SOURCE_DIR}" "${WrapITK_BINARY_DIR}")

#------------------------------------------------------------------------------
WRITE_LANG_END()

#------------------------------------------------------------------------------
