WRAP_CLASS("itk::ShapeDetectionLevelSetImageFilter" POINTER)

# cableswig segfaults while processing this wrapper

#   FOREACH(d ${WRAP_ITK_DIMS})
#     FOREACH(t ${WRAP_ITK_REAL})
#       WRAP_TEMPLATE("${ITKM_I${t}${d}}${ITKM_I${t}${d}}${ITKM_${t}}" "${ITKT_I${t}${d}},${ITKT_I${t}${d}},${ITKT_${t}}")
#     ENDFOREACH(t)
#   ENDFOREACH(d)

END_WRAP_CLASS()
