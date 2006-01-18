PROJECT(WrapITK)

CMAKE_MINIMUM_REQUIRED(VERSION 2.2)

###############################################################################
# Config ITKWrap
###############################################################################

# Set up options needed for itkConfigWrapping

OPTION(WRAP_ITK_TCL "Build cswig Tcl wrapper support." OFF)
OPTION(WRAP_ITK_PYTHON "Build cswig Python wrapper support." OFF)
OPTION(WRAP_ITK_JAVA "Build cswig Java wrapper support." OFF)

OPTION(WRAP_unsigned_char "Wrap unsigned char type" OFF)
OPTION(WRAP_unsigned_short "Wrap unsigned short type" ON)
OPTION(WRAP_unsigned_long "Wrap unsigned long type" OFF)

OPTION(WRAP_signed_char "Wrap signed char type" OFF)
OPTION(WRAP_signed_short "Wrap signed short type" OFF)
OPTION(WRAP_signed_long "Wrap signed long type" OFF)

OPTION(WRAP_float "Wrap float type" ON)
OPTION(WRAP_double "Wrap double type" OFF)

OPTION(WRAP_vector_float "Wrap vector float type" ON)
OPTION(WRAP_vector_double "Wrap vector double type" OFF)

OPTION(WRAP_covariant_vector_float "Wrap covariant vector float type" ON)
OPTION(WRAP_covariant_vector_double "Wrap covariant vector double type" OFF)

OPTION(WRAP_rgb_unsigned_char "Wrap RGB< unsigned char > type" ON)
OPTION(WRAP_rgb_unsigned_short "Wrap RGB< unsigned short > type" OFF)

SET(WRAP_DIMS "2;3" CACHE STRING "dimensions available separated by semicolons (;)")
SET(WRAP_ITK_INSTALL_LOCATION "/lib/InsightToolkit/WrapITK" CACHE STRING "Path to the top of the WrapITK install tree (will be appended to CMAKE_INSTALL_PREFIX).")

SET(ITK_SWG_FILES "${WrapITK_SOURCE_DIR}/itk.swg")
SET(WRAP_ITK_CONFIG_DIR ${WrapITK_SOURCE_DIR})
SET(WRAP_ITK_CMAKE_DIR ${WrapITK_SOURCE_DIR})
SET(WRAP_ITK_JAVA_DIR "${WrapITK_BINARY_DIR}/Java")

# Now include itkConfigWrapping
INCLUDE(itkConfigWrapping.cmake)

# WRAP_ITK_SWIG_INCLUDE_DIRS initially populated by itkConfigWrapping 
SET(WRAP_ITK_SWIG_INCLUDE_DIRS
  ${WRAP_ITK_SWIG_INCLUDE_DIRS}
  ${WrapITK_SOURCE_DIR}
  ${WrapITK_SOURCE_DIR}/CommonA
  ${WrapITK_SOURCE_DIR}/CommonB
  ${WrapITK_SOURCE_DIR}/VXLNumerics
  ${WrapITK_SOURCE_DIR}/Numerics
  ${WrapITK_SOURCE_DIR}/BasicFiltersA
  ${WrapITK_SOURCE_DIR}/BasicFiltersB
  ${WrapITK_SOURCE_DIR}/IO
  ${WrapITK_SOURCE_DIR}/SpatialObject
  ${WrapITK_SOURCE_DIR}/Algorithms
  )

SET(ITK_KITS VXLNumerics CommonA CommonB Numerics
  BasicFiltersA BasicFiltersB BasicFiltersC IO
  SpatialObject Algorithms
  )
SUBDIRS(SwigRuntime ${ITK_KITS} Tests Testing)

# Output directories.
SET (LIBRARY_OUTPUT_PATH ${WrapITK_BINARY_DIR}/bin CACHE INTERNAL "Single output directory for building all libraries.")
SET (EXECUTABLE_OUTPUT_PATH ${WrapITK_BINARY_DIR}/bin CACHE INTERNAL "Single output directory for building all executables.")
MARK_AS_ADVANCED(LIBRARY_OUTPUT_PATH EXECUTABLE_OUTPUT_PATH)
SET(WRAP_ITK_LIBRARY_PATH "${LIBRARY_OUTPUT_PATH}")
SET(WRAP_ITK_EXECUTABLE_PATH "${EXECUTABLE_OUTPUT_PATH}")
SET(CXX_TEST_PATH ${EXECUTABLE_OUTPUT_PATH})

###############################################################################
# Configure language-specific features
###############################################################################
IF(WRAP_ITK_TCL)
  SUBDIRS(Tcl)
ENDIF(WRAP_ITK_TCL)

IF(WRAP_ITK_PERL)
  # Nothing yet
ENDIF(WRAP_ITK_PERL)

IF(WRAP_ITK_PYTHON)
  SUBDIRS(Python)
ENDIF(WRAP_ITK_PYTHON)

IF(WRAP_ITK_JAVA)
  SUBDIRS(Java)
ENDIF(WRAP_ITK_JAVA)

###############################################################################
# Configure UseWrapITK.cmake and FindWrapITK.cmale for external projects
###############################################################################

# First, configure for use directly from the build dir.
SET(CONFIG_SWIG_DIR "${WrapITK_SOURCE_DIR}")
SET(CONFIG_CONFIG_DIR "${WrapITK_SOURCE_DIR}")
SET(CONFIG_CMAKE_DIR "${WrapITK_SOURCE_DIR}")
SET(CONFIG_WRAP_ITK_SWIG_LIBRARY_DIR "${LIBRARY_OUTPUT_PATH}")

SET(CONFIG_MIDX_FILES "")
FOREACH(midx 
    "VXLNumerics/VXLNumerics"
    "Numerics/ITKNumerics"
    "CommonA/ITKCommonA"
    "CommonB/ITKCommonB"
    "BasicFiltersA/ITKBasicFiltersA"
    "BasicFiltersB/ITKBasicFiltersB"
    "BasicFiltersC/ITKBasicFiltersC"
    "SpatialObject/ITKSpatialObject"
    "Algorithms/ITKAlgorithms"
    "IO/ITKIO")
  SET(CONFIG_MIDX_FILES "${CONFIG_MIDX_FILES}\n  \"${WrapITK_BINARY_DIR}/${midx}.mdx\"")
ENDFOREACH(midx)

CONFIGURE_FILE("${WrapITK_SOURCE_DIR}/UseWrapITK.cmake.in"
               "${WrapITK_BINARY_DIR}/UseWrapITK.cmake"
               @ONLY IMMEDIATE)

SET(CONFIG_WRAP_ITK_DIR "${WrapITK_BINARY_DIR}")
CONFIGURE_FILE("${WrapITK_SOURCE_DIR}/FindWrapITK.cmake.in"
               "${WrapITK_BINARY_DIR}/FindWrapITK.cmake"
               @ONLY IMMEDIATE)

# Second, configure for installed use.
SET(CONFIG_SWIG_DIR "${CMAKE_INSTALL_PREFIX}${WRAP_ITK_INSTALL_LOCATION}/Configuration")
SET(CONFIG_CONFIG_DIR "${CMAKE_INSTALL_PREFIX}${WRAP_ITK_INSTALL_LOCATION}/Configuration")
SET(CONFIG_CMAKE_DIR "${CMAKE_INSTALL_PREFIX}${WRAP_ITK_INSTALL_LOCATION}/Configuration")

SET(CONFIG_WRAP_ITK_SWIG_LIBRARY_DIR "${CMAKE_INSTALL_PREFIX}${WRAP_ITK_INSTALL_LOCATION}/lib")

SET(CONFIG_MIDX_FILES "")
FOREACH(midx 
    "VXLNumerics"
    "ITKNumerics"
    "ITKCommonA"
    "ITKCommonB"
    "ITKBasicFiltersA"
    "ITKBasicFiltersB"
    "ITKBasicFiltersC"
    "ITKSpatialObject"
    "ITKAlgorithms"
    "ITKIO")
  SET(CONFIG_MIDX_FILES "${CONFIG_MIDX_FILES}\n  \"${CMAKE_INSTALL_PREFIX}${WRAP_ITK_INSTALL_LOCATION}/ClassIndex/${midx}.mdx\"")
ENDFOREACH(midx)

CONFIGURE_FILE("${WrapITK_SOURCE_DIR}/UseWrapITK.cmake.in"
               "${WrapITK_BINARY_DIR}/InstallOnly/UseWrapITK.cmake"
               @ONLY IMMEDIATE)

SET(CONFIG_WRAP_ITK_DIR "${CMAKE_INSTALL_PREFIX}${WRAP_ITK_INSTALL_LOCATION}")
CONFIGURE_FILE("${WrapITK_SOURCE_DIR}/FindWrapITK.cmake.in"
               "${WrapITK_BINARY_DIR}/InstallOnly/FindWrapITK.cmake"
               @ONLY IMMEDIATE)

FOREACH(f
 itkConfigWrapping.cmake
 itk.swg
 wrap_ITK.cxx.in
 wrap_.cxx.in
 WrapITK.cmake
 WrapTypePrefix.cmake
 WrapTypeBase.cmake
 Master.mdx.in
 SwigInc.txt.in
 empty.depend.in
 wrap_ITKLang.cxx.in
 WrapITKLang.cmake)
  INSTALL_FILES("${WRAP_ITK_INSTALL_LOCATION}/Configuration" FILES "${f}")
ENDFOREACH(f)

INSTALL_FILES("${WRAP_ITK_INSTALL_LOCATION}" FILES "${WrapITK_BINARY_DIR}/InstallOnly/UseWrapITK.cmake")
# INTSTALL doesn't work with absolute paths... can't install yet.
# INSTALL_FILES( "${CMAKE_ROOT}/Modules" FILES "${WrapITK_BINARY_DIR}/InstallOnly/FindWrapITK.cmake")
