WRAP_CLASS("itk::InPlaceImageFilter" POINTER)
  # Wrap from each scalar type to each other, and also to uchar (for 8-bit saving)
  UNIQUE(to_types "UC;${WRAP_ITK_SCALAR}")
  WRAP_IMAGE_FILTER_COMBINATIONS("${WRAP_ITK_SCALAR}" "${to_types}")
  
  # Wrap from ulong to other integral types, even if ulong isn't wrapped. This
  # is needed for the relabel components image filter.
  # TODO: is it really?
  IF(NOT WRAP_unsigned_long)
    WRAP_IMAGE_FILTER_COMBINATIONS("UL" "${WRAP_ITK_INTEGRAL}")
  ENDIF(NOT WRAP_unsigned_long)
  
  # Vector types
  WRAP_IMAGE_FILTER_VECTOR_REAL(2)
  WRAP_IMAGE_FILTER_COV_VECTOR_REAL(2)
  
  # RGB types
  WRAP_IMAGE_FILTER_RGB(2)
 
  # int <-> RGB
  IF(WRAP_rgb_unsigned_char AND WRAP_unsigned_char)
    WRAP_IMAGE_FILTER_TYPES(RGBUC UC)
    WRAP_IMAGE_FILTER_TYPES(UC RGBUC)
  ENDIF(WRAP_rgb_unsigned_char AND WRAP_unsigned_char)

  IF(WRAP_rgb_unsigned_short AND WRAP_unsigned_short)
    WRAP_IMAGE_FILTER_TYPES(RGBUS US)
    WRAP_IMAGE_FILTER_TYPES(US RGBUS)
  ENDIF(WRAP_rgb_unsigned_short AND WRAP_unsigned_short)

END_WRAP_CLASS()
