PROJECT(ItkVtkGlue)

OPTION(BUILD_WRAPPERS "Wrap library" OFF)
OPTION(INSTALL_DEVEL_FILES "Install C++ headers" ON)

FIND_PACKAGE(ITK REQUIRED)
FIND_PACKAGE(VTK REQUIRED)

INCLUDE_DIRECTORIES(${VTK_INCLUDE_DIRS} ${ITK_INCLUDE_DIRS} ${ItkVtkGlue_SOURCE_DIR}/src)
LINK_DIRECTORIES(${VTK_LIBRARY_DIRS} ${ITK_LIBRARY_DIRS})

IF(BUILD_WRAPPERS)
   SUBDIRS(Wrapping)
ENDIF(BUILD_WRAPPERS)

# install devel files
IF(INSTALL_DEVEL_FILES)
  FOREACH(f itkImageToVTKImageFilter.h itkImageToVTKImageFilter.txx itkVTKImageToImageFilter.h itkVTKImageToImageFilter.txx)
    INSTALL_FILES(/include/InsightToolkit/BasicFilters FILES ${CMAKE_CURRENT_SOURCE_DIR}/src/${f})
  ENDFOREACH(f)
ENDIF(INSTALL_DEVEL_FILES)

ENABLE_TESTING()
