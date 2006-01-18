FIND_PACKAGE(WrapITK)
IF(NOT WrapITK_DIR)
  MESSAGE(FATAL_ERROR "Cannot build without WrapITK.  Please set WrapITK_DIR.")
ENDIF(NOT WrapITK_DIR)
INCLUDE("${WrapITK_DIR}/WrapITKConfig.cmake")

SET(ITK_SWG_FILES ${ITK_SWG_FILES} "${ItkVtk_SOURCE_DIR}/Wrapping/itk.swg")

SET(WRAP_ITK_SWIG_INCLUDE_DIRS
  ${WRAP_ITK_SWIG_INCLUDE_DIRS}
  ${ItkVtk_SOURCE_DIR}/src
  ${VTK_INCLUDE_DIRS}
)

INCLUDE_DIRECTORIES(${PROJECT_SOURCE_DIR})

#------------------------------------------------------------------------------
SET(ITK_LIBRARY "ItkVtk")
SET(CXX_OUTPUT_DIR "${PROJECT_BINARY_DIR}/Wrapping")

#------------------------------------------------------------------------------
# WRITE_SIMPLE_LANG_BEGIN(${ITK_LIBRARY})
WRITE_LANG_BEGIN("${ITK_LIBRARY}" "${PROJECT_BINARY_DIR}/Wrapping/${ITK_LIBRARY}")

# create a list of groups
# Add here modules that must be imported before the others.
SET(WRAP_GROUPS
  # nothing to add here for now
)

# include every wrap_*.cmake files in the directory
# and populate WRAP_GROUPS
AUTO_INCLUDE_WRAP_CMAKE(WRAP_GROUPS "" "${CXX_OUTPUT_DIR}")

# create the wrap_${ITK_LIBRARY}*.cxx files
WRITE_MODULE(${ITK_LIBRARY} "${CXX_OUTPUT_DIR}" "${WRAP_GROUPS}")

WRITE_LANG_END()

#------------------------------------------------------------------------------
# create the ${ITK_LIBRARY} libraries

SET(MASTER_INDEX_FILES 
  ${WRAP_ITK_MASTER_INDEX_FILES}
  "${PROJECT_BINARY_DIR}/Wrapping/${ITK_LIBRARY}.mdx"
)

ITK_WRAP_LIBRARY(
  "${WRAP_GROUPS}" 
  ${ITK_LIBRARY}
  "Wrapping"
  ""
  ""
  "ITKCommon;vtkImaging"
  "${MASTER_INDEX_FILES}"
  "${PROJECT_SOURCE_DIR}"
  "${PROJECT_BINARY_DIR}"
)


#------------------------------------------------------------------------------
# install language specific files and link with the language specific libs

IF(ITK_CSWIG_PYTHON)
  TARGET_LINK_LIBRARIES(_${ITK_LIBRARY}Python vtkImagingPythonD)
  INSTALL_FILES(${WRAP_ITK_INSTALL_LOCATION}/Python FILES "${ItkVtk_SOURCE_DIR}/Wrapping/Python/${ITK_LIBRARY}.py")
  INSTALL_FILES(${WRAP_ITK_INSTALL_LOCATION}/Python FILES "${ItkVtk_SOURCE_DIR}/Wrapping/Python/itkvtk.py")
ENDIF(ITK_CSWIG_PYTHON)

