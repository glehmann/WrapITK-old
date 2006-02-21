WRAP_INCLUDE("itkDefaultStaticMeshTraits.h")

WRAP_CLASS("itk::PointSet" POINTER)
  FOREACH(d ${WRAP_ITK_DIMS})
    WRAP("${ITKM_PD${d}}${d}" "${ITKT_PD${d}},${d},itk::DefaultStaticMeshTraits< ${ITKT_D},${d},${d},${ITKT_D},${ITKT_D},${ITKT_D} >")
  ENDFOREACH(d)
END_WRAP_CLASS()
