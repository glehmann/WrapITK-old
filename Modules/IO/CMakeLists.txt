BEGIN_WRAPPER_LIBRARY(IO)

SET(WRAPPER_LIBRARY_DEPENDS Base)

SET(WRAPPER_LIBRARY_LINK_LIBRARIES ITKCommon ITKIO)

WRAPPER_LIBRARY_CREATE_WRAP_FILES()
WRAPPER_LIBRARY_CREATE_LIBRARY()
