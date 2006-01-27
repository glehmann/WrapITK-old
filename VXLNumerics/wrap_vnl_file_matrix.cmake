# auto include feature must be disable because the class is not in the file
# with the same name
SET(WRAPPER_AUTO_INCLUDE_HEADERS OFF)
WRAP_INCLUDE("vnl/vnl_file_matrix.h")

WRAP_CLASS("vnl_file_matrix" DEREF)
  WRAP("${ITKM_D}" "${ITKT_D}")
  WRAP("${ITKM_F}" "${ITKT_F}")
END_WRAP_CLASS()
