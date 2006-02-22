WRAP_CLASS("itk::DoubleThresholdImageFilter" POINTER)
  WRAP_INT(2)
  WRAP_SIGN_INT(2)
  WRAP_REAL(2)
  
  FOREACH(d ${WRAP_ITK_DIMS})
    WRAP_TEMPLATE_IF_TYPES("${ITKM_IF${d}}${ITKM_IUS${d}}" "${ITKT_IF${d}},${ITKT_IUS${d}}" "F;US")
    WRAP_TEMPLATE_IF_TYPES("${ITKM_IF${d}}${ITKM_IUC${d}}" "${ITKT_IF${d}},${ITKT_IUC${d}}" "F;UC")
    WRAP_TEMPLATE_IF_TYPES("${ITKM_ID${d}}${ITKM_IUS${d}}" "${ITKT_ID${d}},${ITKT_IUS${d}}" "D;US")
    WRAP_TEMPLATE_IF_TYPES("${ITKM_ID${d}}${ITKM_IUC${d}}" "${ITKT_ID${d}},${ITKT_IUC${d}}" "D;UC")
  ENDFOREACH(d)

END_WRAP_CLASS()
