FIND_PACKAGE(WrapITK REQUIRED)

BEGIN_WRAPPER_LIBRARY(${PROJECT_NAME})
SET(WRAPPER_SWIG_LIBRARY_FILES ${WRAPPER_SWIG_LIBRARY_FILES} "${CMAKE_CURRENT_SOURCE_DIR}/itkvtk.swg")
SET(WRAPPER_LIBRARY_AUTO_LOAD OFF) 
SET(WRAPPER_LIBRARY_DEPENDS ITKCommonA ITKBasicFiltersB)

WRAPPER_LIBRARY_CREATE_WRAP_FILES()
WRAPPER_LIBRARY_CREATE_LIBRARY()

# find the vtkImagingPython lib
# use CMAKE_LIBRARY_PATH or -DVTK_IMAGING_PYTHON:PATH=... to give another location
FIND_LIBRARY(VTK_IMAGING_PYTHON vtkImagingPython
  /usr/lib/python2.4/site-packages/vtk/
  /usr/lib/python2.3/site-packages/vtk/
  /usr/lib/python2.2/site-packages/vtk/
  /usr/lib/python2.1/site-packages/vtk/
  /usr/local/lib/python2.4/site-packages/vtk/
  /usr/local/lib/python2.3/site-packages/vtk/
  /usr/local/lib/python2.2/site-packages/vtk/
  /usr/local/lib/python2.1/site-packages/vtk/
)

MESSAGE(${VTK_IMAGING_PYTHON})

IF(WRAP_ITK_PYTHON)
  TARGET_LINK_LIBRARIES(_${WRAPPER_LIBRARY_NAME}Python
                        ${VTK_IMAGING_PYTHON} ITKCommon ITKBasicFilters)
  WRAP_ITK_INSTALL("/Python" "${CMAKE_CURRENT_SOURCE_DIR}/Python/itkvtk.py")
ENDIF(WRAP_ITK_PYTHON)

