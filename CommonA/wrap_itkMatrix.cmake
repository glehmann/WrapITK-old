WRAP_CLASS("itk::Matrix" DEREF)
  WRAP("${ITKM_F}22" "${ITKT_F},2,2")
  WRAP("${ITKM_F}33" "${ITKT_F},3,3")
  WRAP("${ITKM_F}44" "${ITKT_F},4,4")
  
  WRAP("${ITKM_D}22" "${ITKT_D},2,2")
  WRAP("${ITKM_D}33" "${ITKT_D},3,3")
  WRAP("${ITKM_D}44" "${ITKT_D},4,4")
END_WRAP_CLASS()
