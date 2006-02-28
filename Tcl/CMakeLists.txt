###############################################################################
# Add the ITKTclSupport library which contains the itkTclCommand class.

BEGIN_WRAPPER_LIBRARY("ITKTclSupport")

SET(WRAPPER_LIBRARY_DEPENDS ITKCommonA)
SET(WRAPPER_LIBRARY_LINK_LIBRARIES ITKCommon)
# Need to include the current dir because the compiler needs to find itkTclCommand.h
INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR})
SET(WRAPPER_LIBRARY_CXX_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/itkTclCommand.cxx") 

WRAPPER_LIBRARY_CREATE_WRAP_FILES()
WRAPPER_LIBRARY_CREATE_LIBRARY()

###############################################################################
# Configure pkgIndex.tcl for the build tree.
SET(WRAP_ITK_DATA_ROOT "${WrapITK_BINARY_DIR}/Data")
SET(WRAP_ITK_TEST_ROOT "${WrapITK_BINARY_DIR}/Testing")
SET(WRAP_ITK_SCRIPT_DIR "${CMAKE_CURRENT_SOURCE_DIR}")

IF(CMAKE_CONFIGURATION_TYPES)
  FOREACH(config ${CMAKE_CONFIGURATION_TYPES})
    SET(WRAP_ITK_PACKAGE_DIR "${ITK_CSWIG_PACKAGE_DIR_BUILD}/${config}")
    CONFIGURE_FILE("${CMAKE_CURRENT_SOURCE_DIR}/pkgIndex.tcl.in"
                   "${CMAKE_CURRENT_BINARY_DIR}/${config}/pkgIndex.tcl"
                   @ONLY IMMEDIATE)
  ENDFOREACH(config)
ELSE(CMAKE_CONFIGURATION_TYPES)
  SET(WRAP_ITK_PACKAGE_DIR "${ITK_CSWIG_PACKAGE_DIR_BUILD}")
  CONFIGURE_FILE("${CMAKE_CURRENT_SOURCE_DIR}/pkgIndex.tcl.in"
                 "${CMAKE_CURRENT_BINARY_DIR}/pkgIndex.tcl"
                 @ONLY IMMEDIATE)
ENDIF(CMAKE_CONFIGURATION_TYPES)

# Configure pkgIndex.tcl for the install tree.
SET(WRAP_ITK_SCRIPT_DIR "${CMAKE_INSTALL_PREFIX}/Tcl")
SET(WRAP_ITK_PACKAGE_DIR "${CMAKE_INSTALL_PREFIX}/Tcl-SWIG")
SET(WRAP_ITK_DATA_ROOT "${CMAKE_INSTALL_PREFIX}/Data")
SET(WRAP_ITK_TEST_ROOT "<NO_DEFAULT>")
CONFIGURE_FILE("${CMAKE_CURRENT_SOURCE_DIR}/pkgIndex.tcl.in"
               "${CMAKE_CURRENT_BINARY_DIR}/InstallOnly/pkgIndex.tcl"
               IMMEDIATE @ONLY)
INSTALL_FILES("/Tcl" FILES
              "${CMAKE_CURRENT_BINARY_DIR}/InstallOnly/pkgIndex.tcl")

SET(ITK_TCL_EXE_DIR_BUILD "${ITK_EXECUTABLE_PATH}")
SET(ITK_TCL_EXE_NAME_ROOT "itkwish")

CONFIGURE_FILE(${CMAKE_CURRENT_SOURCE_DIR}/itkTclConfigure.h.in
               ${CMAKE_CURRENT_BINARY_DIR}/itkTclConfigure.h)

INCLUDE_DIRECTORIES(${CMAKE_CURRENT_BINARY_DIR})
ADD_EXECUTABLE(itkwish itkTclAppInit.cxx)
TARGET_LINK_LIBRARIES(itkwish
  ITKAlgorithmsTcl
  ITKBasicFiltersATcl
  ITKBasicFiltersBTcl
  ITKIOTcl
  ITKNumericsTcl
  ITKCommonATcl
  ITKCommonBTcl
  VXLNumericsTcl
  SwigRuntimeTcl
  ${TCL_LIBRARY}
  ${TK_LIBRARY}
)

# install the driver itkwish script
INSTALL_FILES("/Tcl" FILES itkwish)
#install the actual executable
INSTALL_TARGETS("/Tcl/bin" itkwish)
INSTALL_FILES("/Tcl" .tcl itkinteraction itktesting itkdata itkutils)
