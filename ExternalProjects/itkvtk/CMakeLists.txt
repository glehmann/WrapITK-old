#-----------------------------------------------------------------------------
PROJECT(itkvtk)

#-----------------------------------------------------------------------------
# DaVaW version number, usefull for packaging and doxygen doc:
SET(itkvtk_MAJOR_VERSION 1)
SET(itkvtk_MINOR_VERSION 0)
SET(itkvtk_BUILD_VERSION 0)
SET(itkvtk_VERSION
    "${itkvtk_MAJOR_VERSION}.${itkvtk_MINOR_VERSION}.${itkvtk_BUILD_VERSION}")

#-----------------------------------------------------------------------------
SET (EXECUTABLE_OUTPUT_PATH ${itkvtk_BINARY_DIR}/bin CACHE PATH "Single output directory for building all executables.")
SET (LIBRARY_OUTPUT_PATH ${itkvtk_BINARY_DIR}/bin CACHE PATH "Single output directory for building all libraries.")
MARK_AS_ADVANCED(LIBRARY_OUTPUT_PATH EXECUTABLE_OUTPUT_PATH)
SET(itkvtk_LIBRARY_DIR ${LIBRARY_OUTPUT_PATH})
SET(itkvtk_EXECUTABLE_DIR ${EXECUTABLE_OUTPUT_PATH})

#-----------------------------------------------------------------------------
SET(WRAP_PYTHON OFF CACHE BOOL "Wrap library in Python")
SET(WRAP_TCL OFF CACHE BOOL "Wrap library in Tcl")
SET(WRAP_JAVA OFF CACHE BOOL "Wrap library in Java")

#-----------------------------------------------------------------------------
# Find ITK
FIND_PACKAGE(ITK)
IF(NOT ITK_FOUND)
   MESSAGE(FATAL_ERROR "ITK Library can't be found")
ELSE(NOT ITK_FOUND)
   INCLUDE(${USE_ITK_FILE})
ENDIF(NOT ITK_FOUND)

# Find VTK
FIND_PACKAGE(VTK)
IF (VTK_FOUND)
INCLUDE (${VTK_USE_FILE})
ENDIF (VTK_FOUND)

#-----------------------------------------------------------------------------
INCLUDE_DIRECTORIES(${VTK_INCLUDE_DIRS} ${ITK_INCLUDE_DIRS} ${itkvtk_SOURCE_DIR}/src)
LINK_DIRECTORIES(${VTK_LIBRARY_DIRS} ${ITK_LIBRARY_DIRS})

#-----------------------------------------------------------------------------
SUBDIRS(
   src 
)

IF(WRAP_PYTHON OR WRAP_TCL OR WRAP_JAVA)
   SUBDIRS(Wrapping)
ENDIF(WRAP_PYTHON OR WRAP_TCL OR WRAP_JAVA)

#-----------------------------------------------------------------------------
INSTALL_FILES(/include/InsightToolkit/BasicFilters FILES ${itkvtk_SOURCE_DIR}/src/itkImageToVTKImageFilter.h)
INSTALL_FILES(/include/InsightToolkit/BasicFilters FILES ${itkvtk_SOURCE_DIR}/src/itkImageToVTKImageFilter.txx)
INSTALL_FILES(/include/InsightToolkit/BasicFilters FILES ${itkvtk_SOURCE_DIR}/src/itkVTKImageToImageFilter.h)
INSTALL_FILES(/include/InsightToolkit/BasicFilters FILES ${itkvtk_SOURCE_DIR}/src/itkVTKImageToImageFilter.txx)
