# auto include feature must be disable because the class is not in the file
# with the same name
SET(WRAPPER_AUTO_INCLUDE_HEADERS OFF)
WRAP_INCLUDE("vnl/vnl_vector_ref.h")

WRAP_CLASS("vnl_vector_ref" DEREF)
  WRAP("_double" "double")
  WRAP("_float" "float")
END_WRAP_CLASS()