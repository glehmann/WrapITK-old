WRAP_INCLUDE(DefaultStaticMeshTraits)

WRAP_CLASS(PointSet POINTER)
  WRAP("${ITKM_PD2}2" "${ITKT_PD2},2,itk::DefaultStaticMeshTraits< ${ITKT_D},2,2,${ITKT_D},${ITKT_D},${ITKT_D} >")
  WRAP("${ITKM_PD3}3" "${ITKT_PD3},3,itk::DefaultStaticMeshTraits< ${ITKT_D},3,3,${ITKT_D},${ITKT_D},${ITKT_D} >")
END_WRAP_CLASS()
