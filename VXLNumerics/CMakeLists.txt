BEGIN_WRAPPER_LIBRARY("VXLNumerics")

# Set the required link libraries.
# TODO: are these all the link libs needed? What about itkvcl?
SET(WRAPPER_LIBRARY_LINK_LIBRARIES itkvnl itkvnl_algo itknetlib itkvnl_inst)

WRAPPER_LIBRARY_CREATE_WRAP_FILES() 
WRAPPER_LIBRARY_CREATE_LIBRARY()
