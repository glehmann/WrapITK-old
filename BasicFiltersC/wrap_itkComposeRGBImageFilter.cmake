WRAP_CLASS("ComposeRGBImageFilter" POINTER_WITH_SUPERCLASS)
  FOREACH(d ${WRAP_DIMS})
    COND_WRAP("${ITKM_IUS${d}}${ITKM_IRGBUS${d}}" "${ITKT_IUS${d}},${ITKT_IRGBUS${d}}" "US;RGBUS")
    COND_WRAP("${ITKM_IUC${d}}${ITKM_IRGBUC${d}}" "${ITKT_IUC${d}},${ITKT_IRGBUC${d}}" "UC;RGBUC")
  ENDFOREACH(d)
END_WRAP_CLASS()