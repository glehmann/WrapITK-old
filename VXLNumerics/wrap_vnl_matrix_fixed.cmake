# auto include feature must be disable because the class is not in the file
# with the same name
SET(WRAPPER_AUTO_INCLUDE_HEADERS OFF)
WRAP_INCLUDE("vnl/vnl_matrix_fixed.h")

WRAP_CLASS("vnl_matrix_fixed" DEREF)
  WRAP("_double_2_2" "double,2,2")
  WRAP("_double_2_3" "double,2,3")
  WRAP("_double_2_6" "double,2,6")
  WRAP("_double_3_12" "double,3,12")
  WRAP("_double_3_3" "double,3,3")
  WRAP("_double_3_4" "double,3,4")
  WRAP("_double_4_3" "double,4,3")
  WRAP("_double_4_4" "double,4,4")
  WRAP("_float_3_3" "float,3,3")
END_WRAP_CLASS()