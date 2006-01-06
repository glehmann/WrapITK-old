SET(ITK_LIBRARY "ITKSpatialObject")
STRING(TOLOWER ${ITK_LIBRARY} ITK_LIBRARY_LANG)
SET(ITK_LANG_FILE "${WrapITK_BINARY_DIR}/Python/${ITK_LIBRARY_LANG}")
WRITE_LANG_BEGIN(${ITK_LIBRARY_LANG})

SET(WrapITK_PART_DIR "${WrapITK_BINARY_DIR}/SpatialObject")

#------------------------------------------------------------------------------
# create a list of groups
# Add here modules that must be imported before the others.
SET(WRAP_GROUPS
#  itkSpatialObject
)

# include every wrap_*.cmake files in the directory
AUTO_INCLUDE_WRAP_CMAKE(WRAP_GROUPS "")

#------------------------------------------------------------------------------
# create the wrap_ITKBasicFilters*.cxx files
WRITE_MODULE("SpatialObject" "${WrapITK_PART_DIR}" "${WRAP_GROUPS}")

#------------------------------------------------------------------------------
# create the ITKBasicFilters libraries

SET(MASTER_INDEX_FILES "${WrapITK_BINARY_DIR}/VXLNumerics/VXLNumerics.mdx"
                       "${WrapITK_BINARY_DIR}/Numerics/ITKNumerics.mdx"
                       "${WrapITK_BINARY_DIR}/CommonA/ITKCommonA.mdx"
                       "${WrapITK_BINARY_DIR}/CommonB/ITKCommonB.mdx"
                       "${WrapITK_BINARY_DIR}/SpatialObject/ITKSpatialObject.mdx"
)

ITK_WRAP_LIBRARY("${WRAP_GROUPS}" ITKSpatialObject SpatialObject
  "ITKNumerics;ITKCommonB;ITKCommonA" "" ""
  "${MASTER_INDEX_FILES}" "${WrapITK_SOURCE_DIR}" "${WrapITK_BINARY_DIR}")
  
#------------------------------------------------------------------------------
WRITE_LANG_END()

#------------------------------------------------------------------------------
