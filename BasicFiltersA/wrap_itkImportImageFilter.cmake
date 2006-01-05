WRAP_CLASS("ImportImageFilter" POINTER)

  COND_WRAP("${ITKM_D}2"  "${ITKT_D},2"  "D" )
  COND_WRAP("${ITKM_F}2"  "${ITKT_F},2"  "F" )
  COND_WRAP("${ITKM_UL}2" "${ITKT_UL},2" "UL")
  COND_WRAP("${ITKM_US}2" "${ITKT_US},2" "US")
  COND_WRAP("${ITKM_UC}2" "${ITKT_UC},2" "UC")
  COND_WRAP("${ITKM_SL}2" "${ITKT_SL},2" "SL")
  COND_WRAP("${ITKM_SS}2" "${ITKT_SS},2" "SS")
  COND_WRAP("${ITKM_SC}2" "${ITKT_SC},2" "SC")
  
  COND_WRAP("${ITKM_D}3"  "${ITKT_D},3"  "D" )
  COND_WRAP("${ITKM_F}3"  "${ITKT_F},3"  "F" )
  COND_WRAP("${ITKM_UL}3" "${ITKT_UL},3" "UL")
  COND_WRAP("${ITKM_US}3" "${ITKT_US},3" "US")
  COND_WRAP("${ITKM_UC}3" "${ITKT_UC},3" "UC")
  COND_WRAP("${ITKM_SL}3" "${ITKT_SL},3" "SL")
  COND_WRAP("${ITKM_SS}3" "${ITKT_SS},3" "SS")
  COND_WRAP("${ITKM_SC}3" "${ITKT_SC},3" "SC")

END_WRAP_CLASS()

