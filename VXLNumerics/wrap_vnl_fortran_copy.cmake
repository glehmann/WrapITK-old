# auto include feature must be disable because the class is not in the file
# with the same name
SET(WRAPPER_AUTO_INCLUDE_HEADERS OFF)
WRAP_INCLUDE("vnl/vnl_fortran_copy.h")

WRAP_CLASS("vnl_fortran_copy" DEREF)
  WRAP("_double" "double")
  WRAP("_double_complex" "vcl_complex<double>")
  WRAP("_float" "float")
  WRAP("_float_complex" "vcl_complex<float>")
END_WRAP_CLASS()