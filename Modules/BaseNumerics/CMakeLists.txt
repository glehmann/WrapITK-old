BEGIN_WRAPPER_LIBRARY(BaseNumerics)

SET(WRAPPER_LIBRARY_DEPENDS Base)

SET(WRAPPER_LIBRARY_LINK_LIBRARIES ITKCommon ITKNumerics ITKStatistics)

WRAPPER_LIBRARY_CREATE_WRAP_FILES()
WRAPPER_LIBRARY_CREATE_LIBRARY()
