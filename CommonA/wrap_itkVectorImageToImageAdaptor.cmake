WRAP_CLASS("itk::VectorImageToImageAdaptor" POINTER_WITH_SUPERCLASS)
#   UNIQUE(to_types "${WRAP_ITK_SCALAR};UC")
#   
#   FOREACH(d ${WRAP_ITK_DIMS})
#     FOREACH(type ${to_types})
#       WRAP_TEMPLATE("${ITKM_${type}}${d}"  "${ITKT_${type}},${d}")
#     ENDFOREACH(type)
#   ENDFOREACH(d)
END_WRAP_CLASS()
