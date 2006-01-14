SET(ITK_LIBRARY "ITKCommonB"  "${ITK_LANG_FILE}")
STRING(TOLOWER ${ITK_LIBRARY} ITK_LIBRARY_LANG)
SET(ITK_LANG_FILE "${WrapITK_BINARY_DIR}/#MODULE_LANG#/${ITK_LIBRARY_LANG}")
WRITE_LANG_BEGIN("itkcommon" "${ITK_LANG_FILE}")

SET(CXX_OUTPUT_DIR "${WrapITK_BINARY_DIR}/CommonB")

#------------------------------------------------------------------------------
# create a list of groups
# Add here modules that must be imported before the others.
SET(WRAP_GROUPS
  # nothing to add here for now
)

# include every wrap_*.cmake files in the directory
AUTO_INCLUDE_WRAP_CMAKE(WRAP_GROUPS "" "${CXX_OUTPUT_DIR}")

#------------------------------------------------------------------------------
# create the wrap_ITKBasicFilters*.cxx files
WRITE_MODULE("ITKCommonB" "${CXX_OUTPUT_DIR}" "${WRAP_GROUPS}")

#------------------------------------------------------------------------------
# create the ITKBasicFilters libraries

INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR})

SET(MASTER_INDEX_FILES "${WrapITK_BINARY_DIR}/VXLNumerics/VXLNumerics.mdx"
                       "${WrapITK_BINARY_DIR}/CommonA/ITKCommonA.mdx"
                       "${WrapITK_BINARY_DIR}/CommonB/ITKCommonB.mdx"
)

ITK_WRAP_LIBRARY("${WRAP_GROUPS}" ITKCommonB CommonB "ITKCommonA;VXLNumerics" "" "ITKCommon"
  "${MASTER_INDEX_FILES}" "${WrapITK_SOURCE_DIR}" "${WrapITK_BINARY_DIR}")

#------------------------------------------------------------------------------
WRITE_LANG_END()

#------------------------------------------------------------------------------
