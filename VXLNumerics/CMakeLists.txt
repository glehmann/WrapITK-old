# create the VXLNumerics libraries

SET(WRAP_SOURCES
  vnl_matrix
  vnl_vector
  vnl_c_vector
  vnl_diag_matrix
  vnl_file_matrix
  vnl_file_vector
  vnl_fortran_copy
  vnl_matrix_fixed
  vnl_matrix_fixed_ref
  vnl_matrix_ref
  vnl_vector_ref
)

SET(MASTER_INDEX_FILES "${WrapITK_BINARY_DIR}/VXLNumerics/VXLNumerics.mdx")

ITK_WRAP_LIBRARY("${WRAP_SOURCES}" VXLNumerics VXLNumerics "" "" "${VXL_NUMERICS_LIBRARIES};itkvnl_inst"
  "${MASTER_INDEX_FILES}" "${WrapITK_SOURCE_DIR}" "${WrapITK_BINARY_DIR}")

