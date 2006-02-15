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

SET(WRAP_ITK_SWIG_LIBRARY_DIR "${WrapITK_BINARY_DIR}/SWIG")
SET(WRAP_ITK_CONFIG_DIR "${WrapITK_SOURCE_DIR}/ConfigurationInputs")
SET(WRAP_ITK_CMAKE_DIR "${WrapITK_SOURCE_DIR}")
SET(WRAP_ITK_JAVA_DIR "${WrapITK_BINARY_DIR}/Java")

# Now include itkConfigWrapping
INCLUDE(itkConfigWrapping.cmake)

# Now make sure that itk.swg is copied to WRAPPER_SWIG_LIBRARY_OUTPUT_DIR, which
# is set in itkConfigWrapping. We do this so there is only one place that swig
# files needed for a WrapITK build are placed: in the binary directory. (For
# external projects, we look in the WrapITK binary dir and the project's binary
# dir.)

ADD_CUSTOM_TARGET(copy_itk_swg ALL)
SET(src "${WrapITK_SOURCE_DIR}/itk.swg")
SET(tgt "${WRAPPER_SWIG_LIBRARY_OUTPUT_DIR}/itk.swg")
ADD_CUSTOM_COMMAND(SOURCE ${src}
  COMMAND ${CMAKE_COMMAND}
  ARGS -E copy_if_different ${src} ${tgt}
  OUTPUTS ${tgt}
  TARGET copy_itk_swg
  COMMENT "copy itk.swg file to proper place for build")
# driver command to make the copy happen.
ADD_CUSTOM_COMMAND(
  SOURCE copy_itk_swg
  DEPENDS ${tgt}
  TARGET copy_itk_swg)

# ITK_KITS must be in proper order -- modules that depend on other modules
# must come later in the list.
SET(ITK_KITS VXLNumerics CommonA CommonB Numerics 
  BasicFiltersA BasicFiltersB BasicFiltersC IO
  SpatialObject Algorithms)

# Only process the subdirs (which takes a while, generating the .cxx files)
# if some language has already been enabled. Otherwise we will
# process the subdirs at least twice, which is slow!
IF(NOT some_language_configured)
  # if there's no cache variable for some_language_configured, make one.
  SET(some_language_configured OFF CACHE INTERNAL "has some language been enabled?")
ENDIF(NOT some_language_configured)

IF(some_language_configured)
SUBDIRS(SwigRuntime ${ITK_KITS} Tests Testing)
ENDIF(some_language_configured)

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
  SET(some_language_configured ON CACHE INTERNAL "has some language been enabled?")
  SUBDIRS(Tcl)
ENDIF(WRAP_ITK_TCL)

IF(WRAP_ITK_PERL)
  SET(some_language_configured ON CACHE INTERNAL "has some language been enabled?")
  # Nothing yet
ENDIF(WRAP_ITK_PERL)

IF(WRAP_ITK_PYTHON)
  SET(some_language_configured ON CACHE INTERNAL "has some language been enabled?")
  SUBDIRS(Python)
ENDIF(WRAP_ITK_PYTHON)

IF(WRAP_ITK_JAVA)
  SET(some_language_configured ON CACHE INTERNAL "has some language been enabled?")
  SUBDIRS(Java)
ENDIF(WRAP_ITK_JAVA)

###############################################################################
# Configure WrapITKConfig.cmake and FindWrapITK.cmale for external projects
###############################################################################
# First, configure for use directly from the build dir.
SET(CONFIG_CONFIG_DIR "${WrapITK_SOURCE_DIR}/ConfigurationInputs")
SET(CONFIG_CMAKE_DIR "${WrapITK_SOURCE_DIR}")
SET(CONFIG_WRAP_ITK_SWIGRUNTIME_DIR "${LIBRARY_OUTPUT_PATH}")
SET(CONFIG_WRAP_ITK_SWIG_LIBRARY_DIRECTORY "${WRAPPER_SWIG_LIBRARY_OUTPUT_DIR}")
SET(CONFIG_WRAP_ITK_MASTER_INDEX_DIRECTORY "${WRAPPER_MASTER_INDEX_OUTPUT_DIR}")
CONFIGURE_FILE("${WRAP_ITK_CONFIG_DIR}/WrapITKConfig.cmake.in"
               "${WrapITK_BINARY_DIR}/WrapITKConfig.cmake"
               @ONLY IMMEDIATE)

SET(CONFIG_WRAP_ITK_DIR "${WrapITK_BINARY_DIR}")
CONFIGURE_FILE("${WRAP_ITK_CONFIG_DIR}/FindWrapITK.cmake.in"
               "${WrapITK_BINARY_DIR}/FindWrapITK.cmake"
               @ONLY IMMEDIATE)

# Second, configure for installed use.
SET(CONFIG_CONFIG_DIR "${CMAKE_INSTALL_PREFIX}${WRAP_ITK_INSTALL_LOCATION}/Configuration/Inputs")
SET(CONFIG_CMAKE_DIR "${CMAKE_INSTALL_PREFIX}${WRAP_ITK_INSTALL_LOCATION}/Configuration")
SET(CONFIG_WRAP_ITK_SWIGRUNTIME_DIR "${CMAKE_INSTALL_PREFIX}${WRAP_ITK_INSTALL_LOCATION}/lib")
SET(CONFIG_WRAP_ITK_SWIG_LIBRARY_DIRECTORY "${CMAKE_INSTALL_PREFIX}${WRAP_ITK_INSTALL_LOCATION}/SWIG")
SET(CONFIG_WRAP_ITK_MASTER_INDEX_DIRECTORY "${CMAKE_INSTALL_PREFIX}${WRAP_ITK_INSTALL_LOCATION}/ClassIndex")

CONFIGURE_FILE("${WRAP_ITK_CONFIG_DIR}/WrapITKConfig.cmake.in"
               "${WrapITK_BINARY_DIR}/InstallOnly/WrapITKConfig.cmake"
               @ONLY IMMEDIATE)

SET(CONFIG_WRAP_ITK_DIR "${CMAKE_INSTALL_PREFIX}${WRAP_ITK_INSTALL_LOCATION}")
CONFIGURE_FILE("${WRAP_ITK_CONFIG_DIR}/FindWrapITK.cmake.in"
               "${WrapITK_BINARY_DIR}/InstallOnly/FindWrapITK.cmake"
               @ONLY IMMEDIATE)

FOREACH(f
 itkConfigWrapping.cmake
 CreateCableSwigInputs.cmake
 CreateLanguageSupport.cmake
 CreateWrapperLibrary.cmake
 WrapTypePrefix.cmake
 WrapTypeBase.cmake)
  INSTALL_FILES("${WRAP_ITK_INSTALL_LOCATION}/Configuration" FILES "${f}")
ENDFOREACH(f)

FOREACH(f
 ConfigurationInputs/wrap_ITKLang.cxx.in
 ConfigurationInputs/wrap_ITK.cxx.in
 ConfigurationInputs/wrap_.cxx.in
 ConfigurationInputs/Master.mdx.in
 ConfigurationInputs/gcc_xml.inc.in
 ConfigurationInputs/empty.depend.in
 ConfigurationInputs/typemaps.swg.in
 )
  INSTALL_FILES("${WRAP_ITK_INSTALL_LOCATION}/Configuration/Inputs" FILES "${f}")
ENDFOREACH(f)

FOREACH(f
 ConfigurationInputs/LanguageSupport/ModuleLoader.py.in
 ConfigurationInputs/LanguageSupport/ModuleConfig.py.in
 ConfigurationInputs/LanguageSupport/ExternalProjectConfig.py.in)
  INSTALL_FILES("${WRAP_ITK_INSTALL_LOCATION}/Configuration/Inputs/LanguageSupport" FILES "${f}")
ENDFOREACH(f)

INSTALL_FILES("${WRAP_ITK_INSTALL_LOCATION}/SWIG" FILES "itk.swg")

INSTALL_FILES("${WRAP_ITK_INSTALL_LOCATION}" FILES "${WrapITK_BINARY_DIR}/InstallOnly/WrapITKConfig.cmake")

####################################
# Hackish macros to install a file at an absolute location, working around a 
# CMake limitation.

ADD_CUSTOM_TARGET(CustomInstall ALL)
# add a global target so that if this macro is called from one subdirectory or 
# another, they each "see" this single top-level target.

MACRO(INSTALL_AT_ABSOLUTE_PATH PATH)
  # USAGE: 
  # INSTALL_AT_ABSOLUTE_PATH("/path/to/install" "/path/to/file1" ... "path/to/fileN")
  
  IF(NOT CUSTOM_INSTALL_FILE_WRITTEN)
    WRITE_CUSTOM_INSTALL_FILES()
    SET(CUSTOM_INSTALL_FILE_WRITTEN ON)
  ENDIF(NOT CUSTOM_INSTALL_FILE_WRITTEN)
  
  FOREACH(file ${ARGN})
    GET_FILENAME_COMPONENT(filename "${file}" NAME)
    STRING(REGEX REPLACE "/$" "" stripped_path "${PATH}")
    FILE(APPEND "${PROJECT_BINARY_DIR}/CustomInstall.cmake" 
     "MESSAGE(STATUS \"Installing ${stripped_path}/${filename}\")\n")
    FILE(APPEND "${PROJECT_BINARY_DIR}/CustomInstall.cmake" 
     "FILE(INSTALL DESTINATION \"${PATH}\" TYPE FILE FILES \"${file}\")\n")
  ENDFOREACH(file)
ENDMACRO(INSTALL_AT_ABSOLUTE_PATH)

MACRO(WRITE_CUSTOM_INSTALL_FILES)
  FILE(WRITE "${PROJECT_BINARY_DIR}/CustomInstall.cmake" "")
  SET_TARGET_PROPERTIES(CustomInstall PROPERTIES 
    POST_INSTALL_SCRIPT "${PROJECT_BINARY_DIR}/CustomInstall.cmake")
ENDMACRO(WRITE_CUSTOM_INSTALL_FILES)

####################################

INSTALL_AT_ABSOLUTE_PATH("${CMAKE_ROOT}/Modules" "${WrapITK_BINARY_DIR}/InstallOnly/FindWrapITK.cmake")