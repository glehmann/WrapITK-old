
SET(WRAPPER_AUTO_INCLUDE_HEADERS OFF)
WRAP_INCLUDE("itkNarrowBand.h")

WRAP_CLASS("itk::BandNode" DEREF)
  FOREACH(d ${WRAP_DIMS})
    COND_WRAP("I${d}${ITKM_D}"  "itk::Index < ${d} >, ${ITKT_D}"  "D")
    COND_WRAP("I${d}${ITKM_F}"  "itk::Index < ${d} >, ${ITKT_F}"  "F")
    COND_WRAP("I${d}${ITKM_UL}" "itk::Index < ${d} >, ${ITKT_UL}" "UL")
    COND_WRAP("I${d}${ITKM_US}" "itk::Index < ${d} >, ${ITKT_US}" "US")
    COND_WRAP("I${d}${ITKM_UC}" "itk::Index < ${d} >, ${ITKT_UC}" "UC")
    COND_WRAP("I${d}${ITKM_SL}" "itk::Index < ${d} >, ${ITKT_SL}" "SL")
    COND_WRAP("I${d}${ITKM_SS}" "itk::Index < ${d} >, ${ITKT_SS}" "SS")
    COND_WRAP("I${d}${ITKM_SC}" "itk::Index < ${d} >, ${ITKT_SC}" "SC")
  ENDFOREACH(d)
END_WRAP_CLASS()

WRAP_CLASS("itk::NarrowBand" POINTER)
  FOREACH(d ${WRAP_DIMS})
    COND_WRAP("BNI${d}${ITKM_D}"  "itk::BandNode< itk::Index < ${d} >, ${ITKT_D} >"  "D")
    COND_WRAP("BNI${d}${ITKM_F}"  "itk::BandNode< itk::Index < ${d} >, ${ITKT_F} >"  "F")
    COND_WRAP("BNI${d}${ITKM_UL}" "itk::BandNode< itk::Index < ${d} >, ${ITKT_UL} >" "UL")
    COND_WRAP("BNI${d}${ITKM_US}" "itk::BandNode< itk::Index < ${d} >, ${ITKT_US} >" "US")
    COND_WRAP("BNI${d}${ITKM_UC}" "itk::BandNode< itk::Index < ${d} >, ${ITKT_UC} >" "UC")
    COND_WRAP("BNI${d}${ITKM_SL}" "itk::BandNode< itk::Index < ${d} >, ${ITKT_SL} >" "SL")
    COND_WRAP("BNI${d}${ITKM_SS}" "itk::BandNode< itk::Index < ${d} >, ${ITKT_SS} >" "SS")
    COND_WRAP("BNI${d}${ITKM_SC}" "itk::BandNode< itk::Index < ${d} >, ${ITKT_SC} >" "SC")
  ENDFOREACH(d)
END_WRAP_CLASS()
