# auto include feature must be disable because all the following classes are in the same file
SET(WRAPPER_AUTO_INCLUDE_HEADERS OFF)
WRAP_INCLUDE("itkSparseFieldFourthOrderLevelSetImageFilter.h")

WRAP_CLASS("itk::NormalBandNode" DEREF)
  WRAP_REAL(1)
END_WRAP_CLASS()

WRAP_CLASS("itk::Image" POINTER)
  FOREACH(d ${WRAP_DIMS})
    COND_WRAP("NBN${ITKM_IF${d}}${d}" " itk::NormalBandNode< ${ITKT_IF${d}} >*, ${d} " "F")
    COND_WRAP("NBN${ITKM_ID${d}}${d}" " itk::NormalBandNode< ${ITKT_ID${d}} >*, ${d} " "D")
  ENDFOREACH(d)
END_WRAP_CLASS()

WRAP_CLASS("itk::SparseFieldFourthOrderLevelSetImageFilter" POINTER)
  # WRAP_INT(2)
  # WRAP_SIGN_INT(2)
  WRAP_REAL(2)
END_WRAP_CLASS()
