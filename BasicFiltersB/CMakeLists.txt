SET(ITK_LIBRARY "ITKBasicFiltersB")
STRING(TOLOWER ${ITK_LIBRARY} ITK_LIBRARY_LANG)
SET(ITK_LANG_FILE "${WrapITK_BINARY_DIR}/@MODULE_LANG@/${ITK_LIBRARY_LANG}")
WRITE_LANG_BEGIN("itkbasicfilters" "${ITK_LANG_FILE}")

SET(CXX_OUTPUT_DIR "${WrapITK_BINARY_DIR}/BasicFiltersB")

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
WRITE_MODULE("ITKBasicFiltersB" "${CXX_OUTPUT_DIR}" "${WRAP_GROUPS}")

#------------------------------------------------------------------------------
# create the ITKBasicFilters libraries

SET(MASTER_INDEX_FILES "${WrapITK_BINARY_DIR}/VXLNumerics/VXLNumerics.mdx"
  "${WrapITK_BINARY_DIR}/Numerics/ITKNumerics.mdx"
  "${WrapITK_BINARY_DIR}/CommonA/ITKCommonA.mdx"
  "${WrapITK_BINARY_DIR}/CommonB/ITKCommonB.mdx"
  "${WrapITK_BINARY_DIR}/BasicFiltersB/ITKBasicFiltersB.mdx"
  )

ITK_WRAP_LIBRARY("${WRAP_GROUPS}" ITKBasicFiltersB BasicFiltersB "ITKNumerics;ITKCommonB;ITKCommonA" "" "ITKBasicFilters;ITKStatistics;ITKIO"
  "${MASTER_INDEX_FILES}" "${WrapITK_SOURCE_DIR}" "${WrapITK_BINARY_DIR}")

#------------------------------------------------------------------------------
WRITE_LANG_END()

#------------------------------------------------------------------------------
