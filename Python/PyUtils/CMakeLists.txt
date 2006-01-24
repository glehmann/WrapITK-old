###############################################################################
# Add the ITKPythonSupport library which contains the itkPyCommand class.

BEGIN_WRAPPER_LIBRARY("ITKPyUtils")

SET(WRAPPER_LIBRARY_DEPENDS ITKCommonA)
SET(WRAPPER_LIBRARY_LINK_LIBRARIES ITKCommon)
# Need to include the current dir because the compiler needs to find itkPyCommand.h
INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR})
# GCC_XML also needs to find itkPyCommand.h
SET(WRAPPER_GCC_XML_INCLUDE_DIRS ${WRAPPER_GCC_XML_INCLUDE_DIRS} "${CMAKE_CURRENT_SOURCE_DIR}")

SET(WRAPPER_LIBRARY_CXX_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/itkPyCommand.cxx") 

WRAPPER_LIBRARY_CREATE_WRAP_FILES()
WRAPPER_LIBRARY_CREATE_LIBRARY()
