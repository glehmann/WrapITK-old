# auto include feature must be disable because all the following classes are in the same file
SET(itk_AutoInclude OFF)
WRAP_INCLUDE(SparseFieldFourthOrderLevelSetImageFilter)

WRAP_CLASS("NormalBandNode" DEREF)
  WRAP_REAL(1)
END_WRAP_CLASS()

WRAP_CLASS("Image" POINTER)
  COND_WRAP("NBN${ITKM_IF2}2" " itk::NormalBandNode< ${ITKT_IF2} >*, 2 " "F")
  COND_WRAP("NBN${ITKM_IF3}3" " itk::NormalBandNode< ${ITKT_IF3} >*, 3 " "F")
  COND_WRAP("NBN${ITKM_ID2}2" " itk::NormalBandNode< ${ITKT_ID2} >*, 2 " "D")
  COND_WRAP("NBN${ITKM_ID3}3" " itk::NormalBandNode< ${ITKT_ID3} >*, 3 " "D")
END_WRAP_CLASS()

WRAP_CLASS("SparseFieldFourthOrderLevelSetImageFilter" POINTER)
  # WRAP_INT(2)
  # WRAP_SIGN_INT(2)
  WRAP_REAL(2)
END_WRAP_CLASS()
