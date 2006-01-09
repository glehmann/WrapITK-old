WRAP_INCLUDE(DefaultStaticMeshTraits)

WRAP_CLASS(PointSet POINTER)
  FOREACH(d ${WRAP_DIMS})
    WRAP("${ITKM_PD${d}}${d}" "${ITKT_PD${d}},${d},itk::DefaultStaticMeshTraits< ${ITKT_D},${d},${d},${ITKT_D},${ITKT_D},${ITKT_D} >")
  ENDFOREACH(d)
END_WRAP_CLASS()
