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

INSTALL_PROGRAMS(/bin itkwish itkwish)
INSTALL_TARGETS(/lib/InsightToolkit itkwish)

INSTALL_FILES(/lib/InsightToolkit/tcl .tcl itkinteraction itktesting itkdata)
