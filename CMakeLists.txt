PROJECT(WrapITK)

FIND_PACKAGE(CableSwig)
SET(CMAKE_MODULE_PATH ${CableSwig_DIR}/SWIG/CMake)

IF(ITK_CSWIG_TCL)
  SET(ITK_INCLUDE_DIRS_SYSTEM ${ITK_INCLUDE_DIRS_SYSTEM} ${TCL_INCLUDE_PATH} ${TK_INCLUDE_PATH})
ENDIF(ITK_CSWIG_TCL)

IF(ITK_CSWIG_PYTHON)
  # Python include directory.
  SET(ITK_INCLUDE_DIRS_SYSTEM ${ITK_INCLUDE_DIRS_SYSTEM}
    ${PYTHON_INCLUDE_PATH})
ENDIF(ITK_CSWIG_PYTHON)

IF(ITK_CSWIG_JAVA)
  # Java include directories.
  SET(ITK_INCLUDE_DIRS_SYSTEM ${ITK_INCLUDE_DIRS_SYSTEM}
      ${JAVA_INCLUDE_PATH} ${JAVA_INCLUDE_PATH2} ${JAVA_AWT_INCLUDE_PATH})
ENDIF(ITK_CSWIG_JAVA)

# Choose an install location for the Java wrapper libraries.  This
# must be next to the ITKCommon shared library.
IF(WIN32)
  SET(ITK_INSTALL_JAVA_LIBS_DIR /bin)
ELSE(WIN32)
  SET(ITK_INSTALL_JAVA_LIBS_DIR /lib/InsightToolkit)
ENDIF(WIN32)

# We have found CableSwig.  Use the settings.
SET(CABLE_INDEX ${CableSwig_cableidx_EXE})
SET(CSWIG ${CableSwig_cswig_EXE})
SET(GCCXML ${CableSwig_gccxml_EXE})

SET(ITK_WRAP_NEEDS_DEPEND 1)
IF(${CMAKE_MAKE_PROGRAM} MATCHES make)
  SET(ITK_WRAP_NEEDS_DEPEND 0)
ENDIF(${CMAKE_MAKE_PROGRAM} MATCHES make)

SET(ITK_TOP ${ITK_SOURCE_DIR})

###############################################################################
# Config ITKWrap
###############################################################################

SET(ITK_KITS VXLNumerics CommonA CommonB Numerics
  BasicFiltersA BasicFiltersB BasicFiltersC IO
  SpatialObject Algorithms
  )
SUBDIRS(SwigRuntime ${ITK_KITS} Tests)

SET(ITK_CSWIG_PACKAGE_DIR_BUILD "${ITK_LIBRARY_PATH}")

#-----------------------------------------------------------------------------
MACRO(ITK_CONFIG_PACKAGE BINARY_DIR)
  IF(ITK_CSWIG_TCL)
    # tcl
    ITK_CONFIG_TCL_PACKAGE(${BINARY_DIR})
  ENDIF(ITK_CSWIG_TCL)
  IF(ITK_CSWIG_PERL)
    # perl
    ITK_CONFIG_PERL_PACKAGE(${BINARY_DIR})
  ENDIF(ITK_CSWIG_PERL)
  IF(ITK_CSWIG_PYTHON)
    # python
    ITK_CONFIG_PYTHON_PACKAGE(${BINARY_DIR})
  ENDIF(ITK_CSWIG_PYTHON)
  IF(ITK_CSWIG_JAVA)
    # java
    ITK_CONFIG_JAVA_PACKAGE(${BINARY_DIR})
  ENDIF(ITK_CSWIG_JAVA)
ENDMACRO(ITK_CONFIG_PACKAGE)

###############################################################################
# Config Project dependant :-(
###############################################################################
MACRO(ITK_CONFIG_TCL_PACKAGE BINARY_DIR)
  # Configure pkgIndex.tcl for the build tree.
  SET(ITK_CSWIG_DATA_ROOT "${ITK_DATA_ROOT}")
  SET(ITK_CSWIG_TEST_ROOT "${ITK_BINARY_DIR}/Testing")
  SET(ITK_CSWIG_SCRIPT_DIR "${ITK_SOURCE_DIR}/Wrapping/CSwig/Tcl")

  IF(CMAKE_CONFIGURATION_TYPES)
    FOREACH(config ${CMAKE_CONFIGURATION_TYPES})
      SET(ITK_CSWIG_PACKAGE_DIR "${ITK_CSWIG_PACKAGE_DIR_BUILD}/${config}")
      CONFIGURE_FILE("${ITK_SOURCE_DIR}/Wrapping/CSwig/Tcl/pkgIndex.tcl.in"
                     "${BINARY_DIR}/Tcl/${config}/pkgIndex.tcl"
                     @ONLY IMMEDIATE)
    ENDFOREACH(config)
  ELSE(CMAKE_CONFIGURATION_TYPES)
    SET(ITK_CSWIG_PACKAGE_DIR "${ITK_CSWIG_PACKAGE_DIR_BUILD}")
    CONFIGURE_FILE("${ITK_SOURCE_DIR}/Wrapping/CSwig/Tcl/pkgIndex.tcl.in"
                   "${BINARY_DIR}/Tcl/pkgIndex.tcl"
                   @ONLY IMMEDIATE)
  ENDIF(CMAKE_CONFIGURATION_TYPES)

  # Configure pkgIndex.tcl for the install tree.
  SET(ITK_CSWIG_SCRIPT_DIR "[file dirname [info script]]")
  SET(ITK_CSWIG_PACKAGE_DIR "[file dirname [file dirname [info script]]]")
  SET(ITK_CSWIG_DATA_ROOT "[file dirname [file dirname [info script]]]/Data")
  SET(ITK_CSWIG_TEST_ROOT "<NO_DEFAULT>")
  CONFIGURE_FILE("${ITK_SOURCE_DIR}/Wrapping/CSwig/Tcl/pkgIndex.tcl.in"
                 "${BINARY_DIR}/Tcl/InstallOnly/Hide/pkgIndex.tcl"
                 IMMEDIATE @ONLY)
  INSTALL_FILES(/lib/InsightToolkit/tcl FILES
                "${ITK_BINARY_DIR}/Wrapping/CSwig/Tcl/InstallOnly/Hide/pkgIndex.tcl")

  SUBDIRS(Tcl)
ENDMACRO(ITK_CONFIG_TCL_PACKAGE)

MACRO(ITK_CONFIG_PERL_PACKAGE BINARY_DIR)
ENDMACRO(ITK_CONFIG_PERL_PACKAGE)

###############################################################################
# Config Project dependant :-(
###############################################################################
MACRO(ITK_CONFIG_PYTHON_PACKAGE BINARY_DIR)
  SET(ITK_CSWIG_DATA_ROOT "'${ITK_DATA_ROOT}'")
  SET(ITK_CSWIG_TEST_ROOT "'${ITK_BINARY_DIR}/Testing'")
  IF(CMAKE_CONFIGURATION_TYPES)
    FOREACH(config ${CMAKE_CONFIGURATION_TYPES})
      SET(ITK_CSWIG_PACKAGE_DIR "'${ITK_CSWIG_PACKAGE_DIR_BUILD}/${config}'")
      CONFIGURE_FILE("${ITK_SOURCE_DIR}/Wrapping/CSwig/Python/itkbase.py.in"
                     "${BINARY_DIR}/Python/${config}/itkbase.py"
                     @ONLY IMMEDIATE)
    ENDFOREACH(config)
  ELSE(CMAKE_CONFIGURATION_TYPES)
    SET(ITK_CSWIG_PACKAGE_DIR "'${ITK_CSWIG_PACKAGE_DIR_BUILD}'")
    CONFIGURE_FILE("${ITK_SOURCE_DIR}/Wrapping/CSwig/Python/itkbase.py.in"
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
    # Deal with numarray package  Options
    SET(CMAKE_MODULE_PATH ${ITK_SOURCE_DIR}/CMake)
    OPTION(ITK_USE_PYTHON_NUMARRAY "Use the numarray python package" OFF)
    MARK_AS_ADVANCED(ITK_USE_PYTHON_NUMARRAY)
    IF( ITK_USE_PYTHON_NUMARRAY )
      FIND_PACKAGE( NUMARRAY )
    ENDIF( ITK_USE_PYTHON_NUMARRAY )

    IF(PYTHON_NUMARRAY_FOUND)
      INCLUDE_DIRECTORIES( ${PYTHON_NUMARRAY_INCLUDE_DIR} )
      SET(SWIG_INC ${SWIG_INC} ${PYTHON_NUMARRAY_INCLUDE_DIR})
    ENDIF(PYTHON_NUMARRAY_FOUND)

    ADD_CUSTOM_TARGET(itkpython_pyc ALL echo "...")

    # Make the necessary directories.
    MAKE_DIRECTORY(${ITK_BINARY_DIR}/Wrapping/CSwig/Python)

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
        SET(src "${ITK_BINARY_DIR}/Wrapping/CSwig/Python/${CMAKE_CFG_INTDIR}/${file}.py")
        SET(ITK_PYTHON_SOURCE_FILES ${ITK_PYTHON_SOURCE_FILES} ${src})
      ENDFOREACH(file)
    ELSE(CMAKE_CONFIGURATION_TYPES)
      FOREACH(file ${ITK_PYTHON_FILES})
        SET(src "${ITK_BINARY_DIR}/Wrapping/CSwig/Python/${file}.py")
        SET(ITK_PYTHON_SOURCE_FILES ${ITK_PYTHON_SOURCE_FILES} ${src})
      ENDFOREACH(file)
    ENDIF(CMAKE_CONFIGURATION_TYPES)

    IF ("${ITK_BINARY_DIR}" MATCHES "^${ITK_SOURCE_DIR}$")
      #MESSAGE("In source build -- no need to copy Python files.")
    ELSE ("${ITK_BINARY_DIR}" MATCHES "^${ITK_SOURCE_DIR}$")
      IF(CMAKE_CONFIGURATION_TYPES)
        FOREACH(file ${ITK_PYTHON_FILES})
          IF(EXISTS ${ITK_SOURCE_DIR}/Wrapping/CSwig/Python/${file}.py)
            SET(src "${ITK_SOURCE_DIR}/Wrapping/CSwig/Python/${file}.py")
          ELSE(EXISTS ${ITK_SOURCE_DIR}/Wrapping/CSwig/Python/${file}.py)
            SET(src "${ITK_BINARY_DIR}/Wrapping/CSwig/Python/${file}.py")
          ENDIF(EXISTS ${ITK_SOURCE_DIR}/Wrapping/CSwig/Python/${file}.py)
          SET(tgt "${ITK_BINARY_DIR}/Wrapping/CSwig/Python/${CMAKE_CFG_INTDIR}/${file}.py")

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
          IF(EXISTS ${ITK_SOURCE_DIR}/Wrapping/CSwig/Python/${file}.py)
            SET(src "${ITK_SOURCE_DIR}/Wrapping/CSwig/Python/${file}.py")
          ELSE(EXISTS ${ITK_SOURCE_DIR}/Wrapping/CSwig/Python/${file}.py)
            SET(src "${ITK_BINARY_DIR}/Wrapping/CSwig/Python/${file}.py")
          ENDIF(EXISTS ${ITK_SOURCE_DIR}/Wrapping/CSwig/Python/${file}.py)
          SET(tgt "${ITK_BINARY_DIR}/Wrapping/CSwig/Python/${file}.py")

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
    ENDIF ("${ITK_BINARY_DIR}" MATCHES "^${ITK_SOURCE_DIR}$")

    # Byte compile the Python files.
    WRITE_FILE(${ITK_BINARY_DIR}/Wrapping/CSwig/Python/compile_all_itk
          "import compileall\n"
          "compileall.compile_dir('${ITK_BINARY_DIR}/Wrapping/CSwig/Python')\n"
          "file = open('${ITK_BINARY_DIR}/Wrapping/CSwig/Python/itk_compile_complete', 'w')\n"
          "file.write('Done')\n")

    ADD_CUSTOM_COMMAND(
      SOURCE ${ITK_BINARY_DIR}/Wrapping/CSwig/Python/compile_all_itk
      COMMAND ${PYTHON_EXECUTABLE}
      ARGS ${ITK_BINARY_DIR}/Wrapping/CSwig/Python/compile_all_itk
      DEPENDS ${ITK_PYTHON_SOURCE_FILES}
      OUTPUTS "${ITK_BINARY_DIR}/Wrapping/CSwig/Python/itk_compile_complete"
      TARGET itkpython_pyc
      )

    ADD_CUSTOM_COMMAND(
      SOURCE itkpython_pyc
      DEPENDS "${ITK_BINARY_DIR}/Wrapping/CSwig/Python/itk_compile_complete"
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
        "${ITK_SOURCE_DIR}/Wrapping/CSwig/pythonfiles.sh.in"
        "${BINARY_DIR}/pythonfiles.sh" @ONLY IMMEDIATE)
      EXEC_PROGRAM(chmod ${BINARY_DIR} ARGS 755 pythonfiles.sh
        OUTPUT_VARIABLE ITK_EXEC_PLEASE_BE_QUIET)
      INSTALL_FILES(/lib/InsightToolkit FILES "`${BINARY_DIR}/pythonfiles.sh`")
    ENDIF(UNIX)
  ELSE(ITK_OLD_CMAKE_INSTALL)
    CONFIGURE_FILE(
      "${ITK_SOURCE_DIR}/Wrapping/CSwig/pythonfiles_install.cmake.in"
      "${BINARY_DIR}/pythonfiles_install.cmake"
      @ONLY IMMEDIATE)
    ADD_CUSTOM_TARGET(python_install)
    SET_TARGET_PROPERTIES(python_install PROPERTIES
      POST_INSTALL_SCRIPT "${BINARY_DIR}/pythonfiles_install.cmake")
  ENDIF(ITK_OLD_CMAKE_INSTALL)

  # Install the package python files.
  FOREACH(file ${ITK_PYTHON_FILES})
    INSTALL_FILES(/lib/InsightToolkit/python FILES
      "${ITK_BINARY_DIR}/Wrapping/CSwig/Python/${file}.py")
  ENDFOREACH(file)

  SET(ITK_CSWIG_PACKAGE_DIR "os.path.dirname(selfpath)")
  SET(ITK_CSWIG_DATA_ROOT "os.path.join(os.path.dirname(selfpath),'Data')")
  SET(ITK_CSWIG_TEST_ROOT "'<NO_DEFAULT>'")
  CONFIGURE_FILE("${ITK_SOURCE_DIR}/Wrapping/CSwig/Python/itkbase.py.in"
                 "${BINARY_DIR}/Python/InstallOnly/itkbase.py"
                 @ONLY IMMEDIATE)
  INSTALL_FILES(/lib/InsightToolkit/python FILES
    "${ITK_BINARY_DIR}/Wrapping/CSwig/Python/InstallOnly/itkbase.py")
ENDMACRO(ITK_CONFIG_PYTHON_PACKAGE)

###############################################################################
# Config Project dependant :-(
###############################################################################
MACRO(ITK_CONFIG_JAVA_PACKAGE BINARY_DIR)
  SUBDIRS(Java)
ENDMACRO(ITK_CONFIG_JAVA_PACKAGE)

#-----------------------------------------------------------------------------
INCLUDE(itkConfigWrapping.cmake)
INCLUDE(WrapTypeBase.cmake)
INCLUDE(WrapITK.cmake)
INCLUDE(WrapTypePrefix.cmake)

#-----------------------------------------------------------------------------
ITK_CONFIG_PACKAGE(${WrapITK_BINARY_DIR})


