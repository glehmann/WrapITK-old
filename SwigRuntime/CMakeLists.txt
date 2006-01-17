INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR})

IF(WRAP_ITK_TCL)
  SET_SOURCE_FILES_PROPERTIES(${WrapITK_BINARY_DIR}/SwigRuntime/swigrunTcl.cxx GENERATED)
  ADD_LIBRARY(SwigRuntimeTcl SHARED ${WrapITK_BINARY_DIR}/SwigRuntime/swigrunTcl.cxx)
  SET_TARGET_PROPERTIES(SwigRuntimeTcl PROPERTIES LINK_FLAGS "${CSWIG_EXTRA_LINKFLAGS}")
  TARGET_LINK_LIBRARIES(SwigRuntimeTcl ${TCL_LIBRARY})
  INSTALL_TARGETS("${WRAP_ITK_INSTALL_LOCATION}/lib" SwigRuntimeTcl)
ENDIF(WRAP_ITK_TCL)

IF(WRAP_ITK_PYTHON)
  SET_SOURCE_FILES_PROPERTIES(${WrapITK_BINARY_DIR}/SwigRuntime/swigrunPython.cxx GENERATED)
  ADD_LIBRARY(SwigRuntimePython SHARED ${WrapITK_BINARY_DIR}/SwigRuntime/swigrunPython.cxx)
  TARGET_LINK_LIBRARIES(SwigRuntimePython ${PYTHON_LIBRARY})
  INSTALL_TARGETS("${WRAP_ITK_INSTALL_LOCATION}/lib" SwigRuntimePython)
ENDIF(WRAP_ITK_PYTHON)

IF(WRAP_ITK_PERL)
  SET_SOURCE_FILES_PROPERTIES(${WrapITK_BINARY_DIR}/SwigRuntime/swigrunPerl.cxx GENERATED)
  ADD_LIBRARY(SwigRuntimePerl SHARED ${WrapITK_BINARY_DIR}/SwigRuntime/swigrunPerl.cxx)
  TARGET_LINK_LIBRARIES(SwigRuntimePerl "${PERL_LIBRARY}")
  INSTALL_TARGETS("${WRAP_ITK_INSTALL_LOCATION}/lib" SwigRuntimePerl)
ENDIF(WRAP_ITK_PERL)

MACRO(CREATE_SWIG_RUNTIME LangOption LibName LangPostFix)
     ADD_CUSTOM_COMMAND(
       SOURCE ${WrapITK_SOURCE_DIR}/SwigRuntime/swigrun.h
       COMMAND ${GCCXML}
       ARGS -fxml-start=_cable_ -DCABLE_CONFIGURATION ${WrapITK_SOURCE_DIR}/SwigRuntime/swigrun.h
          -fxml=${WrapITK_BINARY_DIR}/SwigRuntime/swigrun.xml 
       TARGET ${LibName}
       OUTPUTS ${WrapITK_BINARY_DIR}/SwigRuntime/swigrun.xml
       DEPENDS ${GCCXML})
     SET(XML_COMMAND_ADDED 1)
   ADD_CUSTOM_COMMAND(
    SOURCE ${WrapITK_BINARY_DIR}/SwigRuntime/swigrun.xml
    COMMAND ${CSWIG}
    ARGS -o ${WrapITK_BINARY_DIR}/SwigRuntime/swigrun${LangPostFix}.cxx ${LangOption}
         -c++ ${WrapITK_BINARY_DIR}/SwigRuntime/swigrun.xml
    TARGET ${LibName}
    OUTPUTS ${WrapITK_BINARY_DIR}/SwigRuntime/swigrun${LangPostFix}.cxx
    DEPENDS ${CSWIG})
ENDMACRO(CREATE_SWIG_RUNTIME)

IF(WRAP_ITK_TCL)
   CREATE_SWIG_RUNTIME(-tcl SwigRuntimeTcl Tcl)
ENDIF(WRAP_ITK_TCL)

IF(WRAP_ITK_PYTHON)
   CREATE_SWIG_RUNTIME(-python SwigRuntimePython Python)
ENDIF(WRAP_ITK_PYTHON)

IF(WRAP_ITK_PERL)
   CREATE_SWIG_RUNTIME(-perl5 SwigRuntimePerl Perl)
ENDIF(WRAP_ITK_PERL)

IF(WRAP_ITK_JAVA)
  SET_SOURCE_FILES_PROPERTIES(${WrapITK_BINARY_DIR}/SwigRuntime/JavaCWDJava.cxx GENERATED)
  ADD_LIBRARY(SwigRuntimeJava MODULE ${WrapITK_BINARY_DIR}/SwigRuntime/JavaCWDJava.cxx JavaCWD.cxx)
  INSTALL_TARGETS("${WRAP_ITK_INSTALL_LOCATION}/lib" SwigRuntimeJava)
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

