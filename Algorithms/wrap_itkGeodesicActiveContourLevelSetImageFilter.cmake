WRAP_CLASS("itk::GeodesicActiveContourLevelSetImageFilter" POINTER)

  # WRAP_IMAGE_FILTER_INT(2)
  # WRAP_IMAGE_FILTER_SIGN_INT(2)
  # WRAP_IMAGE_FILTER_REAL(2)

  FOREACH(d ${WRAP_ITK_DIMS})
    IF("${d}" GREATER 1)
      WRAP_TEMPLATE_IF_TYPES("${ITKM_IF${d}}${ITKM_IF${d}}${ITKM_F}" "${ITKT_IF${d}},${ITKT_IF${d}},${ITKT_F}" "F")
      WRAP_TEMPLATE_IF_TYPES("${ITKM_ID${d}}${ITKM_ID${d}}${ITKM_D}" "${ITKT_ID${d}},${ITKT_ID${d}},${ITKT_D}" "D")
    ENDIF("${d}" GREATER 1)
  ENDFOREACH(d)

END_WRAP_CLASS()
