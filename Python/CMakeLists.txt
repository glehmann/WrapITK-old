# Configure the path-dependent itkbase.py

SET(WRAP_ITK_DATA_ROOT "${WrapITK_BINARY_DIR}/Data")
SET(WRAP_ITK_TEST_ROOT "${WrapITK_BINARY_DIR}/Testing")
IF(CMAKE_CONFIGURATION_TYPES)
  FOREACH(config ${CMAKE_CONFIGURATION_TYPES})
    SET(WRAP_ITK_PACKAGE_DIR "${LIBRARY_OUTPUT_PATH}/${config}")
    CONFIGURE_FILE("${CMAKE_CURRENT_SOURCE_DIR}/itkbase.py.in"
                   "${CMAKE_CURRENT_BINARY_DIR}/${config}/itkbase.py"
                   @ONLY IMMEDIATE)
  ENDFOREACH(config)
ELSE(CMAKE_CONFIGURATION_TYPES)
  SET(WRAP_ITK_PACKAGE_DIR "${LIBRARY_OUTPUT_PATH}")
  CONFIGURE_FILE("${CMAKE_CURRENT_SOURCE_DIR}/itkbase.py.in"
                 "${CMAKE_CURRENT_BINARY_DIR}/itkbase.py"
                 @ONLY IMMEDIATE)
ENDIF(CMAKE_CONFIGURATION_TYPES)

# Handle out-of-source builds correctly.
#
#  1. Create a list of Python files to be installed/copied.
#  2. Copy them to BINARY_DIR if it is different from SOURCE_DIR.
#
# *** Step 1 has to be done carefully to avoid missing out files ***
ADD_CUSTOM_TARGET(copy_python_files ALL)

# Now create a list of Python files.
# WrapITK/Python/*.py
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
  )
# Done listing files.

# Now copy these files if necessary.
SET(WRAP_ITK_PYTHON_FILES)

IF ("${WrapITK_BINARY_DIR}" MATCHES "^${WrapITK_SOURCE_DIR}$")
  # In source build -- no need to copy Python files.
ELSE ("${WrapITK_BINARY_DIR}" MATCHES "^${WrapITK_SOURCE_DIR}$")
  IF(CMAKE_CONFIGURATION_TYPES)
    FOREACH(file ${ITK_PYTHON_FILES})
      SET(src "${CMAKE_CURRENT_SOURCE_DIR}/${file}.py")
      SET(tgt "${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_CFG_INTDIR}/${file}.py")
      SET(WRAP_ITK_PYTHON_FILES ${WRAP_ITK_PYTHON_FILES} ${tgt})
      ADD_CUSTOM_COMMAND(SOURCE ${src}
        COMMAND ${CMAKE_COMMAND}
        ARGS -E copy ${src} ${tgt}
        OUTPUTS ${tgt}
        TARGET copy_python_files
        COMMENT "source copy")
    ENDFOREACH(file)
  ELSE(CMAKE_CONFIGURATION_TYPES)
    FOREACH(file ${ITK_PYTHON_FILES})
      SET(src "${CMAKE_CURRENT_SOURCE_DIR}/${file}.py")
      SET(tgt "${CMAKE_CURRENT_BINARY_DIR}/${file}.py")
      SET(WRAP_ITK_PYTHON_FILES ${WRAP_ITK_PYTHON_FILES} ${tgt})
      ADD_CUSTOM_COMMAND(SOURCE ${src}
        COMMAND ${CMAKE_COMMAND}
        ARGS -E copy ${src} ${tgt}
        OUTPUTS ${tgt}
        TARGET copy_python_files
        COMMENT "source copy")
    ENDFOREACH(file)
  ENDIF(CMAKE_CONFIGURATION_TYPES)
ENDIF ("${WrapITK_BINARY_DIR}" MATCHES "^${WrapITK_SOURCE_DIR}$")

# driver command to make the copy happen.
ADD_CUSTOM_COMMAND(
  SOURCE copy_python_files
  DEPENDS ${WRAP_ITK_PYTHON_FILES}
  TARGET copy_python_files
  )

# Configure the custom python pth files
SET(CONFIG_WRAP_ITK_PYTHON_DIR "${CMAKE_CURRENT_BINARY_DIR}")
CONFIGURE_FILE("${CMAKE_CURRENT_SOURCE_DIR}/WrapITK.pth.in"
             "${CMAKE_CURRENT_BINARY_DIR}/WrapITK.pth"
             @ONLY IMMEDIATE)
             
SET(CONFIG_WRAP_ITK_PYTHON_DIR "${WRAP_ITK_INSTALL_LOCATION}/Python")
CONFIGURE_FILE("${CMAKE_CURRENT_SOURCE_DIR}/WrapITK.pth.in"
             "${CMAKE_CURRENT_BINARY_DIR}/InstallOnly/WrapITK.pth"
             @ONLY IMMEDIATE)

IF(PYTHON_EXECUTABLE)
  EXEC_PROGRAM("${PYTHON_EXECUTABLE}"
    ARGS "-c 'try:\n  import distutils.sysconfig; print distutils.sysconfig.get_python_lib()\nexcept: pass\n'"
    OUTPUT_VARIABLE py_spp
  )
ENDIF(PYTHON_EXECUTABLE)
SET(PY_SITE_PACKAGES_PATH "${py_spp}" CACHE PATH "Python site-packages directory to install a .pth file pointing at WrapITK Python modules.")
MARK_AS_ADVANCED(PY_SITE_PACKAGES_PATH)
IF(PY_SITE_PACKAGES_PATH)
  # INTSTALL doesn't work with absolute paths... can't install yet.
  # INSTALL_FILES("${PY_SITE_PACKAGES_PATH}" FILES "${CMAKE_CURRENT_BINARY_DIR}/InstallOnly/WrapITK.pth")
ENDIF(PY_SITE_PACKAGES_PATH)

# Install the package python files.
FOREACH(file ${ITK_PYTHON_FILES})
  INSTALL_FILES("${WRAP_ITK_INSTALL_LOCATION}/Python" FILES
    "${CMAKE_CURRENT_BINARY_DIR}/${file}.py")
ENDFOREACH(file)

SET(WRAP_ITK_PACKAGE_DIR "${CMAKE_INSTALL_PREFIX}${WRAP_ITK_INSTALL_LOCATION}/Python-SWIG")
SET(WRAP_ITK_DATA_ROOT "${CMAKE_INSTALL_PREFIX}${WRAP_ITK_INSTALL_LOCATION}/Data")
SET(WRAP_ITK_TEST_ROOT "<NO_DEFAULT>")
CONFIGURE_FILE("${CMAKE_CURRENT_SOURCE_DIR}/itkbase.py.in"
               "${CMAKE_CURRENT_BINARY_DIR}/InstallOnly/itkbase.py"
               @ONLY IMMEDIATE)
INSTALL_FILES("${WRAP_ITK_INSTALL_LOCATION}/Python" FILES
  "${CMAKE_CURRENT_BINARY_DIR}/InstallOnly/itkbase.py")
