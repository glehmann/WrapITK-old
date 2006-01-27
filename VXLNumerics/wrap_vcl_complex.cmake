SET(WRAPPER_AUTO_INCLUDE_HEADERS OFF)
WRAP_INCLUDE("vcl_complex.h")

WRAP_CLASS("vcl_complex")
  WRAP("_double" "double")
  WRAP("_float" "float")
  WRAP("_long_double" "long double")
END_WRAP_CLASS()