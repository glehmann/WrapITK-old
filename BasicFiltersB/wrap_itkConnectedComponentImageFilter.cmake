WRAP_CLASS("itk::ConnectedComponentImageFilter" POINTER)
  FOREACH(d ${WRAP_ITK_DIMS})
    COND_WRAP("${ITKM_IUL${d}}${ITKM_IUL${d}}" "${ITKT_IUL${d}},${ITKT_IUL${d}}" "UL")
    
    COND_WRAP("${ITKM_IUS${d}}${ITKM_IUL${d}}" "${ITKT_IUS${d}},${ITKT_IUL${d}}" "US") # needed for watershed
    COND_WRAP("${ITKM_IUS${d}}${ITKM_IUS${d}}" "${ITKT_IUS${d}},${ITKT_IUS${d}}" "US")
    COND_WRAP("${ITKM_IUS${d}}${ITKM_ISL${d}}" "${ITKT_IUS${d}},${ITKT_ISL${d}}" "US;SL")
    
    COND_WRAP("${ITKM_IUC${d}}${ITKM_IUL${d}}" "${ITKT_IUC${d}},${ITKT_IUL${d}}" "UC") # needed for watershed
    COND_WRAP("${ITKM_IUC${d}}${ITKM_IUS${d}}" "${ITKT_IUC${d}},${ITKT_IUS${d}}" "UC;US")
    COND_WRAP("${ITKM_IUC${d}}${ITKM_IUC${d}}" "${ITKT_IUC${d}},${ITKT_IUC${d}}" "UC")
    COND_WRAP("${ITKM_IUC${d}}${ITKM_ISL${d}}" "${ITKT_IUC${d}},${ITKT_ISL${d}}" "UC;SL")
    COND_WRAP("${ITKM_IUC${d}}${ITKM_ISS${d}}" "${ITKT_IUC${d}},${ITKT_ISS${d}}" "UC;SS")
    
    COND_WRAP("${ITKM_ISL${d}}${ITKM_IUL${d}}" "${ITKT_ISL${d}},${ITKT_IUL${d}}" "SL") # needed for watershed
    COND_WRAP("${ITKM_ISL${d}}${ITKM_ISL${d}}" "${ITKT_ISL${d}},${ITKT_ISL${d}}" "SL")
    
    COND_WRAP("${ITKM_ISS${d}}${ITKM_IUL${d}}" "${ITKT_ISS${d}},${ITKT_IUL${d}}" "SS") # needed for watershed
    COND_WRAP("${ITKM_ISS${d}}${ITKM_IUS${d}}" "${ITKT_ISS${d}},${ITKT_IUS${d}}" "SS;US")
    COND_WRAP("${ITKM_ISS${d}}${ITKM_ISL${d}}" "${ITKT_ISS${d}},${ITKT_ISL${d}}" "SS;SL")
    COND_WRAP("${ITKM_ISS${d}}${ITKM_ISS${d}}" "${ITKT_ISS${d}},${ITKT_ISS${d}}" "SS")
    
    COND_WRAP("${ITKM_ISC${d}}${ITKM_IUL${d}}" "${ITKT_ISC${d}},${ITKT_IUL${d}}" "SC") # needed for watershed
    COND_WRAP("${ITKM_ISC${d}}${ITKM_IUS${d}}" "${ITKT_ISC${d}},${ITKT_IUS${d}}" "SC;US")
    COND_WRAP("${ITKM_ISC${d}}${ITKM_IUC${d}}" "${ITKT_ISC${d}},${ITKT_IUC${d}}" "SC;UC")
    COND_WRAP("${ITKM_ISC${d}}${ITKM_ISL${d}}" "${ITKT_ISC${d}},${ITKT_ISL${d}}" "SC;SL")
    COND_WRAP("${ITKM_ISC${d}}${ITKM_ISS${d}}" "${ITKT_ISC${d}},${ITKT_ISS${d}}" "SC;SS")
    COND_WRAP("${ITKM_ISC${d}}${ITKM_ISC${d}}" "${ITKT_ISC${d}},${ITKT_ISC${d}}" "SC")
  ENDFOREACH(d)
END_WRAP_CLASS()
