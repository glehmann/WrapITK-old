IF(WRAP_ITK_JAVA)
  SET_SOURCE_FILES_PROPERTIES(${WrapITK_BINARY_DIR}/SwigRuntime/JavaCWDJava.cxx GENERATED)
  ADD_LIBRARY(SwigRuntimeJava MODULE ${WrapITK_BINARY_DIR}/SwigRuntime/JavaCWDJava.cxx JavaCWD.cxx)
  INSTALL_TARGETS("/lib" SwigRuntimeJava)
  MAKE_DIRECTORY(${WRAP_ITK_JAVA_DIR}/InsightToolkit)
  ADD_CUSTOM_COMMAND(
        COMMENT "run native swig on SwigExtras.i"
        SOURCE ${WrapITK_SOURCE_DIR}/SwigRuntime/JavaCWD.i
        COMMAND ${CSWIG} 
        ARGS -nocable -noruntime ${IGNORE_WARNINGS} -o ${WrapITK_BINARY_DIR}/SwigRuntime/JavaCWDJava.cxx
        -outdir "${WRAP_ITK_JAVA_DIR}/InsightToolkit"
        -package InsightToolkit
        -java -c++ ${WrapITK_SOURCE_DIR}/SwigRuntime/JavaCWD.i
        TARGET ${LIBRARY_NAME}Java
        OUTPUTS ${WrapITK_BINARY_DIR}/SwigRuntime/JavaCWDJava.cxx
        DEPENDS ${WrapITK_SOURCE_DIR}/SwigRuntime/JavaCWD.i ${CSWIG})
ENDIF(WRAP_ITK_JAVA)

