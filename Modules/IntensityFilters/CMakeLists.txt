BEGIN_WRAPPER_LIBRARY(IntensityFilters)

SET(WRAPPER_LIBRARY_DEPENDS Base BaseNumerics)

SET(WRAPPER_LIBRARY_LINK_LIBRARIES ITKCommon ITKStatistics)

WRAPPER_LIBRARY_CREATE_WRAP_FILES()
WRAPPER_LIBRARY_CREATE_LIBRARY()
