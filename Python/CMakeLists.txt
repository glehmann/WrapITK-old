###############################################################################
# Add the ITKPythonSupport library which contains the itkPyCommand class.

BEGIN_WRAPPER_LIBRARY("ITKPythonSupport")

SET(WRAPPER_LIBRARY_DEPENDS ITKCommonA)
SET(WRAPPER_LIBRARY_LINK_LIBRARIES ITKCommon)
# Need to include the current dir because the compiler needs to find itkPyCommand.h
INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR})
SET(WRAPPER_LIBRARY_CXX_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/itkPyCommand.cxx") 

WRAPPER_LIBRARY_CREATE_WRAP_FILES()
WRAPPER_LIBRARY_CREATE_LIBRARY()


###############################################################################
# Configure the path-dependent itkConfig.py

SET(CONFIG_WRAP_ITK_DATA_ROOT "${WrapITK_BINARY_DIR}/Data")
SET(CONFIG_WRAP_ITK_TEST_ROOT "${WrapITK_BINARY_DIR}/Testing")
# SWIG interface files aren't config-dependent
SET(CONFIG_PYTHON_CONFIGPY_DIR "${WrapITK_BINARY_DIR}/Python/Configuration")

IF(CMAKE_CONFIGURATION_TYPES)
  FOREACH(config ${CMAKE_CONFIGURATION_TYPES})
    # SWIG-generated libs and *.py files are sent to ${config} subdir
    SET(CONFIG_PYTHON_SWIGPY_DIR "${LIBRARY_OUTPUT_PATH}/${config}")
    SET(CONFIG_PYTHON_SWIGLIB_DIR "${LIBRARY_OUTPUT_PATH}/${config}")
    CONFIGURE_FILE("${CMAKE_CURRENT_SOURCE_DIR}/itkConfig.py.in"
                   "${WrapITK_BINARY_DIR}/Python/${config}/itkConfig.py"
                   @ONLY IMMEDIATE)
  ENDFOREACH(config)
ELSE(CMAKE_CONFIGURATION_TYPES)
  SET(CONFIG_PYTHON_SWIGPY_DIR "${LIBRARY_OUTPUT_PATH}")
  SET(CONFIG_PYTHON_SWIGLIB_DIR "${LIBRARY_OUTPUT_PATH}")
  CONFIGURE_FILE("${CMAKE_CURRENT_SOURCE_DIR}/itkConfig.py.in"
                 "${WrapITK_BINARY_DIR}/Python/itkConfig.py"
                 @ONLY IMMEDIATE)
ENDIF(CMAKE_CONFIGURATION_TYPES)

SET(CONFIG_WRAP_ITK_DATA_ROOT "${CMAKE_INSTALL_PREFIX}${WRAP_ITK_INSTALL_LOCATION}/Data")
SET(CONFIG_WRAP_ITK_TEST_ROOT "<NO DEFAULT>")
SET(CONFIG_PYTHON_SWIGLIB_DIR "${CMAKE_INSTALL_PREFIX}${WRAP_ITK_INSTALL_LOCATION}/Python-SWIG")
SET(CONFIG_PYTHON_SWIGPY_DIR "${CMAKE_INSTALL_PREFIX}${WRAP_ITK_INSTALL_LOCATION}/Python-SWIG")
SET(CONFIG_PYTHON_CONFIGPY_DIR "${CMAKE_INSTALL_PREFIX}${WRAP_ITK_INSTALL_LOCATION}/Python/Configuration")

CONFIGURE_FILE("${CMAKE_CURRENT_SOURCE_DIR}/itkConfig.py.in"
               "${WrapITK_BINARY_DIR}/Python/InstallOnly/itkConfig.py"
              @ONLY IMMEDIATE)

INSTALL_FILES("${WRAP_ITK_INSTALL_LOCATION}/Python" FILES 
              "${WrapITK_BINARY_DIR}/Python/InstallOnly/itkConfig.py")


###############################################################################
# Copy python files for out-of-source builds, and set up install of same.

# Create a list of Python files.
# WrapITK/Python/*.py
SET(ITK_PYTHON_FILES
  itk
  itkBase
  itkPyTemplate
  itkTypes
  )
# Done listing files.

# Now copy these files if necessary.
SET(WRAP_ITK_PYTHON_FILES)

IF ("${WrapITK_BINARY_DIR}" MATCHES "^${WrapITK_SOURCE_DIR}$")
  # In source build -- no need to copy Python file. Do need to set up the install.
    FOREACH(file ${ITK_PYTHON_FILES})
    SET(install_tgt "${CMAKE_CURRENT_SOURCE_DIR}/${file}.py")
    SET(WRAP_ITK_PYTHON_FILES ${WRAP_ITK_PYTHON_FILES} "${install_tgt}")
  ENDFOREACH(file)
ELSE ("${WrapITK_BINARY_DIR}" MATCHES "^${WrapITK_SOURCE_DIR}$")
  ADD_CUSTOM_TARGET(copy_python_files ALL)
  
  FOREACH(file ${ITK_PYTHON_FILES})
    SET(src "${CMAKE_CURRENT_SOURCE_DIR}/${file}.py")
    # recall that WRAP_ITK_INTDIR expands to nothing if no config types are set,
    # or to "CMAKE_CONFIG_INTDIR/" if there are such.
    SET(tgt "${CMAKE_CURRENT_BINARY_DIR}/${WRAP_ITK_INTDIR}${file}.py")
    SET(WRAP_ITK_PYTHON_FILES ${WRAP_ITK_PYTHON_FILES} "${tgt}")
    ADD_CUSTOM_COMMAND(SOURCE ${src}
      COMMAND ${CMAKE_COMMAND}
      ARGS -E copy ${src} ${tgt}
      OUTPUTS ${tgt}
      TARGET copy_python_files
      COMMENT "source copy")
  ENDFOREACH(file)
  
  # driver command to make the copy happen.
  ADD_CUSTOM_COMMAND(
    SOURCE copy_python_files
    DEPENDS ${WRAP_ITK_PYTHON_FILES}
    TARGET copy_python_files)
ENDIF ("${WrapITK_BINARY_DIR}" MATCHES "^${WrapITK_SOURCE_DIR}$")

# Install the package python files.
INSTALL_FILES("${WRAP_ITK_INSTALL_LOCATION}/Python" FILES ${WRAP_ITK_PYTHON_FILES})


###############################################################################
# Configure and install the custom python .pth files

SET(CONFIG_WRAP_ITK_PYTHON_DIR "${CMAKE_CURRENT_BINARY_DIR}")
CONFIGURE_FILE("${CMAKE_CURRENT_SOURCE_DIR}/WrapITK.pth.in"
             "${CMAKE_CURRENT_BINARY_DIR}/WrapITK.pth"
             @ONLY IMMEDIATE)
             
SET(CONFIG_WRAP_ITK_PYTHON_DIR "${CMAKE_INSTALL_PREFIX}${WRAP_ITK_INSTALL_LOCATION}/Python")
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
  INSTALL_AT_ABSOLUTE_PATH("${PY_SITE_PACKAGES_PATH}" "${CMAKE_CURRENT_BINARY_DIR}/InstallOnly/WrapITK.pth")
ENDIF(PY_SITE_PACKAGES_PATH)