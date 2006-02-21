WRAP_CLASS("itk::Neighborhood")
  FOREACH(d ${WRAP_ITK_DIMS})
    COND_WRAP("${ITKM_D}${d}"  "${ITKT_D},${d}"  "D")
    COND_WRAP("${ITKM_F}${d}"  "${ITKT_F},${d}"  "F")
    
    COND_WRAP("${ITKM_UL}${d}" "${ITKT_UL},${d}" "UL")
    COND_WRAP("${ITKM_US}${d}" "${ITKT_US},${d}" "US")
    COND_WRAP("${ITKM_UC}${d}" "${ITKT_UC},${d}" "UC")
    
    COND_WRAP("${ITKM_SL}${d}" "${ITKT_SL},${d}" "SL")
    COND_WRAP("${ITKM_SS}${d}" "${ITKT_SS},${d}" "SS")
    COND_WRAP("${ITKM_SC}${d}" "${ITKT_SC},${d}" "SC")
    
    COND_WRAP("${ITKM_VD${d}}${d}"  "${ITKT_VD${d}},${d}"  "VD")
    COND_WRAP("${ITKM_VF${d}}${d}"  "${ITKT_VF${d}},${d}"  "VF")
    
    COND_WRAP("${ITKM_CVD${d}}${d}"  "${ITKT_CVD${d}},${d}"  "CVD")
    COND_WRAP("${ITKM_CVF${d}}${d}"  "${ITKT_CVF${d}},${d}"  "CVF")
  ENDFOREACH(d)
END_WRAP_CLASS()
