WRAP_CLASS("itk::CastImageFilter" POINTER_WITH_SUPERCLASS)
  # Create cast filters between all scalar types. Also force that cast-to-uchar
  # filters are created for all scalar types.
  UNIQUE(to_types "${WRAP_ITK_SCALAR};UC")
  WRAP_IMAGE_FILTER_COMBINATIONS("${WRAP_ITK_SCALAR}" "${to_types}")
END_WRAP_CLASS()

