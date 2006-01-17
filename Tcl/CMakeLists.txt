SET(ITK_TCL_EXE_DIR_BUILD "${ITK_EXECUTABLE_PATH}")
SET(ITK_TCL_EXE_NAME_ROOT "itkwish")

CONFIGURE_FILE(${WrapITK_SOURCE_DIR}/Tcl/itkTclConfigure.h.in
               ${WrapITK_BINARY_DIR}/Tcl/itkTclConfigure.h)

INCLUDE_DIRECTORIES(${WrapITK_BINARY_DIR}/Tcl)
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
INSTALL_FILES("${WRAP_ITK_INSTALL_LOCATION}/Tcl" FILES itkwish)
#install the actual executable
INSTALL_TARGETS("${WRAP_ITK_INSTALL_LOCATION}/Tcl/bin" itkwish)
INSTALL_FILES("${WRAP_ITK_INSTALL_LOCATION}/Tcl" .tcl itkinteraction itktesting itkdata itkutils)
