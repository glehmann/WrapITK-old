# auto include feature must be disable because the class is not in the file
# with the same name
SET(WRAPPER_AUTO_INCLUDE_HEADERS OFF)
WRAP_INCLUDE("vcl_complex.h")
WRAP_INCLUDE("vnl/vnl_vector.h")
WRAP_INCLUDE("vnl/vnl_matrix.h")

WRAP_CLASS("vnl_matrix" DEREF)
  WRAP("${ITKM_D}" "${ITKT_D}")
  WRAP("_vcl_complex${ITKM_D}" "vcl_complex<${ITKT_D}>")
  WRAP("${ITKM_F}" "${ITKT_F}")
  WRAP("_vcl_complex${ITKM_F}" "vcl_complex<${ITKT_F}>")
  WRAP("${ITKM_SI}" "${ITKT_SI}")
  WRAP("${ITKM_SL}" "${ITKT_SL}")
  WRAP("${ITKM_LD}" "${ITKT_LD}")
  WRAP("_vcl_complex${ITKM_LD}" "vcl_complex<${ITKT_LD}>")
  WRAP("${ITKM_SC}" "${ITKT_SC}")
  WRAP("${ITKM_UC}" "un${ITKT_SC}")
  WRAP("${ITKM_UI}" "un${ITKT_SI}")
  WRAP("${ITKM_UL}" "un${ITKT_SL}")
END_WRAP_CLASS()
