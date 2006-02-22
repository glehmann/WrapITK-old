WRAP_CLASS("itk::NarrowBandThresholdSegmentationLevelSetImageFilter" POINTER)

  # WRAP_INT(2)
  # WRAP_SIGN_INT(2)
  # WRAP_REAL(2)
  
  FOREACH(d ${WRAP_ITK_DIMS})
    WRAP_TEMPLATE_IF_TYPES("${ITKM_IF${d}}${ITKM_IF${d}}${ITKM_F}" "${ITKT_IF${d}},${ITKT_IF${d}},${ITKT_F}" "F")
    WRAP_TEMPLATE_IF_TYPES("${ITKM_ID${d}}${ITKM_ID${d}}${ITKM_D}" "${ITKT_ID${d}},${ITKT_ID${d}},${ITKT_D}" "D")
  ENDFOREACH(d)

END_WRAP_CLASS()
