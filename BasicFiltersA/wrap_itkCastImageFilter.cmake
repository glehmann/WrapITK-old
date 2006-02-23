
# to force the UC type in the output types
UNIQUE("${WRAP_ITK_SCALAR};UC" to_types)

WRAP_CLASS("itk::CastImageFilter" POINTER_WITH_SUPERCLASS)
  WRAP_IMAGE_FILTER_TYPES2("${WRAP_ITK_SCALAR}" "${to_types}")
END_WRAP_CLASS()

