WRAP_CLASS("itk::SpatialObject" POINTER)
  FOREACH(d ${WRAP_ITK_DIMS})
    WRAP_TEMPLATE("${d}" "${d}")
  ENDFOREACH(d)
END_WRAP_CLASS()
