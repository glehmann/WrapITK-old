# auto include feature must be disable because all the following classes are in the same file
SET(itk_AutoInclude OFF)
WRAP_INCLUDE(SparseFieldFourthOrderLevelSetImageFilter)

WRAP_CLASS("NormalBandNode" DEREF)
  WRAP_REAL(1)
END_WRAP_CLASS()

WRAP_CLASS("Image" POINTER)
  FOREACH(d ${WRAP_DIMS})
    COND_WRAP("NBN${ITKM_IF${d}}${d}" " itk::NormalBandNode< ${ITKT_IF${d}} >*, ${d} " "F")
    COND_WRAP("NBN${ITKM_ID${d}}${d}" " itk::NormalBandNode< ${ITKT_ID${d}} >*, ${d} " "D")
  ENDFOREACH(d)
END_WRAP_CLASS()

WRAP_CLASS("SparseFieldFourthOrderLevelSetImageFilter" POINTER)
  # WRAP_INT(2)
  # WRAP_SIGN_INT(2)
  WRAP_REAL(2)
END_WRAP_CLASS()
