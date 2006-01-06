SET(ITK_LIBRARY "ITKBasicFiltersA")
STRING(TOLOWER ${ITK_LIBRARY} ITK_LIBRARY_LANG)
SET(ITK_LANG_FILE "${WrapITK_BINARY_DIR}/Python/${ITK_LIBRARY_LANG}")
WRITE_LANG_BEGIN("itkbasicfilters")

SET(WrapITK_PART_DIR "${WrapITK_BINARY_DIR}/BasicFiltersA")

#------------------------------------------------------------------------------
# create a list of groups
# Add here modules that must be imported before the others.
SET(WRAP_GROUPS
  # nothing to add here for now
)

# include every wrap_*.cmake files in the directory
# and populate WRAP_GROUPS
AUTO_INCLUDE_WRAP_CMAKE(WRAP_GROUPS "")

#------------------------------------------------------------------------------
# create the wrap_ITKBasicFilters*.cxx files
WRITE_MODULE("BasicFiltersA" "${WrapITK_PART_DIR}" "${WRAP_GROUPS}")

#------------------------------------------------------------------------------
# create the ITKBasicFilters libraries

SET(MASTER_INDEX_FILES "${WrapITK_BINARY_DIR}/VXLNumerics/VXLNumerics.mdx"
  "${WrapITK_BINARY_DIR}/Numerics/ITKNumerics.mdx"
  "${WrapITK_BINARY_DIR}/CommonA/ITKCommonA.mdx"
  "${WrapITK_BINARY_DIR}/CommonB/ITKCommonB.mdx"
  "${WrapITK_BINARY_DIR}/BasicFiltersA/ITKBasicFiltersA.mdx"
)

ITK_WRAP_LIBRARY(
  "${WRAP_GROUPS}" 
  ITKBasicFiltersA
  BasicFiltersA
  "ITKNumerics;ITKCommonB;ITKCommonA"
  ""
  "ITKBasicFilters"
  "${MASTER_INDEX_FILES}"
  "${WrapITK_SOURCE_DIR}"
  "${WrapITK_BINARY_DIR}"
)

#------------------------------------------------------------------------------
WRITE_LANG_END()

