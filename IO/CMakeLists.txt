SET(ITK_LIBRARY "ITKIO")
STRING(TOLOWER ${ITK_LIBRARY} ITK_LIBRARY_LANG)
SET(ITK_LANG_FILE "${ITK_BINARY_DIR}/Wrapping/CSwig/Python/${ITK_LIBRARY_LANG}")
WRITE_LANG_BEGIN(${ITK_LIBRARY_LANG})

SET(WrapITK_PART_DIR "${WrapITK_BINARY_DIR}/IO")

#------------------------------------------------------------------------------
# create a list of groups
# IMPORTANT : order has consequences
SET(WRAP_GROUPS
)

# create a list of files for templating
SET(WRAP_CXX_EXTRA
  itkTkImageViewer2D
)

#-# include every wrap_*.cmake files in the directory
AUTO_INCLUDE_WRAP_CMAKE(WRAP_GROUPS "${WRAP_CXX_EXTRA}")

FOREACH(file ${WRAP_CXX_EXTRA})
   INCLUDE_WRAP_CMAKE(${file})
ENDFOREACH(file ${WRAP_CXX_SOURCES})

#------------------------------------------------------------------------------
# create the wrap_ITKIO*.cxx files
WRITE_MODULE_LANG("IO" "${WrapITK_PART_DIR}" "${WRAP_GROUPS}")


#------------------------------------------------------------------------------
# create the ITKIOTcl libraries

SET(MASTER_INDEX_FILES "${WrapITK_BINARY_DIR}/VXLNumerics/VXLNumerics.mdx"
                       "${WrapITK_BINARY_DIR}/Numerics/ITKNumerics.mdx"
                       "${WrapITK_BINARY_DIR}/CommonA/ITKCommonA.mdx"
                       "${WrapITK_BINARY_DIR}/CommonB/ITKCommonB.mdx"
                       "${WrapITK_BINARY_DIR}/BasicFiltersA/ITKBasicFiltersA.mdx"
                       "${WrapITK_BINARY_DIR}/BasicFiltersB/ITKBasicFiltersB.mdx"
                       "${WrapITK_BINARY_DIR}/IO/ITKIO.mdx"
)
SET(ITK_EXTRA_TCL_SOURCES itkTkImageViewer2D.cxx)
SET(ITK_EXTRA_TCL_WRAP wrap_itkTkImageViewer2D)
ITK_WRAP_LIBRARY("${WRAP_GROUPS}" ITKIO IO "ITKNumerics;ITKCommonA;ITKCommonB" "" ""
  "${MASTER_INDEX_FILES}" "${WrapITK_SOURCE_DIR}" "${WrapITK_BINARY_DIR}")

IF(ITK_CSWIG_TCL)
  TARGET_LINK_LIBRARIES(ITKIOTcl ${TK_LIBRARY})
ENDIF(ITK_CSWIG_TCL)

#------------------------------------------------------------------------------
WRITE_LANG_END()

#------------------------------------------------------------------------------
