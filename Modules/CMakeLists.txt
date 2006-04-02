# ITK_KITS must be in proper order -- modules that depend on other modules
# must come later in the list.

# SET(ITK_KITS VXLNumerics CommonA CommonB Numerics 
#   BasicFiltersA BasicFiltersB BasicFiltersC IO
#   SpatialObject Algorithms)

SET(modules
  VXLNumerics
  ITKCommonA
)

FOREACH(module 
  ITKCommonB
  ITKNumerics
  ITKBasicFiltersA
  ITKBasicFiltersB
  ITKBasicFiltersC
  ITKIO
  ITKSpatialObject
  ITKAlgorithms
#   ITKPatented
)
  OPTION(WRAP_${module} "Build ${module} module." ON)
  MARK_AS_ADVANCED(WRAP_${module})
  IF(WRAP_${module})
    SET(modules ${modules} ${module})
  ENDIF(WRAP_${module})
ENDFOREACH(module)

SET(WRAP_ITK_MODULES ${modules} CACHE INTERNAL "" FORCE)

SUBDIRS(${WRAP_ITK_MODULES})

