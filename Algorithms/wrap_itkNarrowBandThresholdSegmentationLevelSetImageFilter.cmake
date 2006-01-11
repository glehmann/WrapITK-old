WRAP_CLASS("NarrowBandThresholdSegmentationLevelSetImageFilter" POINTER)

  # WRAP_INT(2)
  # WRAP_SIGN_INT(2)
  # WRAP_REAL(2)
  
  FOREACH(d ${WRAP_DIMS})
    COND_WRAP("${ITKM_IF${d}}${ITKM_IF${d}}${ITKM_F}" "${ITKT_IF${d}},${ITKT_IF${d}},${ITKT_F}" "F")
    COND_WRAP("${ITKM_ID${d}}${ITKM_ID${d}}${ITKM_D}" "${ITKT_ID${d}},${ITKT_ID${d}},${ITKT_D}" "D")
  ENDFOREACH(d)

END_WRAP_CLASS()
