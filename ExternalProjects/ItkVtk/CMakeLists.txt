#-----------------------------------------------------------------------------
PROJECT(ItkVtk)

#-----------------------------------------------------------------------------
# DaVaW version number, usefull for packaging and doxygen doc:
SET(ItkVtk_MAJOR_VERSION 1)
SET(ItkVtk_MINOR_VERSION 0)
SET(ItkVtk_BUILD_VERSION 0)
SET(ItkVtk_VERSION
    "${ItkVtk_MAJOR_VERSION}.${ItkVtk_MINOR_VERSION}.${ItkVtk_BUILD_VERSION}")

#-----------------------------------------------------------------------------
SET (EXECUTABLE_OUTPUT_PATH ${ItkVtk_BINARY_DIR}/bin CACHE PATH "Single output directory for building all executables.")
SET (LIBRARY_OUTPUT_PATH ${ItkVtk_BINARY_DIR}/bin CACHE PATH "Single output directory for building all libraries.")
MARK_AS_ADVANCED(LIBRARY_OUTPUT_PATH EXECUTABLE_OUTPUT_PATH)
SET(ItkVtk_LIBRARY_DIR ${LIBRARY_OUTPUT_PATH})
SET(ItkVtk_EXECUTABLE_DIR ${EXECUTABLE_OUTPUT_PATH})

#-----------------------------------------------------------------------------
SET(BUILD_WRAPPERS OFF CACHE BOOL "Wrap library")

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
INCLUDE_DIRECTORIES(${VTK_INCLUDE_DIRS} ${ITK_INCLUDE_DIRS} ${ItkVtk_SOURCE_DIR}/src)
LINK_DIRECTORIES(${VTK_LIBRARY_DIRS} ${ITK_LIBRARY_DIRS})

#-----------------------------------------------------------------------------
SUBDIRS(
   src 
)

IF(BUILD_WRAPPERS)
   SUBDIRS(Wrapping)
ENDIF(BUILD_WRAPPERS)

#-----------------------------------------------------------------------------
INSTALL_FILES(/include/InsightToolkit/BasicFilters FILES ${ItkVtk_SOURCE_DIR}/src/itkImageToVTKImageFilter.h)
INSTALL_FILES(/include/InsightToolkit/BasicFilters FILES ${ItkVtk_SOURCE_DIR}/src/itkImageToVTKImageFilter.txx)
INSTALL_FILES(/include/InsightToolkit/BasicFilters FILES ${ItkVtk_SOURCE_DIR}/src/itkVTKImageToImageFilter.h)
INSTALL_FILES(/include/InsightToolkit/BasicFilters FILES ${ItkVtk_SOURCE_DIR}/src/itkVTKImageToImageFilter.txx)
