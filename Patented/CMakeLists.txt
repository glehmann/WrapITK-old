SET(ITK_LIBRARY "ITKPatented")
STRING(TOLOWER ${ITK_LIBRARY} ITK_LIBRARY_LANG)
SET(ITK_LANG_FILE "${ITK_BINARY_DIR}/Wrapping/CSwig/Python/${ITK_LIBRARY_LANG}")
WRITE_LANG_BEGIN(${ITK_LIBRARY_LANG})

SET(WrapITK_PART_DIR "${WrapITK_BINARY_DIR}/Patented")

#------------------------------------------------------------------------------
# create a list of groups
# Add here modules that must be imported before the others.
SET(WRAP_GROUPS
  # nothing to add here for now
)

# include every wrap_*.cmake files in the directory
AUTO_INCLUDE_WRAP_CMAKE(WRAP_GROUPS "")

#------------------------------------------------------------------------------
# create the wrap_ITKBasicFilters*.cxx files
WRITE_MODULE("BasicFiltersA" "${WrapITK_PART_DIR}" "${WRAP_GROUPS}")

#------------------------------------------------------------------------------
# create the ITKBasicFilters libraries
SET(WRAP_SOURCES "")
FOREACH(file ${WRAP_GROUPS})
   SET(WRAP_SOURCES ${WRAP_SOURCES} wrap_${file})
ENDFOREACH(file ${WRAP_GROUPS})


SET(MASTER_INDEX_FILES "${WrapITK_BINARY_DIR}/VXLNumerics/VXLNumerics.mdx"
                       "${WrapITK_BINARY_DIR}/Numerics/ITKNumerics.mdx"
                       "${WrapITK_BINARY_DIR}/CommonA/ITKCommonA.mdx"
                       "${WrapITK_BINARY_DIR}/CommonB/ITKCommonB.mdx"
                       "${WrapITK_BINARY_DIR}/BasicFiltersA/ITKBasicFiltersA.mdx"
                       "${WrapITK_BINARY_DIR}/BasicFiltersB/ITKBasicFiltersB.mdx"
                       "${WrapITK_BINARY_DIR}/BasicFiltersC/ITKBasicFiltersC.mdx"
                       "${WrapITK_BINARY_DIR}/Algorithms/ITKAlgorithms.mdx"
                       "${WrapITK_BINARY_DIR}/Patented/ITKPatented.mdx"
)

ITK_WRAP_LIBRARY("${WRAP_SOURCES}" ITKPatented Patented 
  "ITKNumerics;ITKCommonA;ITKCommonB;ITKBasicFiltersA;ITKBasicFiltersB" "" ""
  "${MASTER_INDEX_FILES}" "${WrapITK_SOURCE_DIR}" "${WrapITK_BINARY_DIR}")
  
#------------------------------------------------------------------------------
WRITE_LANG_END()

#------------------------------------------------------------------------------
