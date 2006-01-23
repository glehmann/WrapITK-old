BEGIN_WRAPPER_LIBRARY("ITKCommonA")

SET(WRAPPER_LIBRARY_GROUPS
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
    itkPointSet)

SET(WRAPPER_LIBRARY_DEPENDS VXLNumerics)


SET(WRAPPER_LIBRARY_CABLESWIG_INPUTS "${CMAKE_SURRENT_SOURCE_DIR}/wrap_SwigExtras.cxx")
SET(WRAPPER_LIBRARY_SWIG_INPUTS "${CMAKE_SURRENT_SOURCE_DIR}/SwigExtras.i") 

# Need to include the current dir because the compiler needs to find itkStringStream.h
INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR})
SET(WRAPPER_LIBRARY_CXX_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/itkStringStream.cxx") 

SET(WRAPPER_LIBRARY_LINK_LIBRARIES ITKCommon)

WRAPPER_LIBRARY_CREATE_WRAP_FILES()

WRAPPER_LIBRARY_CREATE_LIBRARY()


