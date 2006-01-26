WRAP_CLASS("itk::ImportImageFilter" POINTER)

  FOREACH(d ${WRAP_DIMS})
    COND_WRAP("${ITKM_D}${d}"  "${ITKT_D},${d}"  "D" )
    COND_WRAP("${ITKM_F}${d}"  "${ITKT_F},${d}"  "F" )
    COND_WRAP("${ITKM_UL}${d}" "${ITKT_UL},${d}" "UL")
    COND_WRAP("${ITKM_US}${d}" "${ITKT_US},${d}" "US")
    COND_WRAP("${ITKM_UC}${d}" "${ITKT_UC},${d}" "UC")
    COND_WRAP("${ITKM_SL}${d}" "${ITKT_SL},${d}" "SL")
    COND_WRAP("${ITKM_SS}${d}" "${ITKT_SS},${d}" "SS")
    COND_WRAP("${ITKM_SC}${d}" "${ITKT_SC},${d}" "SC")
  ENDFOREACH(d)

END_WRAP_CLASS()

