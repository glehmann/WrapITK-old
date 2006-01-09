WRAP_CLASS_NOTPL("TransformBase" POINTER)

WRAP_CLASS("Transform" POINTER)
  FOREACH(d ${WRAP_DIMS})
    WRAP("${ITKM_D}${d}${d}" "${ITKT_D},${d},${d}")
  ENDFOREACH(d)
END_WRAP_CLASS()
