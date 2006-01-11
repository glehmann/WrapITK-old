WRAP_CLASS("DoubleThresholdImageFilter" POINTER)
  WRAP_INT(2)
  WRAP_SIGN_INT(2)
  WRAP_REAL(2)
  
  FOREACH(d ${WRAP_DIMS})
    COND_WRAP("${ITKM_IF${d}}${ITKM_IUS${d}}" "${ITKT_IF${d}},${ITKT_IUS${d}}" "F;US")
    COND_WRAP("${ITKM_IF${d}}${ITKM_IUC${d}}" "${ITKT_IF${d}},${ITKT_IUC${d}}" "F;UC")
    COND_WRAP("${ITKM_ID${d}}${ITKM_IUS${d}}" "${ITKT_ID${d}},${ITKT_IUS${d}}" "D;US")
    COND_WRAP("${ITKM_ID${d}}${ITKM_IUC${d}}" "${ITKT_ID${d}},${ITKT_IUC${d}}" "D;UC")
  ENDFOREACH(d)

END_WRAP_CLASS()