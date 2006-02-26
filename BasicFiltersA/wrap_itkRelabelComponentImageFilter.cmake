WRAP_CLASS("itk::RelabelComponentImageFilter" POINTER)
  WRAP_IMAGE_FILTER_INT(2)
  WRAP_IMAGE_FILTER_SIGN_INT(2)
  
  # Wrap the filter from long/short integral types to smaller integral types.
  # We force the ulong type to allow watershed filter to return to a non ulong types.
  # If a SMALLER_THAN list (defined in WrapBasicTypes.cmake) is empty or nonexistant,
  # WRAP_IMAGE_FILTER_COMBINATIONS will just ignore that.

  UNIQUE(from_types "UL;${WRAP_ITK_INTEGRAL}")
  FOREACH(t ${from_types})
    WRAP_IMAGE_FILTER_COMBINATIONS("${t}" "${SMALLER_THAN_${t}}")
  ENDFOREACH(t)
END_WRAP_CLASS()
