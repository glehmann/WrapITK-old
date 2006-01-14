PROJECT(WrapITKPyBuffer)

SET(WRAP_ITK_DIR "" CACHE PATH "Path to build or install location of WrapITK")
IF(NOT WRAP_ITK_DIR)
  MESSAGE(FATAL_ERROR
          "Cannot build without WrapITK.  Please set WRAP_ITK_DIR.")
ENDIF(NOT WRAP_ITK_DIR)

INCLUDE("${WRAP_ITK_DIR}/UseWrapITK.cmake")

# Deal with numarray package  Options
SET(CMAKE_MODULE_PATH ${ITK_SOURCE_DIR}/CMake)
FIND_PACKAGE( NUMARRAY )

INCLUDE_DIRECTORIES( ${PYTHON_NUMARRAY_INCLUDE_DIR} )
SET(WRAP_ITK_SWIG_INCLUDE_DIRS ${WRAP_ITK_SWIG_INCLUDE_DIRS} ${PYTHON_NUMARRAY_INCLUDE_DIR})

INCLUDE_DIRECTORIES(${PROJECT_SOURCE_DIR})


SET(ITK_LIBRARY "BufferConversion")

SET(ITK_LIBRARY_LANG ${ITK_LIBRARY})
SET(ITK_LANG_FILE "${PROJECT_BINARY_DIR}/${ITK_LIBRARY_LANG}")
WRITE_LANG_BEGIN("${ITK_LIBRARY_LANG}Python")

SET(CXX_OUTPUT_DIR "${PROJECT_BINARY_DIR}")

#------------------------------------------------------------------------------
# create a list of groups
# Add here modules that must be imported before the others.
SET(WRAP_GROUPS
  # nothing to add here for now
)

# include every wrap_*.cmake files in the directory
# and populate WRAP_GROUPS
AUTO_INCLUDE_WRAP_CMAKE(WRAP_GROUPS "" "${CXX_OUTPUT_DIR}")

#------------------------------------------------------------------------------
# create the wrap_${ITK_LIBRARY}*.cxx files
WRITE_MODULE(${ITK_LIBRARY} "${CXX_OUTPUT_DIR}" "${WRAP_GROUPS}")

WRITE_LANG_END()

#------------------------------------------------------------------------------
# create the ${ITK_LIBRARY} libraries

SET(MASTER_INDEX_FILES 
  ${WRAP_ITK_MASTER_INDEX_FILES}
  "${PROJECT_BINARY_DIR}/${ITK_LIBRARY}.mdx"
)

ITK_WRAP_LIBRARY(
  "${WRAP_GROUPS}" 
  ${ITK_LIBRARY}
  "."
  ""
  ""
  "ITKCommon"
  "${MASTER_INDEX_FILES}"
  "${PROJECT_SOURCE_DIR}"
  "${PROJECT_BINARY_DIR}"
)

