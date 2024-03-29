PROJECT(WrapITK)

# check cmake version
# TODO: add the FATAL_ERROR option when we will switch to cmake 2.4 - 2.2 does not support it
CMAKE_MINIMUM_REQUIRED(VERSION 2.2)

# needed for the insight journal
INCLUDE(IJMacros.txt)

ENABLE_TESTING()

###############################################################################
# Config ITKWrap
###############################################################################

# Set up options needed for ConfigureWrapping

# load the language autodetection stuff for the insight journal
INCLUDE(LanguageAutoDetection.cmake)

# set WrapITK version
SET(WrapITK_VERSION_MAJOR 0)
SET(WrapITK_VERSION_MINOR 2)
SET(WrapITK_VERSION_PATCH 1)


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

OPTION(WRAP_complex_float "Wrap complex<float> type" ON)
OPTION(WRAP_complex_double "Wrap complex<double> type" OFF)

SET(WRAP_ITK_DIMS "2;3" CACHE STRING "dimensions available separated by semicolons (;)")

OPTION(INSTALL_WRAP_ITK_COMPATIBILITY "Install FindWrapITK.cmake and WrapITK.pth (so cmake and python can find WrapITK) as part of the standard installation process. This requires admin privileges. These files can be separately installed by making the install_wrapitk_compatibility target. " ON)

SET(WRAP_ITK_INSTALL_PREFIX "/lib/InsightToolkit/WrapITK/" CACHE PATH "subpath where where most of WrapITK files will be installed")


# Output directories.
SET(WRAP_ITK_CONFIG_DIR "${WrapITK_SOURCE_DIR}/ConfigurationInputs")
SET(WRAP_ITK_CMAKE_DIR "${WrapITK_SOURCE_DIR}")
SET(WRAP_ITK_JAVA_DIR "${WrapITK_BINARY_DIR}/Java")
SET (LIBRARY_OUTPUT_PATH ${WrapITK_BINARY_DIR}/lib CACHE INTERNAL "Single output directory for building all libraries.")
SET (EXECUTABLE_OUTPUT_PATH ${WrapITK_BINARY_DIR}/bin CACHE INTERNAL "Single output directory for building all executables.")
MARK_AS_ADVANCED(LIBRARY_OUTPUT_PATH EXECUTABLE_OUTPUT_PATH WRAP_ITK_INSTALL_PREFIX)
SET(CXX_TEST_PATH ${EXECUTABLE_OUTPUT_PATH})

# Now include ConfigureWrapping
INCLUDE(ConfigureWrapping.cmake)

# Now make sure that itk.swg is copied to WRAPPER_SWIG_LIBRARY_OUTPUT_DIR, which
# is set in ConfigureWrapping. We do this so there is only one place that swig
# files needed for a WrapITK build are placed: in the binary directory. (For
# external projects, we look in the WrapITK binary dir and the project's binary
# dir.)
SET(src "${WrapITK_SOURCE_DIR}/itk.swg")
SET(tgt "${WRAPPER_SWIG_LIBRARY_OUTPUT_DIR}/itk.swg")
EXEC_PROGRAM(${CMAKE_COMMAND} ARGS -E copy_if_different "\"${src}\"" "\"${tgt}\"")

SUBDIRS(SwigRuntime)

###############################################################################
# Configure CPack
###############################################################################

# CPack was introduced in cmake 2.4
SET(CMAKE_VERSION "${CMAKE_CACHE_MAJOR_VERSION}.${CMAKE_CACHE_MINOR_VERSION}.${CMAKE_CACHE_RELEASE_VERSION}")
IF("${CMAKE_VERSION}" STRGREATER "2.4")
  SET(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Enhanced languages support for the Insight Toolkit")
  SET(CPACK_PACKAGE_VENDOR "Gaetan Lehmann, Zachary Pincus")
  SET(CPACK_PACKAGE_VERSION_MAJOR "${WrapITK_VERSION_MAJOR}")
  SET(CPACK_PACKAGE_VERSION_MINOR "${WrapITK_VERSION_MINOR}")
  SET(CPACK_PACKAGE_VERSION_PATCH "${WrapITK_VERSION_PATCH}")
  # SET(CPACK_PACKAGE_INSTALL_DIRECTORY "WrapITK-${WrapITK_VERSION_MAJOR}.${WrapITK_VERSION_MINOR}")
  # SET(CPACK_PACKAGE_DESCRIPTION_FILE "${CMAKE_CURRENT_SOURCE_DIR}/README")
  SET(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/Documentation/Copyright/ITKCopyright.txt")
  INCLUDE(CPack)
ENDIF("${CMAKE_VERSION}" STRGREATER "2.4")

###############################################################################
# Configure specific wrapper modules
###############################################################################

SET(WRAP_ITK_MODULES
  VXLNumerics
  Base
  BaseNumerics
  BaseTransforms
  BaseSpatialObject)
  
SET(optional_modules 
  BinaryMorphology
  Calculators
  Compose
  DeformableTransforms
  Denoising
  DistanceMap
  EdgesAndContours
  FFT
  Filtering
  IntensityFilters
  Interpolators
  IO
  Iterators
  LevelSet
  Morphology
  #Patented
  PixelMath
  Registration
  Resize
  SegmentationAndThreshold
  SegmentationValidation
  SimpleFilters
  UnaryPixelMath)

FOREACH(module ${optional_modules})
  OPTION(WRAP_${module} "Build ${module} module." ON)
  MARK_AS_ADVANCED(WRAP_${module})
  IF(WRAP_${module})
    SET(WRAP_ITK_MODULES ${WRAP_ITK_MODULES} ${module})
  ENDIF(WRAP_${module})
ENDFOREACH(module)

FOREACH(module ${WRAP_ITK_MODULES})
  SUBDIRS(Modules/${module})
ENDFOREACH(module)

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
# Configure WrapITKConfig.cmake and FindWrapITK.cmake for external projects
###############################################################################
# First, configure for use directly from the build dir.
SET(CONFIG_CONFIG_DIR "${WrapITK_SOURCE_DIR}/ConfigurationInputs")
SET(CONFIG_CMAKE_DIR "${WrapITK_SOURCE_DIR}")
SET(CONFIG_WRAP_ITK_SWIG_LIBRARY_DIRECTORY "${WRAPPER_SWIG_LIBRARY_OUTPUT_DIR}")
SET(CONFIG_WRAP_ITK_MASTER_INDEX_DIRECTORY "${WRAPPER_MASTER_INDEX_OUTPUT_DIR}")
SET(CONFIG_WRAP_ITK_INSTALL_LOCATION "${CMAKE_INSTALL_PREFIX}/${WRAP_ITK_INSTALL_PREFIX}")
SET(CONFIG_WRAP_ITK_MODULES "${WRAP_ITK_MODULES}")
CONFIGURE_FILE("${WRAP_ITK_CONFIG_DIR}/WrapITKConfig.cmake.in"
               "${WrapITK_BINARY_DIR}/WrapITKConfig.cmake"
               @ONLY IMMEDIATE)

SET(CONFIG_WRAP_ITK_DIR "${WrapITK_BINARY_DIR}")
CONFIGURE_FILE("${WRAP_ITK_CONFIG_DIR}/FindWrapITK.cmake.in"
               "${WrapITK_BINARY_DIR}/FindWrapITK.cmake"
               @ONLY IMMEDIATE)

# Second, configure for installed use. Ensure that no absolute paths
# go into the installed config file, so that it is as portable as possible.
SET(CONFIG_CONFIG_DIR "\${WrapITK_DIR}/Configuration/Inputs")
SET(CONFIG_CMAKE_DIR "\${WrapITK_DIR}/Configuration")
SET(CONFIG_WRAP_ITK_SWIG_LIBRARY_DIRECTORY "\${WrapITK_DIR}/SWIG")
SET(CONFIG_WRAP_ITK_MASTER_INDEX_DIRECTORY "\${WrapITK_DIR}/ClassIndex")
SET(CONFIG_WRAP_ITK_INSTALL_LOCATION "\${WrapITK_DIR}")
CONFIGURE_FILE("${WRAP_ITK_CONFIG_DIR}/WrapITKConfig.cmake.in"
               "${WrapITK_BINARY_DIR}/InstallOnly/WrapITKConfig.cmake"
               @ONLY IMMEDIATE)

SET(CONFIG_WRAP_ITK_DIR "${CMAKE_INSTALL_PREFIX}/${WRAP_ITK_INSTALL_PREFIX}")
CONFIGURE_FILE("${WRAP_ITK_CONFIG_DIR}/FindWrapITK.cmake.in"
               "${WrapITK_BINARY_DIR}/InstallOnly/FindWrapITK.cmake"
               @ONLY IMMEDIATE)


INSTALL_FILES("${WRAP_ITK_INSTALL_PREFIX}/Configuration" FILES 
 ConfigureWrapping.cmake
 CMakeUtilityFunctions.cmake
 CreateCableSwigInputs.cmake
 CreateLanguageSupport.cmake
 CreateWrapperLibrary.cmake
 WrapBasicTypes.cmake
 WrapITKTypes.cmake)

INSTALL_FILES("${WRAP_ITK_INSTALL_PREFIX}/Configuration/Inputs" FILES
 ConfigurationInputs/wrap_ITKLang.cxx.in
 ConfigurationInputs/wrap_ITK.cxx.in
 ConfigurationInputs/wrap_.cxx.in
 ConfigurationInputs/Master.mdx.in
 ConfigurationInputs/gcc_xml.inc.in
 ConfigurationInputs/empty.depend.in
 ConfigurationInputs/typemaps.swg.in)

INSTALL_FILES("${WRAP_ITK_INSTALL_PREFIX}/Configuration/Inputs/LanguageSupport" FILES
  ConfigurationInputs/LanguageSupport/ModuleLoader.py.in
  ConfigurationInputs/LanguageSupport/ModuleConfig.py.in
  ConfigurationInputs/LanguageSupport/ExternalProjectConfig.py.in)

INSTALL_FILES("${WRAP_ITK_INSTALL_PREFIX}/SWIG" FILES "itk.swg")

INSTALL_FILES("${WRAP_ITK_INSTALL_PREFIX}/" FILES "${WrapITK_BINARY_DIR}/InstallOnly/WrapITKConfig.cmake")

# Add a custom target to drive installation of the WrapITK-compatibility files
IF(INSTALL_WRAP_ITK_COMPATIBILITY)
  # if we should by default install the files, make a custom target that will
  # always be built.
  CREATE_INSTALL_AT_ABSOLUTE_PATH_TARGET(install_wrapitk_compatibility DEFAULT
    "Installing WrapITK compatibility files. Requires admin priviliges: turn off INSTALL_WRAP_ITK_COMPATIBILITY in cmake to disable.")
ELSE(INSTALL_WRAP_ITK_COMPATIBILITY)
  # otherwise, add a target that will install the files only when that target is
  # manually built.
  CREATE_INSTALL_AT_ABSOLUTE_PATH_TARGET(install_wrapitk_compatibility ON_DEMAND
    "Installing WrapITK compatibility files. Requires admin priviliges.")
ENDIF(INSTALL_WRAP_ITK_COMPATIBILITY)

INSTALL_AT_ABSOLUTE_PATH(install_wrapitk_compatibility "${CMAKE_ROOT}/Modules" "${WrapITK_BINARY_DIR}/InstallOnly/FindWrapITK.cmake")



INSTALL_FILES("${WRAP_ITK_INSTALL_PREFIX}/Configuration/Python" FILES "${WRAP_ITK_CMAKE_DIR}/Python/CreateLanguageSupport.cmake")
INSTALL_FILES("${WRAP_ITK_INSTALL_PREFIX}/Configuration/Java" FILES "${WRAP_ITK_CMAKE_DIR}/Java/CreateLanguageSupport.cmake")
INSTALL_FILES("${WRAP_ITK_INSTALL_PREFIX}/Configuration/Tcl" FILES "${WRAP_ITK_CMAKE_DIR}/Tcl/CreateLanguageSupport.cmake")

INSTALL_FILES("${WRAP_ITK_INSTALL_PREFIX}/Configuration/Python" FILES "${WRAP_ITK_CMAKE_DIR}/Python/ConfigureWrapping.cmake")
INSTALL_FILES("${WRAP_ITK_INSTALL_PREFIX}/Configuration/Java" FILES "${WRAP_ITK_CMAKE_DIR}/Java/ConfigureWrapping.cmake")
INSTALL_FILES("${WRAP_ITK_INSTALL_PREFIX}/Configuration/Tcl" FILES "${WRAP_ITK_CMAKE_DIR}/Tcl/ConfigureWrapping.cmake")

INSTALL_FILES("${WRAP_ITK_INSTALL_PREFIX}/Configuration/Inputs/LanguageSupport" FILES "${WRAP_ITK_CMAKE_DIR}/ConfigurationInputs/LanguageSupport/ExternalProjectConfig.pth.in")

