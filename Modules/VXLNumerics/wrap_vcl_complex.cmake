# We can't use the CMake macros to wrap vcl_complex for the reasons described in
# wrap_vcl_complex.cxx. Instead, we have this dummy cmake file to tell CableSwig
# to use our hand-made wrap_vcl_complex.cxx file, and to declare the template
# classes created within that file.
# If we had set the WRAPPER_LIBRARY_CABLESWIG_INPUTS value from within the 
# CMakeLists, we would have had to manually add 'vcl_complex' to the 
# WRAPPER_LIBRARY_GROUPS variable; however 'vcl_complex' is automatically added 
# when this cmake file is read in.

# Don't create a cxx file, we're providing our own!
SET(WRAPPER_DO_NOT_CREATE_CXX ON)

SET(WRAPPER_LIBRARY_CABLESWIG_INPUTS 
  ${WRAPPER_LIBRARY_CABLESWIG_INPUTS}
  "${CMAKE_CURRENT_SOURCE_DIR}/wrap_vcl_complex.cxx") 

LANGUAGE_SUPPORT_ADD_CLASS("vcl_complex" "vcl_complex" "vcl_complexD" "double")
LANGUAGE_SUPPORT_ADD_CLASS("vcl_complex" "vcl_complex" "vcl_complexF" "float")
LANGUAGE_SUPPORT_ADD_CLASS("vcl_complex" "vcl_complex" "vcl_complexLD" "long double")

# std::complex and vcl_complex are the same classes, but python don't know that
LANGUAGE_SUPPORT_ADD_CLASS("complex" "std::complex" "vcl_complexD" "double")
LANGUAGE_SUPPORT_ADD_CLASS("complex" "std::complex" "vcl_complexF" "float")
LANGUAGE_SUPPORT_ADD_CLASS("complex" "std::complex" "vcl_complexLD" "long double")
