
WRAP_CLASS("itk::CastImageFilter" POINTER_WITH_SUPERCLASS)
  # Force that cast-to-uchar filters are created for all scalar types. If
  # 'UC' is already selected, don't worry about double-wrapping. WRAP_IMAGE_FILTER_COMBINATIONS
  # will uniquify the list.
  WRAP_IMAGE_FILTER_COMBINATIONS("${WRAP_ITK_SCALAR}" "${WRAP_ITK_SCALAR};UC")
END_WRAP_CLASS()

