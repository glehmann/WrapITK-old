OPTION(WRAP_ITK_TCL "Build cswig Tcl wrapper support (requires CableSwig)." OFF)
OPTION(WRAP_ITK_PYTHON "Build cswig Python wrapper support (requires CableSwig)." OFF)
OPTION(WRAP_ITK_JAVA "Build cswig Java wrapper support (requires CableSwig)." OFF)

OPTION(WRAP_unsigned_char "Wrap unsigned char type" OFF)
MARK_AS_ADVANCED(WRAP_unsigned_char)
OPTION(WRAP_unsigned_short "Wrap unsigned short type" ON)
MARK_AS_ADVANCED(WRAP_unsigned_short)
OPTION(WRAP_unsigned_long "Wrap unsigned long type" OFF)
MARK_AS_ADVANCED(WRAP_unsigned_long)

OPTION(WRAP_signed_char "Wrap signed char type" OFF)
MARK_AS_ADVANCED(WRAP_signed_char)
OPTION(WRAP_signed_short "Wrap signed short type" OFF)
MARK_AS_ADVANCED(WRAP_signed_short)
OPTION(WRAP_signed_long "Wrap signed long type" OFF)
MARK_AS_ADVANCED(WRAP_signed_long)

OPTION(WRAP_float "Wrap float type" ON)
MARK_AS_ADVANCED(WRAP_float)
OPTION(WRAP_double "Wrap double type" OFF)
MARK_AS_ADVANCED(WRAP_double)

OPTION(WRAP_vector_float "Wrap vector float type" ON)
MARK_AS_ADVANCED(WRAP_vector_float)
OPTION(WRAP_vector_double "Wrap vector double type" OFF)
MARK_AS_ADVANCED(WRAP_vector_double)

OPTION(WRAP_covariant_vector_float "Wrap covariant vector float type" ON)
MARK_AS_ADVANCED(WRAP_covariant_vector_float)
OPTION(WRAP_covariant_vector_double "Wrap covariant vector double type" OFF)
MARK_AS_ADVANCED(WRAP_covariant_vector_double)

SET(ITK_SWG_FILES "${WrapITK_SOURCE_DIR}/itk.swg")

#------------------------------------------------------------------------------
# make sure required stuff is set
SET(WRAP_ITK_INCLUDE_DIRS "")

IF(WRAP_ITK_TCL)
  SET(WRAP_ITK_INCLUDE_DIRS ${WRAP_ITK_INCLUDE_DIRS} ${TCL_INCLUDE_PATH} ${TK_INCLUDE_PATH})
  INCLUDE_DIRECTORIES(${TCL_INCLUDE_PATH} ${TK_INCLUDE_PATH})
ENDIF(WRAP_ITK_TCL)

IF(WRAP_ITK_PYTHON)
  # Python include directory.
  SET(WRAP_ITK_INCLUDE_DIRS ${WRAP_ITK_INCLUDE_DIRS}
    ${PYTHON_INCLUDE_PATH})
  INCLUDE_DIRECTORIES(${PYTHON_INCLUDE_PATH} )
ENDIF(WRAP_ITK_PYTHON)

IF(WRAP_ITK_PERL)
  INCLUDE_DIRECTORIES(${PERL_INCLUDE_PATH})
ENDIF(WRAP_ITK_PERL)

IF(WRAP_ITK_JAVA)
  # Java include directories.
  SET(WRAP_ITK_INCLUDE_DIRS ${WRAP_ITK_INCLUDE_DIRS}
      ${JAVA_INCLUDE_PATH} ${JAVA_INCLUDE_PATH2} ${JAVA_AWT_INCLUDE_PATH})
  INCLUDE_DIRECTORIES(${JAVA_INCLUDE_PATH} ${JAVA_INCLUDE_PATH2} ${JAVA_AWT_INCLUDE_PATH})
ENDIF(WRAP_ITK_JAVA)

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

SET(CSWIG_MISSING_VALUES)
IF(NOT CSWIG)
   SET(CSWIG_MISSING_VALUES "${CSWIG_MISSING_VALUES} CSWIG ")
ENDIF(NOT CSWIG)
IF(NOT CABLE_INDEX)
   SET(CSWIG_MISSING_VALUES "${CSWIG_MISSING_VALUES} CABLE_INDEX ")
ENDIF(NOT CABLE_INDEX)
IF(NOT GCCXML)
   SET(CSWIG_MISSING_VALUES "${CSWIG_MISSING_VALUES} GCCXML ")
ENDIF(NOT GCCXML)
IF(CSWIG_MISSING_VALUES)
  MESSAGE(SEND_ERROR "To use cswig wrapping, CSWIG, CABLE_INDEX, and GCCXML executables must be specified.  If they are all in the same directory, only specifiy one of them, and then run cmake configure again and the others should be found.\nCurrently, you are missing the following:\n ${CSWIG_MISSING_VALUES}")
ENDIF(CSWIG_MISSING_VALUES)

SET(SWIG_INC
  ${TCL_INCLUDE_PATH}
  ${ITK_INCLUDE_DIRS}
  ${WRAP_ITK_INCLUDE_DIRS}
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

#------------------------------------------------------------------------------
# System dependant wraping stuff
SET(ITK_WRAP_NEEDS_DEPEND 1)
IF(${CMAKE_MAKE_PROGRAM} MATCHES make)
  SET(ITK_WRAP_NEEDS_DEPEND 0)
ENDIF(${CMAKE_MAKE_PROGRAM} MATCHES make)
SET(ITK_SWIG_DEFAULT_LIB ${CableSwig_DIR}/SWIG/Lib )

SET(CSWIG_EXTRA_LINKFLAGS )
IF(CMAKE_BUILD_TOOL MATCHES "(msdev|devenv|nmake)")
  SET(CSWIG_EXTRA_LINKFLAGS "/IGNORE:4049")
ENDIF(CMAKE_BUILD_TOOL MATCHES "(msdev|devenv|nmake)")

IF(CMAKE_SYSTEM MATCHES "IRIX.*")
  IF(CMAKE_CXX_COMPILER MATCHES "CC")
    SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -woff 1552")
  ENDIF(CMAKE_CXX_COMPILER MATCHES "CC")
ENDIF(CMAKE_SYSTEM MATCHES "IRIX.*")

IF(CMAKE_COMPILER_IS_GNUCXX)
  STRING(REGEX REPLACE "-Wcast-qual" "" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
ENDIF(CMAKE_COMPILER_IS_GNUCXX)

IF(UNIX)
  SET(WRAP_ITK_LIBNAME_PREFIX "lib")
ELSE(UNIX)
  SET(WRAP_ITK_LIBNAME_PREFIX "")
ENDIF(UNIX)

SET(CSWIG_IGNORE_WARNINGS -w362 -w389 -w503 -w508 -w509 -w516)
ADD_DEFINITIONS(-DSWIG_GLOBAL)

#------------------------------------------------------------------------------
# define macros for wrapping commands
MACRO(GCCXML_CREATE_XML_FILE Source Bin Input Output Library)
# if the make program is not an IDE then include
# the depend file in a way that will make cmake 
# re-run if it changes
   SET(CABLE_SWIG_DEPEND)
   SET(CABLE_SWIG_DEPEND_REGENERATE)
   IF(${CMAKE_MAKE_PROGRAM} MATCHES "make")
     IF(EXISTS ${Bin}/${Output}.depend)
     ELSE(EXISTS ${Bin}/${Output}.depend)
       CONFIGURE_FILE(
         ${WrapITK_SOURCE_DIR}/empty.depend.in
         ${Bin}/${Output}.depend @ONLY IMMEDIATE)
     ENDIF(EXISTS ${Bin}/${Output}.depend)
     INCLUDE(${Bin}/${Output}.depend)
   ELSE(${CMAKE_MAKE_PROGRAM} MATCHES "make")
# for IDE generators like MS dev only include the depend files
# if they exist.   This is to prevent ecessive reloading of
# workspaces after each build.   This also means
# that the depends will not be correct until cmake
# is run once after the build has completed once.
# the depend files are created in the wrap tcl/python sections
# when the .xml file is parsed.
     INCLUDE(${Bin}/${Output}.depend OPTIONAL)
   ENDIF(${CMAKE_MAKE_PROGRAM} MATCHES "make")

   IF(CABLE_SWIG_DEPEND)
     # There are dependencies.  Make sure all the files are present.
     # If not, force the rule to re-run to update the dependencies.
     FOREACH(f ${CABLE_SWIG_DEPEND})
       IF(EXISTS ${f})
       ELSE(EXISTS ${f})
         SET(CABLE_SWIG_DEPEND_REGENERATE 1)
       ENDIF(EXISTS ${f})
     ENDFOREACH(f)
   ELSE(CABLE_SWIG_DEPEND)
     # No dependencies, make the output depend on the dependency file
     # itself, which should cause the rule to re-run.
     SET(CABLE_SWIG_DEPEND_REGENERATE 1)
   ENDIF(CABLE_SWIG_DEPEND)
   IF(CABLE_SWIG_DEPEND_REGENERATE)
     SET(CABLE_SWIG_DEPEND ${Bin}/${Output}.depend)
     CONFIGURE_FILE(
       ${WrapITK_SOURCE_DIR}/empty.depend.in
       ${Bin}/${Output}.depend @ONLY IMMEDIATE)
   ENDIF(CABLE_SWIG_DEPEND_REGENERATE)

   IF(EXISTS ${Source}/${Input})
      ADD_CUSTOM_COMMAND(
      COMMENT "${Output} from "
      SOURCE ${Source}/${Input}
      COMMAND ${GCCXML}
      ARGS -fxml-start=_cable_
           -fxml=${Bin}/${Output} --gccxml-gcc-options ${SWIG_INC_FILE}
           -DCSWIG -DCABLE_CONFIGURATION ${Source}/${Input}
      TARGET ${Library}
      OUTPUTS ${Bin}/${Output}
      DEPENDS ${GCCXML} ${CABLE_SWIG_DEPEND})
   ELSE(EXISTS ${Source}/${Input})
      ADD_CUSTOM_COMMAND(
      COMMENT "${Output} from "
      SOURCE ${Bin}/${Input}
      COMMAND ${GCCXML}
      ARGS -fxml-start=_cable_
           -fxml=${Bin}/${Output} --gccxml-gcc-options ${SWIG_INC_FILE}
           -DCSWIG -DCABLE_CONFIGURATION ${Bin}/${Input}
      TARGET ${Library}
      OUTPUTS ${Bin}/${Output}
      DEPENDS ${GCCXML} ${CABLE_SWIG_DEPEND})
   ENDIF(EXISTS ${Source}/${Input})
ENDMACRO(GCCXML_CREATE_XML_FILE)


MACRO(CINDEX_CREATE_IDX_FILE Bin Input Output Library)
   ADD_CUSTOM_COMMAND(
   COMMENT "${Output} from "
   SOURCE ${Bin}/${Input}
   COMMAND ${CABLE_INDEX}
   ARGS ${Bin}/${Input} ${Bin}/${Output}
   TARGET ${Library}
   OUTPUTS ${Bin}/${Output} 
   DEPENDS ${Bin}/${Input} ${CABLE_INDEX}
)
ENDMACRO(CINDEX_CREATE_IDX_FILE)

MACRO(CSWIG_CREATE_TCL_CXX_FILE Bin MasterIdx InputIdx InputXml OutputTclCxx Library LibraryIndexFiles)
   SET(CINDEX)
   FOREACH(MIDX ${MasterIdx})
     SET(CINDEX ${CINDEX} -Cindex "${MIDX}")
   ENDFOREACH(MIDX)
   
   SET(ITK_SWG_FILE)
   FOREACH(file ${ITK_SWG_FILES})
       SET(ITK_SWG_FILE "-l${file}" ${ITK_SWG_FILE})
   ENDFOREACH(file)

   # Need dependency on ${ITK_BINARY_DIR}/itkConfigure.h so
   # package is rebuilt when the ITK version changes.
   ADD_CUSTOM_COMMAND(
     COMMENT "${OutputTclCxx} from "
     SOURCE ${Bin}/${InputIdx}
     COMMAND ${CSWIG}
     ARGS ${ITK_SWG_FILE}
          -I${ITK_SWIG_DEFAULT_LIB}
          -I${ITK_SWIG_DEFAULT_LIB}/tcl
          -noruntime ${CINDEX} ${CSWIG_IGNORE_WARNINGS} -depend ${Bin}/${InputXml}.depend
          -o ${Bin}/${OutputTclCxx} -tcl -pkgversion "${ITK_VERSION_STRING}" -c++ ${Bin}/${InputXml}
     TARGET ${Library}
     OUTPUTS ${Bin}/${OutputTclCxx}
     DEPENDS ${LibraryIndexFiles} ${ITK_SWG_FILES} ${Bin}/${InputXml} ${CSWIG} ${ITK_BINARY_DIR}/itkConfigure.h)
#     MESSAGE("depends are ${CABLE_SWIG_DEPEND}")
ENDMACRO(CSWIG_CREATE_TCL_CXX_FILE)

MACRO(CSWIG_CREATE_PERL_CXX_FILE Bin MasterIdx InputIdx InputXml OutputPerlCxx Library LibraryIndexFiles)
   SET(CINDEX)
   FOREACH(MIDX ${MasterIdx})
     SET(CINDEX ${CINDEX} -Cindex "${MIDX}")
   ENDFOREACH(MIDX)

   SET(ITK_SWG_FILE)
   FOREACH(file ${ITK_SWG_FILES})
       SET(ITK_SWG_FILE "-l${file}" ${ITK_SWG_FILE})
   ENDFOREACH(file)

   # Need dependency on ${ITK_BINARY_DIR}/itkConfigure.h so
   # package is rebuilt when the ITK version changes.
   ADD_CUSTOM_COMMAND(
     COMMENT "${OutputPerlCxx} from "
     SOURCE ${Bin}/${InputIdx}
     COMMAND ${CSWIG}
     ARGS -perl5
          ${ITK_SWG_FILE}
          -I${ITK_SWIG_DEFAULT_LIB}
          -noruntime ${CINDEX} ${CSWIG_IGNORE_WARNINGS} -depend ${Bin}/${InputXml}.depend
          -o ${Bin}/${OutputPerlCxx} -c++ ${Bin}/${InputXml}
     TARGET ${Library}
     OUTPUTS ${Bin}/${OutputPerlCxx}
     DEPENDS ${LibraryIndexFiles} ${ITK_SWG_FILES} ${Bin}/${InputXml} ${CSWIG} ${ITK_BINARY_DIR}/itkConfigure.h)
ENDMACRO(CSWIG_CREATE_PERL_CXX_FILE)

SET(WRAP_ITK_PYTHON_NO_EXCEPTION_REGEX "(ContinuousIndex|Python)\\.xml$")
SET(WRAP_ITK_JAVA_NO_EXCEPTION_REGEX "(Java)\\.xml$")

MACRO(CSWIG_CREATE_PYTHON_CXX_FILE Bin MasterIdx InputIdx InputXml OutputTclCxx Library LibraryIndexFiles)
   SET(CINDEX)
   FOREACH(MIDX ${MasterIdx})
     SET(CINDEX ${CINDEX} -Cindex "${MIDX}")
   ENDFOREACH(MIDX)
   IF("${InputXml}" MATCHES "${WRAP_ITK_PYTHON_NO_EXCEPTION_REGEX}")
     SET(ITK_SWG_FILE "")
   ELSE("${InputXml}" MATCHES "${WRAP_ITK_PYTHON_NO_EXCEPTION_REGEX}")
     SET(ITK_SWG_FILE)
     FOREACH(file ${ITK_SWG_FILES})
       SET(ITK_SWG_FILE "-l${file}" ${ITK_SWG_FILE})
     ENDFOREACH(file)
   ENDIF("${InputXml}" MATCHES "${WRAP_ITK_PYTHON_NO_EXCEPTION_REGEX}")
   ADD_CUSTOM_COMMAND(
     COMMENT "${OutputTclCxx} from "
     SOURCE ${Bin}/${InputIdx}
     COMMAND ${CSWIG}
     ARGS ${ITK_SWG_FILE}
          -I${ITK_SWIG_DEFAULT_LIB}
          -I${ITK_SWIG_DEFAULT_LIB}/python
          -noruntime ${CINDEX} ${CSWIG_IGNORE_WARNINGS} -depend ${Bin}/${InputXml}.depend
          -outdir "${EXECUTABLE_OUTPUT_PATH}/${CMAKE_CFG_INTDIR}" 
          -o ${Bin}/${OutputTclCxx} -python -c++ ${Bin}/${InputXml}
     TARGET ${Library}
     OUTPUTS ${Bin}/${OutputTclCxx}
     DEPENDS ${LibraryIndexFiles}  ${ITK_SWG_FILES} ${Bin}/${InputXml} ${CSWIG} )
ENDMACRO(CSWIG_CREATE_PYTHON_CXX_FILE)

MACRO(CSWIG_CREATE_JAVA_CXX_FILE Bin MasterIdx InputIdx InputXml OutputTclCxx Library LibraryIndexFiles)
   SET(CINDEX)
   FOREACH(MIDX ${MasterIdx})
     SET(CINDEX ${CINDEX} -Cindex "${MIDX}")
   ENDFOREACH(MIDX)
   IF("${InputXml}" MATCHES "${WRAP_ITK_JAVA_NO_EXCEPTION_REGEX}")
     SET(ITK_SWG_FILE "")
   ELSE("${InputXml}" MATCHES "${WRAP_ITK_JAVA_NO_EXCEPTION_REGEX}")
     SET(ITK_SWG_FILE)
     FOREACH(file ${ITK_SWG_FILES})
       SET(ITK_SWG_FILE "-l${file}" ${ITK_SWG_FILE})
     ENDFOREACH(file)
   ENDIF("${InputXml}" MATCHES "${WRAP_ITK_JAVA_NO_EXCEPTION_REGEX}")
   ADD_CUSTOM_COMMAND(
     COMMENT "${OutputTclCxx} from "
     SOURCE ${Bin}/${InputIdx}
     COMMAND ${CSWIG} 
     ARGS -I${ITK_SWIG_DEFAULT_LIB}
          -I${ITK_SWIG_DEFAULT_LIB}/java
          ${ITK_SWG_FILE}
          -noruntime ${CINDEX} ${CSWIG_IGNORE_WARNINGS} -depend ${Bin}/${InputXml}.depend
          -outdir ${WrapITK_BINARY_DIR}/Java/InsightToolkit
          -o ${Bin}/${OutputTclCxx} -package InsightToolkit -java -c++ ${Bin}/${InputXml}
     TARGET ${Library}
     OUTPUTS ${Bin}/${OutputTclCxx}
     DEPENDS ${LibraryIndexFiles} ${ITK_SWG_FILE} ${Bin}/${InputXml} ${CSWIG} )
ENDMACRO(CSWIG_CREATE_JAVA_CXX_FILE)

# macro to create .xml, .idx and Tcl.cxx files
MACRO(WRAP_TCL_SOURCES Source Bin BaseName LibraryName MasterIdx LibraryIndexFiles)
   GCCXML_CREATE_XML_FILE(${Source} ${Bin} ${BaseName}.cxx ${BaseName}.xml ${LibraryName})
   CINDEX_CREATE_IDX_FILE(${Bin} ${BaseName}.xml  ${BaseName}.idx ${LibraryName})
   CSWIG_CREATE_TCL_CXX_FILE(${Bin} "${MasterIdx}" ${BaseName}.idx ${BaseName}.xml
                             ${BaseName}Tcl.cxx ${LibraryName} "${LibraryIndexFiles}")
ENDMACRO(WRAP_TCL_SOURCES)

# macro to create .xml, .idx and Tcl.cxx files
MACRO(WRAP_PERL_SOURCES Source Bin BaseName LibraryName MasterIdx LibraryIndexFiles)
   GCCXML_CREATE_XML_FILE(${Source} ${Bin} ${BaseName}.cxx ${BaseName}.xml ${LibraryName})
   CINDEX_CREATE_IDX_FILE(${Bin} ${BaseName}.xml  ${BaseName}.idx ${LibraryName})
   CSWIG_CREATE_PERL_CXX_FILE(${Bin} "${MasterIdx}" ${BaseName}.idx ${BaseName}.xml
                             ${BaseName}Perl.cxx ${LibraryName} "${LibraryIndexFiles}")
ENDMACRO(WRAP_PERL_SOURCES)

# macro to create .xml, .idx and Python.cxx files
MACRO(WRAP_PYTHON_SOURCES Source Bin BaseName LibraryName MasterIdx LibraryIndexFiles)
   GCCXML_CREATE_XML_FILE(${Source} ${Bin} ${BaseName}.cxx ${BaseName}.xml ${LibraryName})
   CINDEX_CREATE_IDX_FILE(${Bin} ${BaseName}.xml  ${BaseName}.idx ${LibraryName})
   CSWIG_CREATE_PYTHON_CXX_FILE(${Bin} "${MasterIdx}" ${BaseName}.idx ${BaseName}.xml
                             ${BaseName}Python.cxx ${LibraryName} "${LibraryIndexFiles}")
ENDMACRO(WRAP_PYTHON_SOURCES)

# macro to create .xml, .idx and Python.cxx files
MACRO(WRAP_JAVA_SOURCES Source Bin BaseName LibraryName MasterIdx LibraryIndexFiles)
   GCCXML_CREATE_XML_FILE(${Source} ${Bin} ${BaseName}.cxx ${BaseName}.xml ${LibraryName})
   CINDEX_CREATE_IDX_FILE(${Bin} ${BaseName}.xml  ${BaseName}.idx ${LibraryName})
   CSWIG_CREATE_JAVA_CXX_FILE(${Bin} "${MasterIdx}" ${BaseName}.idx ${BaseName}.xml
                             ${BaseName}Java.cxx ${LibraryName} "${LibraryIndexFiles}")
ENDMACRO(WRAP_JAVA_SOURCES)

#------------------------------------------------------------------------------
MACRO(ITK_WRAP_LIBRARY SRCS LIBRARY_NAME DIRECTORY DEPEND_LIBRARY EXTRA_SOURCES ITK_LINK_LIBRARIES MASTER_IDX SOURCE_DIR BINARY_DIR)
  SET(WRAP_SOURCES)
  FOREACH(src ${SRCS})
    SET(WRAP_SOURCES ${WRAP_SOURCES} wrap_${src})
  ENDFOREACH(src)
  
  # loop over cable config files creating two lists:
  # WRAP_TCL_SOURCES: list of generated files
  SET(INDEX_FILE_CONTENT "%JavaLoader=InsightToolkit.itkbase.LoadLibrary(\"${LIBRARY_NAME}Java\")\n")
  FOREACH(Source ${WRAP_SOURCES})
    SET(WRAP_PERL_SOURCES ${WRAP_PERL_SOURCES} ${Source}Perl.cxx)
    SET(WRAP_TCL_SOURCES ${WRAP_TCL_SOURCES} ${Source}Tcl.cxx)
    SET(WRAP_PYTHON_SOURCES ${WRAP_PYTHON_SOURCES} ${Source}Python.cxx)
    SET(WRAP_JAVA_SOURCES ${WRAP_JAVA_SOURCES} ${Source}Java.cxx)
    STRING(REGEX REPLACE wrap_ "" JAVA_DEP ${Source})
    SET(${LIBRARY_NAME}_JAVA_DEPENDS_INIT ${${LIBRARY_NAME}_JAVA_DEPENDS_INIT} ${JAVA_DEP}.java)
    SET(ALL_IDX_FILES ${ALL_IDX_FILES} ${BINARY_DIR}/${DIRECTORY}/${Source}.idx )
    SET(INDEX_FILE_CONTENT "${INDEX_FILE_CONTENT}${BINARY_DIR}/${DIRECTORY}/${Source}.idx\n")
  ENDFOREACH(Source)
  SET(${LIBRARY_NAME}_JAVA_DEPENDS  "${${LIBRARY_NAME}_JAVA_DEPENDS_INIT}" CACHE INTERNAL "" FORCE)
  # add the package wrappers 
  SET(WRAP_PERL_SOURCES ${WRAP_PERL_SOURCES} wrap_${LIBRARY_NAME}PerlPerl.cxx)
  SET(WRAP_TCL_SOURCES ${WRAP_TCL_SOURCES} wrap_${LIBRARY_NAME}TclTcl.cxx)
  SET(WRAP_PYTHON_SOURCES ${WRAP_PYTHON_SOURCES} wrap_${LIBRARY_NAME}PythonPython.cxx)
  SET(WRAP_JAVA_SOURCES ${WRAP_JAVA_SOURCES} wrap_${LIBRARY_NAME}JavaJava.cxx)
  IF(ITK_EXTRA_TCL_WRAP)
    SET(WRAP_TCL_SOURCES ${WRAP_TCL_SOURCES} ${ITK_EXTRA_TCL_WRAP}Tcl.cxx)
  ENDIF(ITK_EXTRA_TCL_WRAP)
  IF(ITK_EXTRA_PYTHON_WRAP)
    FOREACH( extraPython ${ITK_EXTRA_PYTHON_WRAP})
      SET(WRAP_PYTHON_SOURCES ${WRAP_PYTHON_SOURCES} ${extraPython}Python.cxx)
    ENDFOREACH( extraPython )
  ENDIF(ITK_EXTRA_PYTHON_WRAP)
  IF(ITK_EXTRA_JAVA_WRAP)
    SET(WRAP_JAVA_SOURCES ${WRAP_JAVA_SOURCES} ${ITK_EXTRA_JAVA_WRAP}Java.cxx)
  ENDIF(ITK_EXTRA_JAVA_WRAP)
  IF(ITK_EXTRA_PERL_WRAP)
    SET(WRAP_PERL_SOURCES ${WRAP_PERL_SOURCES} ${ITK_EXTRA_PERL_WRAP}Java.cxx)
  ENDIF(ITK_EXTRA_PERL_WRAP)

  # set the generated sources as generated
  SET_SOURCE_FILES_PROPERTIES(
    ${WRAP_PERL_SOURCES} 
    ${WRAP_TCL_SOURCES} 
    ${WRAP_PYTHON_SOURCES} 
    ${WRAP_JAVA_SOURCES} GENERATED )
  SET(EXTRA_LIBS ${ITK_LINK_LIBRARIES})
  IF("${ITK_LINK_LIBRARIES}" MATCHES "^$")
    SET(EXTRA_LIBS ${LIBRARY_NAME})
  ENDIF("${ITK_LINK_LIBRARIES}" MATCHES "^$")
  IF(WRAP_ITK_TCL)
    IF(ITK_SWIG_FILE)
      SET(SWIG_INC ${SWIG_INC} ${TCL_INCLUDE_PATH})
      SET_SOURCE_FILES_PROPERTIES(${ITK_SWIG_FILE_CXX}Tcl.cxx GENERATED)
      SET(WRAP_FILE ${ITK_SWIG_FILE_CXX}Tcl.cxx )
    ENDIF(ITK_SWIG_FILE)
      
    ADD_LIBRARY(${LIBRARY_NAME}Tcl SHARED 
      ${WRAP_TCL_SOURCES} 
      ${ITK_EXTRA_TCL_SOURCES}
      ${WRAP_FILE}
      ${EXTRA_SOURCES})
    IF(ITK_WRAP_NEEDS_DEPEND)
      FOREACH(lib ${DEPEND_LIBRARY})
        ADD_DEPENDENCIES(${LIBRARY_NAME}Tcl ${lib}Tcl)
      ENDFOREACH(lib)
    ENDIF(ITK_WRAP_NEEDS_DEPEND)
    SET_TARGET_PROPERTIES(${LIBRARY_NAME}Tcl PROPERTIES LINK_FLAGS "${CSWIG_EXTRA_LINKFLAGS}")
    TARGET_LINK_LIBRARIES(${LIBRARY_NAME}Tcl ${EXTRA_LIBS} SwigRuntimeTcl ${TCL_LIBRARY})
    INSTALL_TARGETS(/lib/InsightToolkit ${LIBRARY_NAME}Tcl )
    IF(ITK_SWIG_FILE)
      ADD_CUSTOM_COMMAND(
        COMMENT "run native swig on ${ITK_SWIG_FILE}"
        SOURCE ${ITK_SWIG_FILE}
        COMMAND ${CSWIG}
        ARGS -nocable -noruntime ${CSWIG_IGNORE_WARNINGS} -o ${WRAP_FILE}
        -c++ ${ITK_SWIG_FILE}
        TARGET ${LIBRARY_NAME}Tcl
        OUTPUTS ${WRAP_FILE}
        DEPENDS ${ITK_SWIG_FILE} ${CSWIG})
    ENDIF(ITK_SWIG_FILE)
  ENDIF(WRAP_ITK_TCL)


  IF(WRAP_ITK_PERL)
    IF(ITK_SWIG_FILE)
      SET(SWIG_INC ${SWIG_INC} ${PERL_INCLUDE_PATH})
      SET_SOURCE_FILES_PROPERTIES(${ITK_SWIG_FILE_CXX}Perl.cxx GENERATED)
      SET(WRAP_FILE ${ITK_SWIG_FILE_CXX}Perl.cxx )
    ENDIF(ITK_SWIG_FILE)
      
    ADD_LIBRARY(${LIBRARY_NAME}Perl SHARED 
      ${WRAP_PERL_SOURCES} 
      ${ITK_EXTRA_PERL_SOURCES} 
      ${WRAP_FILE}
      ${EXTRA_SOURCES})
    SET_TARGET_PROPERTIES(${LIBRARY_NAME}Perl PROPERTIES LINK_FLAGS "${CSWIG_EXTRA_LINKFLAGS}")
    TARGET_LINK_LIBRARIES(${LIBRARY_NAME}Perl ${EXTRA_LIBS} SwigRuntimePerl ${PERL_LIBRARY})
    IF(ITK_WRAP_NEEDS_DEPEND)
      FOREACH(lib ${DEPEND_LIBRARY})
        ADD_DEPENDENCIES(${LIBRARY_NAME}Perl ${lib}Perl)
      ENDFOREACH(lib)
    ENDIF(ITK_WRAP_NEEDS_DEPEND)
    INSTALL_TARGETS(/lib/InsightToolkit ${LIBRARY_NAME}Perl )
    IF(ITK_SWIG_FILE)
      ADD_CUSTOM_COMMAND(
        COMMENT "run native swig on ${ITK_SWIG_FILE}"
        SOURCE ${ITK_SWIG_FILE}
        COMMAND ${CSWIG} 
        ARGS -nocable -noruntime ${CSWIG_IGNORE_WARNINGS} -o ${WRAP_FILE}
        -perl5 -c++ ${ITK_SWIG_FILE}
        TARGET ${LIBRARY_NAME}Perl
        OUTPUTS ${WRAP_FILE}
        DEPENDS ${ITK_SWIG_FILE} ${CSWIG})
    ENDIF(ITK_SWIG_FILE)
  ENDIF(WRAP_ITK_PERL)


  IF(WRAP_ITK_PYTHON)  
    IF(ITK_SWIG_FILE)
      SET(SWIG_INC ${SWIG_INC} ${PYTHON_INCLUDE_PATH})
      SET_SOURCE_FILES_PROPERTIES(${ITK_SWIG_FILE_CXX}Python.cxx GENERATED)
      SET(WRAP_FILE ${ITK_SWIG_FILE_CXX}Python.cxx )
    ENDIF(ITK_SWIG_FILE)
    
    ADD_LIBRARY(_${LIBRARY_NAME}Python MODULE
      ${WRAP_PYTHON_SOURCES}
      ${ITK_EXTRA_PYTHON_SOURCES}
      ${WRAP_FILE}
      ${EXTRA_SOURCES})
    IF(ITK_WRAP_NEEDS_DEPEND)
      FOREACH(lib ${DEPEND_LIBRARY})
        ADD_DEPENDENCIES(_${LIBRARY_NAME}Python _${lib}Python)
      ENDFOREACH(lib)
    ENDIF(ITK_WRAP_NEEDS_DEPEND)
    SET_TARGET_PROPERTIES( _${LIBRARY_NAME}Python PROPERTIES PREFIX "")
    TARGET_LINK_LIBRARIES(_${LIBRARY_NAME}Python ${EXTRA_LIBS} SwigRuntimePython ${PYTHON_LIBRARY})
    INSTALL_TARGETS(/lib/InsightToolkit _${LIBRARY_NAME}Python) 
    IF(ITK_SWIG_FILE)
      ADD_CUSTOM_COMMAND(
        COMMENT "run native swig on ${ITK_SWIG_FILE}"
        SOURCE ${ITK_SWIG_FILE}
        COMMAND ${CSWIG} 
        ARGS -nocable -noruntime ${CSWIG_IGNORE_WARNINGS} -o ${WRAP_FILE}
         -outdir "${LIBRARY_OUTPUT_PATH}/${CMAKE_CFG_INTDIR}"
         -python -c++ ${ITK_SWIG_FILE}
        TARGET _${LIBRARY_NAME}Python
        OUTPUTS ${WRAP_FILE}
        DEPENDS ${ITK_SWIG_FILE} ${CSWIG})
    ENDIF(ITK_SWIG_FILE)
  ENDIF(WRAP_ITK_PYTHON)

  IF(WRAP_ITK_JAVA)  
    IF(ITK_SWIG_FILE)
      SET(SWIG_INC ${SWIG_INC} ${JAVA_INCLUDE_PATH})
      SET_SOURCE_FILES_PROPERTIES(${ITK_SWIG_FILE_CXX}Java.cxx GENERATED)
      SET(WRAP_FILE ${ITK_SWIG_FILE_CXX}Java.cxx )
    ENDIF(ITK_SWIG_FILE)
    MAKE_DIRECTORY("${BINARY_DIR}/Java/InsightToolkit")
    ADD_LIBRARY(${LIBRARY_NAME}Java MODULE 
      ${WRAP_JAVA_SOURCES} 
      ${ITK_EXTRA_JAVA_SOURCES} 
      ${WRAP_FILE}
      ${EXTRA_SOURCES})
    TARGET_LINK_LIBRARIES(${LIBRARY_NAME}Java ${JAVA_LIBRARY} ${EXTRA_LIBS} )   
    IF(ITK_WRAP_NEEDS_DEPEND)
      FOREACH(lib ${DEPEND_LIBRARY})
        ADD_DEPENDENCIES(${LIBRARY_NAME}Java ${lib}Java)
      ENDFOREACH(lib)
    ENDIF(ITK_WRAP_NEEDS_DEPEND)
    INSTALL_TARGETS(${ITK_INSTALL_JAVA_LIBS_DIR} ${LIBRARY_NAME}Java)
    IF(ITK_SWIG_FILE)
      ADD_CUSTOM_COMMAND(
        COMMENT "run native swig on ${ITK_SWIG_FILE}"
        SOURCE ${ITK_SWIG_FILE}
        COMMAND ${CSWIG} 
        ARGS -nocable -noruntime ${CSWIG_IGNORE_WARNINGS} -o ${WRAP_FILE}
        -I${ITK_SOURCE_DIR}/Code/Common -DITKCommon_EXPORT=
        -outdir ${BINARY_DIR}/Java/InsightToolkit
        -package InsightToolkit -java -c++ ${ITK_SWIG_FILE}
        TARGET ${LIBRARY_NAME}Java
        OUTPUTS ${WRAP_FILE}
        DEPENDS ${ITK_SWIG_FILE} ${CSWIG})
    ENDIF(ITK_SWIG_FILE)
  ENDIF(WRAP_ITK_JAVA)
  
  CONFIGURE_FILE(
    ${WrapITK_SOURCE_DIR}/Master.mdx.in
    ${BINARY_DIR}/${DIRECTORY}/${LIBRARY_NAME}.mdx IMMEDIATE
    )

  SET(SWIG_INC_FILE ${BINARY_DIR}/${DIRECTORY}/SwigInc.txt)
  SET(SWIG_INC_CONTENTS)
  FOREACH(dir ${SWIG_INC})
    SET(SWIG_INC_CONTENTS "${SWIG_INC_CONTENTS}-I${dir}\n")
  ENDFOREACH(dir)
  CONFIGURE_FILE(${WrapITK_SOURCE_DIR}/SwigInc.txt.in ${SWIG_INC_FILE}
    @ONLY IMMEDIATE)
  
  FOREACH(Source ${WRAP_SOURCES})
    IF(WRAP_ITK_TCL)
      # tcl
      WRAP_TCL_SOURCES(${SOURCE_DIR}/${DIRECTORY} ${BINARY_DIR}/${DIRECTORY}
        ${Source} ${LIBRARY_NAME}Tcl "${MASTER_IDX}" "${ALL_IDX_FILES}")
    ENDIF(WRAP_ITK_TCL)

    IF(WRAP_ITK_PERL)
      # tcl
      WRAP_PERL_SOURCES(${SOURCE_DIR}/${DIRECTORY} ${BINARY_DIR}/${DIRECTORY}
        ${Source} ${LIBRARY_NAME}Perl "${MASTER_IDX}" "${ALL_IDX_FILES}")
    ENDIF(WRAP_ITK_PERL)
    
    IF(WRAP_ITK_PYTHON)
      # python
      WRAP_PYTHON_SOURCES(${SOURCE_DIR}/${DIRECTORY} ${BINARY_DIR}/${DIRECTORY}
        ${Source} _${LIBRARY_NAME}Python "${MASTER_IDX}" "${ALL_IDX_FILES}")
    ENDIF(WRAP_ITK_PYTHON)
    
    IF(WRAP_ITK_JAVA)
      # java
      WRAP_JAVA_SOURCES(${SOURCE_DIR}/${DIRECTORY} ${BINARY_DIR}/${DIRECTORY}
        ${Source} ${LIBRARY_NAME}Java "${MASTER_IDX}" "${ALL_IDX_FILES}")
    ENDIF(WRAP_ITK_JAVA)
  ENDFOREACH(Source)
  
  
  # wrap the package files for tcl and python
  IF(WRAP_ITK_TCL)
    # tcl
    WRAP_TCL_SOURCES(${SOURCE_DIR}/${DIRECTORY} ${BINARY_DIR}/${DIRECTORY}
      wrap_${LIBRARY_NAME}Tcl ${LIBRARY_NAME}Tcl "${MASTER_IDX}" "${ALL_IDX_FILES}")
    IF(ITK_EXTRA_TCL_WRAP)
      WRAP_TCL_SOURCES(${SOURCE_DIR}/${DIRECTORY} ${BINARY_DIR}/${DIRECTORY}
        "${ITK_EXTRA_TCL_WRAP}" ${LIBRARY_NAME}Tcl "${MASTER_IDX}" "${ALL_IDX_FILES}")
    ENDIF(ITK_EXTRA_TCL_WRAP)
  ENDIF(WRAP_ITK_TCL)

  IF(WRAP_ITK_PERL)
    # perl
    WRAP_PERL_SOURCES(${SOURCE_DIR}/${DIRECTORY} ${BINARY_DIR}/${DIRECTORY}
      wrap_${LIBRARY_NAME}Perl ${LIBRARY_NAME}Perl "${MASTER_IDX}" "${ALL_IDX_FILES}")
    IF(ITK_EXTRA_PERL_WRAP)
      WRAP_PERL_SOURCES(${SOURCE_DIR}/${DIRECTORY} ${BINARY_DIR}/${DIRECTORY}
        "${ITK_EXTRA_PERL_WRAP}" ${LIBRARY_NAME}Perl "${MASTER_IDX}" "${ALL_IDX_FILES}")
    ENDIF(ITK_EXTRA_PERL_WRAP)
  ENDIF(WRAP_ITK_PERL)
   
  IF(WRAP_ITK_PYTHON)
    # python
    WRAP_PYTHON_SOURCES(${SOURCE_DIR}/${DIRECTORY} ${BINARY_DIR}/${DIRECTORY}
      wrap_${LIBRARY_NAME}Python _${LIBRARY_NAME}Python "${MASTER_IDX}" "${ALL_IDX_FILES}")
    IF(ITK_EXTRA_PYTHON_WRAP)
      FOREACH( extraPython ${ITK_EXTRA_PYTHON_WRAP})
        WRAP_PYTHON_SOURCES(${SOURCE_DIR}/${DIRECTORY} ${BINARY_DIR}/${DIRECTORY}
          ${extraPython} _${LIBRARY_NAME}Python "${MASTER_IDX}" "${ALL_IDX_FILES}")
      ENDFOREACH( extraPython )
    ENDIF(ITK_EXTRA_PYTHON_WRAP)

  ENDIF(WRAP_ITK_PYTHON)

  IF(WRAP_ITK_JAVA)
    # python
    WRAP_JAVA_SOURCES(${SOURCE_DIR}/${DIRECTORY} ${BINARY_DIR}/${DIRECTORY}
      wrap_${LIBRARY_NAME}Java ${LIBRARY_NAME}Java "${MASTER_IDX}" "${ALL_IDX_FILES}")
  ENDIF(WRAP_ITK_JAVA)

ENDMACRO(ITK_WRAP_LIBRARY)

#------------------------------------------------------------------------------

