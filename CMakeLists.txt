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

#-----------------------------------------------------------------------------
MACRO(ITK_CONFIG_PACKAGE BINARY_DIR)
  IF(WRAP_ITK_TCL)
    # tcl
    ITK_CONFIG_TCL_PACKAGE(${BINARY_DIR})
  ENDIF(WRAP_ITK_TCL)
  IF(WRAP_ITK_PERL)
    # perl
    ITK_CONFIG_PERL_PACKAGE(${BINARY_DIR})
  ENDIF(WRAP_ITK_PERL)
  IF(WRAP_ITK_PYTHON)
    # python
    ITK_CONFIG_PYTHON_PACKAGE(${BINARY_DIR})
  ENDIF(WRAP_ITK_PYTHON)
  IF(WRAP_ITK_JAVA)
    # java
    ITK_CONFIG_JAVA_PACKAGE(${BINARY_DIR})
  ENDIF(WRAP_ITK_JAVA)
ENDMACRO(ITK_CONFIG_PACKAGE)

###############################################################################
# Config Project dependant :-(
###############################################################################
MACRO(ITK_CONFIG_TCL_PACKAGE BINARY_DIR)
  # Configure pkgIndex.tcl for the build tree.
  SET(WRAP_ITK_DATA_ROOT "${ITK_DATA_ROOT}")
  SET(WRAP_ITK_TEST_ROOT "${WrapITK_BINARY_DIR}/Testing")
  SET(WRAP_ITK_SCRIPT_DIR "${WrapITK_SOURCE_DIR}/Tcl")

  IF(CMAKE_CONFIGURATION_TYPES)
    FOREACH(config ${CMAKE_CONFIGURATION_TYPES})
      SET(WRAP_ITK_PACKAGE_DIR "${ITK_CSWIG_PACKAGE_DIR_BUILD}/${config}")
      CONFIGURE_FILE("${WrapITK_SOURCE_DIR}/Tcl/pkgIndex.tcl.in"
                     "${BINARY_DIR}/Tcl/${config}/pkgIndex.tcl"
                     @ONLY IMMEDIATE)
    ENDFOREACH(config)
  ELSE(CMAKE_CONFIGURATION_TYPES)
    SET(WRAP_ITK_PACKAGE_DIR "${ITK_CSWIG_PACKAGE_DIR_BUILD}")
    CONFIGURE_FILE("${WrapITK_SOURCE_DIR}/Tcl/pkgIndex.tcl.in"
                   "${BINARY_DIR}/Tcl/pkgIndex.tcl"
                   @ONLY IMMEDIATE)
  ENDIF(CMAKE_CONFIGURATION_TYPES)

  # Configure pkgIndex.tcl for the install tree.
  SET(WRAP_ITK_SCRIPT_DIR "[file dirname [info script]]")
  SET(WRAP_ITK_PACKAGE_DIR "[file dirname [file dirname [info script]]]")
  SET(WRAP_ITK_DATA_ROOT "[file dirname [file dirname [info script]]]/Data")
  SET(WRAP_ITK_TEST_ROOT "<NO_DEFAULT>")
  CONFIGURE_FILE("${WrapITK_SOURCE_DIR}/Tcl/pkgIndex.tcl.in"
                 "${BINARY_DIR}/Tcl/InstallOnly/Hide/pkgIndex.tcl"
                 IMMEDIATE @ONLY)
  INSTALL_FILES(/lib/InsightToolkit/tcl FILES
                "${WrapITK_BINARY_DIR}/Tcl/InstallOnly/Hide/pkgIndex.tcl")

  SUBDIRS(Tcl)
ENDMACRO(ITK_CONFIG_TCL_PACKAGE)

MACRO(ITK_CONFIG_PERL_PACKAGE BINARY_DIR)
ENDMACRO(ITK_CONFIG_PERL_PACKAGE)

###############################################################################
# Config Project dependant :-(
###############################################################################
MACRO(ITK_CONFIG_PYTHON_PACKAGE BINARY_DIR)
  SET(WRAP_ITK_DATA_ROOT "'${ITK_DATA_ROOT}'")
  SET(WRAP_ITK_TEST_ROOT "'${WrapITK_BINARY_DIR}/Testing'")
  IF(CMAKE_CONFIGURATION_TYPES)
    FOREACH(config ${CMAKE_CONFIGURATION_TYPES})
      SET(WRAP_ITK_PACKAGE_DIR "'${LIBRARY_OUTPUT_PATH}/${config}'")
      CONFIGURE_FILE("${WrapITK_SOURCE_DIR}/Python/itkbase.py.in"
                     "${BINARY_DIR}/Python/${config}/itkbase.py"
                     @ONLY IMMEDIATE)
    ENDFOREACH(config)
  ELSE(CMAKE_CONFIGURATION_TYPES)
    SET(WRAP_ITK_PACKAGE_DIR "'${LIBRARY_OUTPUT_PATH}'")
    CONFIGURE_FILE("${WrapITK_SOURCE_DIR}/Python/itkbase.py.in"
                   "${BINARY_DIR}/Python/itkbase.py"
                   @ONLY IMMEDIATE)
  ENDIF(CMAKE_CONFIGURATION_TYPES)

  # Handle out-of-source builds correctly.
  #
  #  1. Create a list of Python files to be installed/copied.
  #  2. Copy them to BINARY_DIR if it is different from SOURCE_DIR.
  #  3. Use Python's compileall to compile the copied files.
  #
  # *** Step 1 has to be done carefully to avoid missing out files ***
  IF(PYTHON_EXECUTABLE)
    ADD_CUSTOM_TARGET(itkpython_pyc ALL echo "...")

    # Make the necessary directories.
    MAKE_DIRECTORY(${WrapITK_BINARY_DIR}/Python)

    # Now create a list of Python files.
    SET(ITK_PYTHON_FILES)

    # Wrapping/CSwig/Python/*.py
    SET(ITK_PYTHON_FILES
      ${ITK_PYTHON_FILES}
      InsightToolkit
      itkspatialobject
      itkalgorithms
      itkbasicfilters
      itkcommon
      itkio
      itktesting
      itkdata
      itknumerics
      vxlnumerics

      itk
      itkPyTemplate
      itktypes

      itkbasicfiltersaPy
      itkbasicfiltersbPy
      itkbasicfilterscPy
      itkcommonaPy
      itkcommonbPy
      itkioPy
      itknumericsPy
      itkspatialobjectPy
      itkalgorithmsPy
      )
    # Done listing files.

    # Now copy these files if necessary.
    SET(ITK_PYTHON_SOURCE_FILES)
    SET(ITK_PYTHON_OUTPUT_FILES)

    IF(CMAKE_CONFIGURATION_TYPES)
      FOREACH(file ${ITK_PYTHON_FILES})
        SET(src "${WrapITK_BINARY_DIR}/Python/${CMAKE_CFG_INTDIR}/${file}.py")
        SET(ITK_PYTHON_SOURCE_FILES ${ITK_PYTHON_SOURCE_FILES} ${src})
      ENDFOREACH(file)
    ELSE(CMAKE_CONFIGURATION_TYPES)
      FOREACH(file ${ITK_PYTHON_FILES})
        SET(src "${WrapITK_BINARY_DIR}/Python/${file}.py")
        SET(ITK_PYTHON_SOURCE_FILES ${ITK_PYTHON_SOURCE_FILES} ${src})
      ENDFOREACH(file)
    ENDIF(CMAKE_CONFIGURATION_TYPES)

    IF ("${WrapITK_BINARY_DIR}" MATCHES "^${WrapITK_SOURCE_DIR}$")
      #MESSAGE("In source build -- no need to copy Python files.")
    ELSE ("${WrapITK_BINARY_DIR}" MATCHES "^${WrapITK_SOURCE_DIR}$")
      IF(CMAKE_CONFIGURATION_TYPES)
        FOREACH(file ${ITK_PYTHON_FILES})
          IF(EXISTS ${WrapITK_SOURCE_DIR}/Python/${file}.py)
            SET(src "${WrapITK_SOURCE_DIR}/Python/${file}.py")
          ELSE(EXISTS ${WrapITK_SOURCE_DIR}/Python/${file}.py)
            SET(src "${WrapITK_BINARY_DIR}/Python/${file}.py")
          ENDIF(EXISTS ${WrapITK_SOURCE_DIR}/Python/${file}.py)
          SET(tgt "${WrapITK_BINARY_DIR}/Python/${CMAKE_CFG_INTDIR}/${file}.py")

          IF("${src}" MATCHES "${tgt}")
            #MESSAGE("no need to copy Python file ${src}.")
          ELSE("${src}" MATCHES "${tgt}")
            ADD_CUSTOM_COMMAND(SOURCE ${src}
              COMMAND ${CMAKE_COMMAND}
              ARGS -E copy ${src} ${tgt}
              OUTPUTS ${tgt}
              TARGET itkpython_pyc
              COMMENT "source copy")
          ENDIF("${src}" MATCHES "${tgt}")
        ENDFOREACH(file)
      ELSE(CMAKE_CONFIGURATION_TYPES)
        FOREACH(file ${ITK_PYTHON_FILES})
          IF(EXISTS ${WrapITK_SOURCE_DIR}/Python/${file}.py)
            SET(src "${WrapITK_SOURCE_DIR}/Python/${file}.py")
          ELSE(EXISTS ${WrapITK_SOURCE_DIR}/Python/${file}.py)
            SET(src "${WrapITK_BINARY_DIR}/Python/${file}.py")
          ENDIF(EXISTS ${WrapITK_SOURCE_DIR}/Python/${file}.py)
          SET(tgt "${WrapITK_BINARY_DIR}/Python/${file}.py")

          IF("${src}" MATCHES "${tgt}")
            #MESSAGE("no need to copy Python file ${src}.")
          ELSE("${src}" MATCHES "${tgt}")
            ADD_CUSTOM_COMMAND(SOURCE ${src}
              COMMAND ${CMAKE_COMMAND}
              ARGS -E copy ${src} ${tgt}
              OUTPUTS ${tgt}
              TARGET itkpython_pyc
              COMMENT "source copy")
          ENDIF("${src}" MATCHES "${tgt}")
        ENDFOREACH(file)
      ENDIF(CMAKE_CONFIGURATION_TYPES)
    ENDIF ("${WrapITK_BINARY_DIR}" MATCHES "^${WrapITK_SOURCE_DIR}$")

    # Byte compile the Python files.
    WRITE_FILE(${WrapITK_BINARY_DIR}/Python/compile_all_itk
          "import compileall\n"
          "compileall.compile_dir('${WrapITK_BINARY_DIR}/Python')\n"
          "file = open('${WrapITK_BINARY_DIR}/Python/itk_compile_complete', 'w')\n"
          "file.write('Done')\n")

    ADD_CUSTOM_COMMAND(
      SOURCE ${WrapITK_BINARY_DIR}/Python/compile_all_itk
      COMMAND ${PYTHON_EXECUTABLE}
      ARGS ${WrapITK_BINARY_DIR}/Python/compile_all_itk
      DEPENDS ${ITK_PYTHON_SOURCE_FILES}
      OUTPUTS "${WrapITK_BINARY_DIR}/Python/itk_compile_complete"
      TARGET itkpython_pyc
      )

    ADD_CUSTOM_COMMAND(
      SOURCE itkpython_pyc
      DEPENDS "${WrapITK_BINARY_DIR}/Python/itk_compile_complete"
      TARGET itkpython_pyc
      )
  ENDIF(PYTHON_EXECUTABLE)

  SET(ITK_OLD_CMAKE_INSTALL 0)
  IF(${CMAKE_MAJOR_VERSION} LESS 2)
    IF(${CMAKE_MINOR_VERSION} LESS 9)
      SET(ITK_OLD_CMAKE_INSTALL 1)
    ENDIF(${CMAKE_MINOR_VERSION} LESS 9)
  ENDIF(${CMAKE_MAJOR_VERSION} LESS 2)

  IF(ITK_OLD_CMAKE_INSTALL)
    IF(UNIX)
      # Ultra-hackery to install the generated python files.  This is not
      # officially supported by cmake and abuses the implementation of
      # make install.  Good luck figuring out how this works.
      CONFIGURE_FILE(
        "${WrapITK_SOURCE_DIR}/pythonfiles.sh.in"
        "${BINARY_DIR}/pythonfiles.sh" @ONLY IMMEDIATE)
      EXEC_PROGRAM(chmod ${BINARY_DIR} ARGS 755 pythonfiles.sh
        OUTPUT_VARIABLE ITK_EXEC_PLEASE_BE_QUIET)
      INSTALL_FILES(/lib/InsightToolkit FILES "`${BINARY_DIR}/pythonfiles.sh`")
    ENDIF(UNIX)
  ELSE(ITK_OLD_CMAKE_INSTALL)
    CONFIGURE_FILE(
      "${WrapITK_SOURCE_DIR}/pythonfiles_install.cmake.in"
      "${BINARY_DIR}/pythonfiles_install.cmake"
      @ONLY IMMEDIATE)
    ADD_CUSTOM_TARGET(python_install)
    SET_TARGET_PROPERTIES(python_install PROPERTIES
      POST_INSTALL_SCRIPT "${BINARY_DIR}/pythonfiles_install.cmake")
  ENDIF(ITK_OLD_CMAKE_INSTALL)

  # Install the package python files.
  FOREACH(file ${ITK_PYTHON_FILES})
    INSTALL_FILES(/lib/InsightToolkit/python FILES
      "${WrapITK_BINARY_DIR}/Python/${file}.py")
  ENDFOREACH(file)

  SET(WRAP_ITK_PACKAGE_DIR "os.path.dirname(selfpath)")
  SET(WRAP_ITK_DATA_ROOT "os.path.join(os.path.dirname(selfpath),'Data')")
  SET(WRAP_ITK_TEST_ROOT "'<NO_DEFAULT>'")
  CONFIGURE_FILE("${WrapITK_SOURCE_DIR}/Python/itkbase.py.in"
                 "${BINARY_DIR}/Python/InstallOnly/itkbase.py"
                 @ONLY IMMEDIATE)
  INSTALL_FILES(/lib/InsightToolkit/python FILES
    "${WrapITK_BINARY_DIR}/Python/InstallOnly/itkbase.py")
ENDMACRO(ITK_CONFIG_PYTHON_PACKAGE)

###############################################################################
# Config Project dependant :-(
###############################################################################
MACRO(ITK_CONFIG_JAVA_PACKAGE BINARY_DIR)
  SUBDIRS(Java)
ENDMACRO(ITK_CONFIG_JAVA_PACKAGE)

#-----------------------------------------------------------------------------
ITK_CONFIG_PACKAGE(${WrapITK_BINARY_DIR})

###############################################################################
# Configure UseWrapITK.cmake and related files for external projects
###############################################################################

# First, configure for use directly from the build dir.
SET(CONFIG_SWIG_DIR "${WrapITK_SOURCE_DIR}")
SET(CONFIG_CONFIG_DIR "${WrapITK_SOURCE_DIR}")
SET(CONFIG_CMAKE_DIR "${WrapITK_SOURCE_DIR}")
SET(CONFIG_WRAP_ITK_LIBRARY_DIR "${LIBRARY_OUTPUT_PATH}")

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

# Second, configure for installed use.
# Nothing here yet... got to figure out where installed things go.

FOREACH(f
 itkConfigWrapping.cmake
 itk.swg
 wrap_ITK.cxx.in
 wrap_.cxx.in
 WrapITK.cmake
 WrapTypePrefix.cmake
 WrapTypeBase.cmake
 wrap_ITKLang.cxx.in
 WrapITKLang.cmake)
  INSTALL_FILES(/lib/InsightToolkit ${f})
ENDFOREACH(f)