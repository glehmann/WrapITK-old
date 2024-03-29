FILTER_DIMS(d2 2)
IF(d2)
  WRAP_CLASS("itk::CenteredRigid2DTransform" POINTER)
    WRAP_TEMPLATE("${ITKM_D}" "${ITKT_D}")
  END_WRAP_CLASS()
  
  WRAP_CLASS("itk::Euler2DTransform" POINTER)
    WRAP_TEMPLATE("${ITKM_D}" "${ITKT_D}")
  END_WRAP_CLASS()
  
  WRAP_CLASS("itk::Rigid2DTransform" POINTER)
    WRAP_TEMPLATE("${ITKM_D}" "${ITKT_D}")
  END_WRAP_CLASS()
ENDIF(d2)



FILTER_DIMS(d3 3)
IF(d3)
  WRAP_CLASS("itk::Rigid3DPerspectiveTransform" POINTER)
    WRAP_TEMPLATE("${ITKM_D}" "${ITKT_D}")
  END_WRAP_CLASS()
  
  WRAP_CLASS("itk::Rigid3DTransform" POINTER)
    WRAP_TEMPLATE("${ITKM_D}" "${ITKT_D}")
  END_WRAP_CLASS()
  
  WRAP_CLASS("itk::VersorRigid3DTransform" POINTER)
    WRAP_TEMPLATE("${ITKM_D}" "${ITKT_D}")
  END_WRAP_CLASS()
  
  WRAP_CLASS("itk::QuaternionRigidTransform" POINTER)
    WRAP_TEMPLATE("${ITKM_D}" "${ITKT_D}")
  END_WRAP_CLASS()
ENDIF(d3)

