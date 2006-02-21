WRAP_CLASS("itk::JoinSeriesImageFilter" POINTER)
  FOREACH(d1 ${WRAP_ITK_DIMS})
    FOREACH(d2 ${WRAP_ITK_DIMS})
      IF("${d1}" LESS "${d2}")
        COND_WRAP("${ITKM_ID${d1}}${ITKM_ID${d2}}"   "${ITKT_ID${d1}},${ITKT_ID${d2}}"   "D")
        COND_WRAP("${ITKM_IF${d1}}${ITKM_IF${d2}}"   "${ITKT_IF${d1}},${ITKT_IF${d2}}"   "F")
        COND_WRAP("${ITKM_IUL${d1}}${ITKM_IUL${d2}}" "${ITKT_IUL${d1}},${ITKT_IUL${d2}}" "UL")
        COND_WRAP("${ITKM_IUS${d1}}${ITKM_IUS${d2}}" "${ITKT_IUS${d1}},${ITKT_IUS${d2}}" "US")
        COND_WRAP("${ITKM_IUC${d1}}${ITKM_IUC${d2}}" "${ITKT_IUC${d1}},${ITKT_IUC${d2}}" "UC")
        COND_WRAP("${ITKM_ISL${d1}}${ITKM_ISL${d2}}" "${ITKT_ISL${d1}},${ITKT_ISL${d2}}" "SL")
        COND_WRAP("${ITKM_ISS${d1}}${ITKM_ISS${d2}}" "${ITKT_ISS${d1}},${ITKT_ISS${d2}}" "SS")
        COND_WRAP("${ITKM_ISC${d1}}${ITKM_ISC${d2}}" "${ITKT_ISC${d1}},${ITKT_ISC${d2}}" "SC")
      ENDIF("${d1}" LESS "${d2}")
    ENDFOREACH(d2)
  ENDFOREACH(d1)

END_WRAP_CLASS()

