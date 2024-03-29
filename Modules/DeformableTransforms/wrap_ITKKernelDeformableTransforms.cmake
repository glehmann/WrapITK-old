WRAP_CLASS("itk::KernelTransform" POINTER)
  FOREACH(d ${WRAP_ITK_DIMS})
    WRAP_TEMPLATE("${ITKM_D}${d}" "${ITKT_D},${d}")
  ENDFOREACH(d)
END_WRAP_CLASS()

WRAP_CLASS("itk::ElasticBodyReciprocalSplineKernelTransform" POINTER)
  FOREACH(d ${WRAP_ITK_DIMS})
    WRAP_TEMPLATE("${ITKM_D}${d}" "${ITKT_D},${d}")
  ENDFOREACH(d)
END_WRAP_CLASS()

WRAP_CLASS("itk::ElasticBodySplineKernelTransform" POINTER)
  FOREACH(d ${WRAP_ITK_DIMS})
    WRAP_TEMPLATE("${ITKM_D}${d}" "${ITKT_D},${d}")
  ENDFOREACH(d)
END_WRAP_CLASS()

WRAP_CLASS("itk::ThinPlateR2LogRSplineKernelTransform" POINTER)
  FOREACH(d ${WRAP_ITK_DIMS})
    WRAP_TEMPLATE("${ITKM_D}${d}" "${ITKT_D},${d}")
  ENDFOREACH(d)
END_WRAP_CLASS()

WRAP_CLASS("itk::ThinPlateSplineKernelTransform" POINTER)
  FOREACH(d ${WRAP_ITK_DIMS})
    WRAP_TEMPLATE("${ITKM_D}${d}" "${ITKT_D},${d}")
  ENDFOREACH(d)
END_WRAP_CLASS()

WRAP_CLASS("itk::VolumeSplineKernelTransform" POINTER)
  FOREACH(d ${WRAP_ITK_DIMS})
    WRAP_TEMPLATE("${ITKM_D}${d}" "${ITKT_D},${d}")
  ENDFOREACH(d)
END_WRAP_CLASS()
