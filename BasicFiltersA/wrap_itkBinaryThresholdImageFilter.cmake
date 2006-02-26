WRAP_CLASS("itk::BinaryThresholdImageFilter" POINTER_WITH_SUPERCLASS)    
  # For all the selected scalar types:
  FOREACH(type ${WRAP_ITK_SCALAR})
    
    # Wrap from that type to itself
    WRAP_IMAGE_FILTER_TYPES(${type} ${type})
    
    # And wrap from that type to all "smaller" types that are selected.
    # The SMALLER_THAN lists are defined in WrapBasicTypes.cmake. If the list
    # is empty/nonexistant (e.g. in the case of uchar, then WRAP_IMAGE_FILTER_COMBINATIONS
    # will just ignore that.
    WRAP_IMAGE_FILTER_COMBINATIONS("${type}" "${SMALLER_THAN_${type}}")
  ENDFOREACH(type)
END_WRAP_CLASS()
