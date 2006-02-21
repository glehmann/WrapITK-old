WRAP_CLASS("itk::ImageFileReader" POINTER)

  FOREACH(d ${WRAP_ITK_DIMS})
    COND_WRAP("${ITKM_IUC${d}}" "${ITKT_IUC${d}}" "")  # neded to save in 8 bits
    COND_WRAP("${ITKM_IUS${d}}" "${ITKT_IUS${d}}" "US")
    COND_WRAP("${ITKM_IUL${d}}" "${ITKT_IUL${d}}" "UL")
  ENDFOREACH(d)

  WRAP_SIGN_INT(1)
  WRAP_REAL(1)
  WRAP_VECTOR_REAL(1)
  WRAP_COV_VECTOR_REAL(1)
  WRAP_RGB(1)

END_WRAP_CLASS()
