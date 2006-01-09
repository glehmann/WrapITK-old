WRAP_CLASS("RelabelComponentImageFilter" POINTER)
  WRAP_INT(2)
  WRAP_SIGN_INT(2)
  # needed with watershed filter to return to a non UL type

  FOREACH(d ${WRAP_DIMS})
    COND_WRAP("${ITKM_IUL${d}}${ITKM_IUS${d}}" "${ITKT_IUL${d}},${ITKT_IUS${d}}" "US")
    COND_WRAP("${ITKM_IUL${d}}${ITKM_IUC${d}}" "${ITKT_IUL${d}},${ITKT_IUC${d}}" "UC")
    COND_WRAP("${ITKM_IUL${d}}${ITKM_ISL${d}}" "${ITKT_IUL${d}},${ITKT_ISL${d}}" "SL")
    COND_WRAP("${ITKM_IUL${d}}${ITKM_ISS${d}}" "${ITKT_IUL${d}},${ITKT_ISS${d}}" "SS")
    COND_WRAP("${ITKM_IUL${d}}${ITKM_ISC${d}}" "${ITKT_IUL${d}},${ITKT_ISC${d}}" "SC")
    
    COND_WRAP("${ITKM_IUS${d}}${ITKM_IUC${d}}" "${ITKT_IUS${d}},${ITKT_IUC${d}}" "US;UC")
    COND_WRAP("${ITKM_IUS${d}}${ITKM_ISC${d}}" "${ITKT_IUS${d}},${ITKT_ISC${d}}" "US;SC")
    
    COND_WRAP("${ITKM_ISL${d}}${ITKM_IUS${d}}" "${ITKT_ISL${d}},${ITKT_IUS${d}}" "SL;US")
    COND_WRAP("${ITKM_ISL${d}}${ITKM_IUC${d}}" "${ITKT_ISL${d}},${ITKT_IUC${d}}" "SL;UC")
    COND_WRAP("${ITKM_ISL${d}}${ITKM_ISS${d}}" "${ITKT_ISL${d}},${ITKT_ISS${d}}" "SL;SS")
    COND_WRAP("${ITKM_ISL${d}}${ITKM_ISC${d}}" "${ITKT_ISL${d}},${ITKT_ISC${d}}" "SL;SC")
    
    COND_WRAP("${ITKM_ISS${d}}${ITKM_IUC${d}}" "${ITKT_ISS${d}},${ITKT_IUC${d}}" "SS;UC")
    COND_WRAP("${ITKM_ISS${d}}${ITKM_ISC${d}}" "${ITKT_ISS${d}},${ITKT_ISC${d}}" "SS;SC")
  ENDFOREACH(d)

END_WRAP_CLASS()
