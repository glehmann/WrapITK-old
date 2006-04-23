SET(modules
  VXLNumerics
  Base
)

FOREACH(module 
  Base
  BinaryMorphology
  Calculators
  Compose
  Denoising
  DistanceMap
  EdgesAndContours
  FFT
  Filtering
  IntensityFilters
  Interpolators
  IO
  Iterators
  LevelSet
  Morphology
  Numerics
  #Patented
  PixelMath
  Registration
  Resize
  SegmentationAndThreshold
  SegmentationValidation
  SimpleFilters
  SpatialObject
  Transforms
  UnaryPixelMath)
  
  OPTION(WRAP_${module} "Build ${module} module." ON)
  MARK_AS_ADVANCED(WRAP_${module})
  IF(WRAP_${module})
    SET(modules ${modules} ${module})
  ENDIF(WRAP_${module})
ENDFOREACH(module)

SET(WRAP_ITK_MODULES ${modules} CACHE INTERNAL "" FORCE)

SUBDIRS(${WRAP_ITK_MODULES})

