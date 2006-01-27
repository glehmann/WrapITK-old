# auto include feature must be disable because the class is not in the file
# with the same name
SET(WRAPPER_AUTO_INCLUDE_HEADERS OFF)
WRAP_INCLUDE("vcl_complex.h")
WRAP_INCLUDE("vnl/vnl_diag_matrix.h")

WRAP_CLASS("vnl_diag_matrix" DEREF)
  WRAP("${ITKM_D}" "${ITKT_D}")
  WRAP("_vcl_complex${ITKM_D}" "vcl_complex<${ITKT_D}>")
  WRAP("${ITKM_F}" "${ITKT_F}")
  WRAP("_vcl_complex${ITKM_F}" "vcl_complex<${ITKT_F}>")
  WRAP("${ITKM_SI}" "${ITKT_SI}")
  WRAP("${ITKM_LD}" "${ITKT_LD}")
END_WRAP_CLASS()
