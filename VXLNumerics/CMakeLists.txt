BEGIN_WRAPPER_LIBRARY("VXLNumerics")

# Set the required link libraries.
# TODO: are these all the link libs needed? What about itkvcl?
SET(WRAPPER_LIBRARY_LINK_LIBRARIES itkvnl itkvnl_algo itknetlib itkvnl_inst)

# We're not going to call WRAPPER_LIBRARY_CREATE_WRAP_FILES because they 
# are manyally created. Instead we will manually populate the WRAPPER_LIBRARY_GROUPS
# variable, and then call WRITE_MODULE_FILES (usually called by 
# WRAPPER_LIBRARY_CREATE_WRAP_FILES) to write the master cswig inputs which
# specify the contents of the module. The WRAPPER_LIBRARY_GROUPS is all that
# we need to set to call WRITE_MODULE_FILES.

SET(WRAPPER_LIBRARY_GROUPS
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
  vnl_vector_ref)

WRITE_MODULE_FILES()

# Now we need to manually populate the WRAPPER_LIBRARY_CABLESWIG_INPUTS variable
# with the manually-generated inputs.
SET(WRAPPER_LIBRARY_CABLESWIG_INPUTS )
FOREACH(file ${WRAPPER_LIBRARY_GROUPS})
  SET(WRAPPER_LIBRARY_CABLESWIG_INPUTS ${WRAPPER_LIBRARY_CABLESWIG_INPUTS} 
    "${CMAKE_CURRENT_SOURCE_DIR}/wrap_${file}.cxx")
ENDFOREACH(file)

# Finally we can create the library.
WRAPPER_LIBRARY_CREATE_LIBRARY()
