WRAP_CLASS("itk::DefaultDynamicMeshTraits")
  FOREACH(d ${WRAP_ITK_DIMS})
    WRAP_TEMPLATE("${ITKM_D}${d}${d}${ITKM_D}" "${ITKT_D},${d},${d},${ITKT_D}")
  ENDFOREACH(d)  

#  FOREACH(d ${WRAP_ITK_DIMS})
#    WRAP_TEMPLATE("${ITKM_PD${d}}${d}${d}${ITKM_D}${ITKM_D}${ITKM_PD${d}}" "${ITKT_PD${d}},${d},${d},${ITKT_D},${ITKT_D},${ITKT_PD${d}}")
#  ENDFOREACH(d)  

END_WRAP_CLASS()
