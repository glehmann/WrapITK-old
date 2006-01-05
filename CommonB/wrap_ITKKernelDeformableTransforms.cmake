WRAP_CLASS("KernelTransform" POINTER)
  WRAP("${ITKM_D}2" "${ITKT_D},2")
  WRAP("${ITKM_D}3" "${ITKT_D},3")
END_WRAP_CLASS()

WRAP_CLASS("ElasticBodyReciprocalSplineKernelTransform" POINTER)
  WRAP("${ITKM_D}2" "${ITKT_D},2")
  WRAP("${ITKM_D}3" "${ITKT_D},3")
END_WRAP_CLASS()

WRAP_CLASS("ElasticBodySplineKernelTransform" POINTER)
  WRAP("${ITKM_D}2" "${ITKT_D},2")
  WRAP("${ITKM_D}3" "${ITKT_D},3")
END_WRAP_CLASS()

WRAP_CLASS("ThinPlateR2LogRSplineKernelTransform" POINTER)
  WRAP("${ITKM_D}2" "${ITKT_D},2")
  WRAP("${ITKM_D}3" "${ITKT_D},3")
END_WRAP_CLASS()

WRAP_CLASS("ThinPlateSplineKernelTransform" POINTER)
  WRAP("${ITKM_D}2" "${ITKT_D},2")
  WRAP("${ITKM_D}3" "${ITKT_D},3")
END_WRAP_CLASS()

WRAP_CLASS("VolumeSplineKernelTransform" POINTER)
  WRAP("${ITKM_D}2" "${ITKT_D},2")
  WRAP("${ITKM_D}3" "${ITKT_D},3")
END_WRAP_CLASS()
