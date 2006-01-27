# auto include feature must be disable because the class is not in the file
# with the same name
SET(WRAPPER_AUTO_INCLUDE_HEADERS OFF)
WRAP_INCLUDE("vcl_complex.h")
WRAP_INCLUDE("vnl/vnl_diag_matrix.h")

WRAP_CLASS("vnl_diag_matrix" DEREF)
  WRAP("_double" "double")
  WRAP("_double_complex" "vcl_complex<double>")
  WRAP("_float" "float")
  WRAP("_float_complex" "vcl_complex<float>")
  WRAP("_int" "int")
  WRAP("_long_double" "long double")
END_WRAP_CLASS()
