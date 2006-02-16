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

OPTION(INSTALL_WRAP_ITK_COMPATIBILITY "Install FindWrapITK.cmake and WrapITK.pth (so cmake and python can find WrapITK) as part of the standard installation process. This requires admin privileges. These files can be separately installed by making the install_wrapitk_compatibility target. " ON)

# Output directories.
SET(WRAP_ITK_SWIG_LIBRARY_DIR "${WrapITK_BINARY_DIR}/SWIG")
SET(WRAP_ITK_CONFIG_DIR "${WrapITK_SOURCE_DIR}/ConfigurationInputs")
SET(WRAP_ITK_CMAKE_DIR "${WrapITK_SOURCE_DIR}")
SET(WRAP_ITK_JAVA_DIR "${WrapITK_BINARY_DIR}/Java")
SET (LIBRARY_OUTPUT_PATH ${WrapITK_BINARY_DIR}/bin CACHE INTERNAL "Single output directory for building all libraries.")
SET (EXECUTABLE_OUTPUT_PATH ${WrapITK_BINARY_DIR}/bin CACHE INTERNAL "Single output directory for building all executables.")
MARK_AS_ADVANCED(LIBRARY_OUTPUT_PATH EXECUTABLE_OUTPUT_PATH)
SET(CXX_TEST_PATH ${EXECUTABLE_OUTPUT_PATH})

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

MACRO(INSTALL_AT_ABSOLUTE_PATH target path)
  # USAGE: 
  # INSTALL_AT_ABSOLUTE_PATH(custom-install-target "/path/to/install" "/path/to/file1" ... "path/to/fileN")
  
  SET(install_file_name "${PROJECT_BINARY_DIR}/${target}.cmake")
    
  FOREACH(file ${ARGN})
    GET_FILENAME_COMPONENT(filename "${file}" NAME)
    STRING(REGEX REPLACE "/$" "" stripped_path "${path}")
    FILE(APPEND "${install_file_name}" 
     "MESSAGE(STATUS \"Installing ${stripped_path}/${filename}\")\n")
    FILE(APPEND "${install_file_name}" 
     "FILE(INSTALL DESTINATION \"${path}\" TYPE FILE FILES \"${file}\")\n")
  ENDFOREACH(file)
ENDMACRO(INSTALL_AT_ABSOLUTE_PATH)
####################################

# Add a custom target to drive installation of the WrapITK-compatibility files
SET(install_file_name "${PROJECT_BINARY_DIR}/install_wrapitk_compatibility.cmake")
IF(INSTALL_WRAP_ITK_COMPATIBILITY)
  # if we should by default install the files, make a custom target that will
  # always be built, and run the install script at install time
  FILE(WRITE "${install_file_name}" "MESSAGE(STATUS \"Installing WrapITK compatibility files. Requires admin priviliges: turn off INSTALL_WRAP_ITK_COMPATIBILITY in cmake to disable.\")\n")
  ADD_CUSTOM_TARGET(install_wrapitk_compatibility ALL)
  SET_TARGET_PROPERTIES(install_wrapitk_compatibility PROPERTIES 
    POST_INSTALL_SCRIPT "${install_file_name}")
ELSE(INSTALL_WRAP_ITK_COMPATIBILITY)
  # otherwise, add a target that will install the files only when that target is
  # manually built.
  ADD_CUSTOM_TARGET(install_wrapitk_compatibility)
  FILE(WRITE "${install_file_name}" "MESSAGE(STATUS \"Installing WrapITK compatibility files. Requires admin priviliges.\")\n")
  ADD_CUSTOM_COMMAND(TARGET install_wrapitk_compatibility
    PRE_BUILD
    COMMAND ${CMAKE_COMMAND}
    ARGS -P "${install_file_name}"
    COMMENT "Manual installation of FindWrapITK.cmake and WrapITK.pth")
ENDIF(INSTALL_WRAP_ITK_COMPATIBILITY)

INSTALL_AT_ABSOLUTE_PATH(install_wrapitk_compatibility "${CMAKE_ROOT}/Modules" "${WrapITK_BINARY_DIR}/InstallOnly/FindWrapITK.cmake")