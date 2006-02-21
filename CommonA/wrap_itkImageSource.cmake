WRAP_CLASS("itk::ImageSource" POINTER)

  FOREACH(d ${WRAP_ITK_DIMS})
    WRAP_TYPES("${ITKM_IUC${d}}" "${ITKT_IUC${d}}" "")  # neded to save in 8 bits
    WRAP_TYPES("${ITKM_IUS${d}}" "${ITKT_IUS${d}}" "US")
    WRAP_TYPES("${ITKM_IUL${d}}" "${ITKT_IUL${d}}" "") # needed to save in 8 bits
  ENDFOREACH(d)

  WRAP_SIGN_INT(1)
  WRAP_REAL(1)
  WRAP_VECTOR_REAL(1)
  WRAP_COV_VECTOR_REAL(1)
  WRAP_RGB(1)

END_WRAP_CLASS()
