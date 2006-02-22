WRAP_CLASS("itk::ImportImageFilter" POINTER)

  FOREACH(d ${WRAP_ITK_DIMS})
    WRAP_TEMPLATE_IF_TYPES("${ITKM_D}${d}"  "${ITKT_D},${d}"  "D" )
    WRAP_TEMPLATE_IF_TYPES("${ITKM_F}${d}"  "${ITKT_F},${d}"  "F" )
    WRAP_TEMPLATE_IF_TYPES("${ITKM_UL}${d}" "${ITKT_UL},${d}" "UL")
    WRAP_TEMPLATE_IF_TYPES("${ITKM_US}${d}" "${ITKT_US},${d}" "US")
    WRAP_TEMPLATE_IF_TYPES("${ITKM_UC}${d}" "${ITKT_UC},${d}" "UC")
    WRAP_TEMPLATE_IF_TYPES("${ITKM_SL}${d}" "${ITKT_SL},${d}" "SL")
    WRAP_TEMPLATE_IF_TYPES("${ITKM_SS}${d}" "${ITKT_SS},${d}" "SS")
    WRAP_TEMPLATE_IF_TYPES("${ITKM_SC}${d}" "${ITKT_SC},${d}" "SC")
  ENDFOREACH(d)

END_WRAP_CLASS()

