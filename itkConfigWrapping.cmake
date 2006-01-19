###############################################################################
# itkConfigWrapping.cmake
#
# This file sets up all needed macros, paths, and so forth for wrapping itk
# projects.
#
# The following variables should be set before including this file:
# WRAP_ITK_TCL 
# WRAP_ITK_PYTHON 
# WRAP_ITK_JAVA 
# WRAP_unsigned_char
# WRAP_unsigned_short 
# WRAP_unsigned_long 
# WRAP_signed_char 
# WRAP_signed_short 
# WRAP_signed_long 
# WRAP_float 
# WRAP_double 
# WRAP_vector_float 
# WRAP_vector_double
# WRAP_covariant_vector_float 
# WRAP_covariant_vector_double 
# WRAP_DIMS
# ITK_SWG_FILES 
# WRAP_ITK_JAVA_DIR -- directory for java classes to be placed
# WRAP_ITK_CONFIG_DIR -- directory where XXX.in files for CONFIGURE_FILE
#                        commands are to be found.
# WRAP_ITK_CMAKE_DIR -- directory where XXX.cmake files are to be found
# WRAP_ITK_INSTALL_LOCATION -- directory where wrapper files should be installed
#    (Install will be in ${CMAKE_INSTALL_PREFIX}/${WRAP_ITK_INSTALL_LOCATION}/${lang} )
#
# Additionally, LINK_DIRECTORIES must include the path to libSwigRuntimeXXX.dylib
# (This is automatic for WrapITK, but not for external projects.)
#
# This file sets, among others, WRAP_ITK_SWIG_INCLUDE_DIRS.
# Modify this variable to add more include directories for SWIG.
###############################################################################


###############################################################################
# Find Required Packages
###############################################################################

#-----------------------------------------------------------------------------
# Find ITK
#-----------------------------------------------------------------------------
FIND_PACKAGE(ITK)
IF(ITK_FOUND)
  INCLUDE(${ITK_USE_FILE})
ELSE(ITK_FOUND)
  MESSAGE(FATAL_ERROR
          "Cannot build without ITK.  Please set ITK_DIR.")
ENDIF(ITK_FOUND)

#-----------------------------------------------------------------------------
# Load the CableSwig settings used by ITK, or find CableSwig otherwise.
#-----------------------------------------------------------------------------
#
SET(CableSwig_DIR ${ITK_CableSwig_DIR})
FIND_PACKAGE(CableSwig)

IF(NOT CableSwig_FOUND)
  # We have not found CableSwig.  Complain.
  MESSAGE(FATAL_ERROR "CableSwig is required for ITK Wrapping.")
ENDIF(NOT CableSwig_FOUND)

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

#-----------------------------------------------------------------------------
# Find wrapping language API libraries.
#-----------------------------------------------------------------------------
IF(WRAP_ITK_TCL)
  FIND_PACKAGE(TCL)
  # Hide useless settings provided by FindTCL.
  FOREACH(entry TCL_LIBRARY_DEBUG
                TK_LIBRARY_DEBUG
                TCL_STUB_LIBRARY
                TCL_STUB_LIBRARY_DEBUG
                TK_STUB_LIBRARY
                TK_STUB_LIBRARY_DEBUG
                TK_WISH)
    SET(${entry} "${${entry}}" CACHE INTERNAL "This value is not used by ITK.")
  ENDFOREACH(entry)
ENDIF(WRAP_ITK_TCL)

IF(WRAP_ITK_PYTHON)
  FIND_PACKAGE(PythonLibs)
  FIND_PACKAGE(PythonInterp)
  MARK_AS_ADVANCED(PYTHON_EXECUTABLE)
ENDIF(WRAP_ITK_PYTHON)

IF(WRAP_ITK_JAVA)
  FIND_PACKAGE(Java)
  FIND_PACKAGE(JNI)
ENDIF(WRAP_ITK_JAVA)


#------------------------------------------------------------------------------
# make sure required stuff is set
SET(WRAP_ITK_SWIG_INCLUDE_DIRS ${ITK_INCLUDE_DIRS})

IF(WRAP_ITK_TCL)
  SET(WRAP_ITK_SWIG_INCLUDE_DIRS ${WRAP_ITK_SWIG_INCLUDE_DIRS} ${TCL_INCLUDE_PATH} ${TK_INCLUDE_PATH})
  INCLUDE_DIRECTORIES(${TCL_INCLUDE_PATH} ${TK_INCLUDE_PATH})
ENDIF(WRAP_ITK_TCL)

IF(WRAP_ITK_PYTHON)
  # Python include directory.
  SET(WRAP_ITK_SWIG_INCLUDE_DIRS ${WRAP_ITK_SWIG_INCLUDE_DIRS}
    ${PYTHON_INCLUDE_PATH})
  INCLUDE_DIRECTORIES(${PYTHON_INCLUDE_PATH} )
ENDIF(WRAP_ITK_PYTHON)

IF(WRAP_ITK_PERL)
  INCLUDE_DIRECTORIES(${PERL_INCLUDE_PATH})
ENDIF(WRAP_ITK_PERL)

IF(WRAP_ITK_JAVA)
  # Java include directories.
  SET(WRAP_ITK_SWIG_INCLUDE_DIRS ${WRAP_ITK_SWIG_INCLUDE_DIRS}
      ${JAVA_INCLUDE_PATH} ${JAVA_INCLUDE_PATH2} ${JAVA_AWT_INCLUDE_PATH})
  INCLUDE_DIRECTORIES(${JAVA_INCLUDE_PATH} ${JAVA_INCLUDE_PATH2} ${JAVA_AWT_INCLUDE_PATH})
ENDIF(WRAP_ITK_JAVA)

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
         ${WRAP_ITK_CONFIG_DIR}/empty.depend.in
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
       ${WRAP_ITK_CONFIG_DIR}/empty.depend.in
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

   ADD_CUSTOM_COMMAND(
     COMMENT "${OutputTclCxx} from "
     SOURCE ${Bin}/${InputIdx}
     COMMAND ${CSWIG}
     ARGS ${ITK_SWG_FILE}
          -I${ITK_SWIG_DEFAULT_LIB}
          -I${ITK_SWIG_DEFAULT_LIB}/tcl
          -noruntime ${CINDEX} ${CSWIG_IGNORE_WARNINGS} -depend ${Bin}/${InputXml}.depend
          -outdir "${LIBRARY_OUTPUT_PATH}/${CMAKE_CFG_INTDIR}"
          -o ${Bin}/${OutputTclCxx} -tcl -pkgversion "${ITK_VERSION_STRING}" -c++ ${Bin}/${InputXml}
     TARGET ${Library}
     OUTPUTS ${Bin}/${OutputTclCxx}
     DEPENDS ${LibraryIndexFiles} ${ITK_SWG_FILES} ${Bin}/${InputXml} ${CSWIG})
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

   ADD_CUSTOM_COMMAND(
     COMMENT "${OutputPerlCxx} from "
     SOURCE ${Bin}/${InputIdx}
     COMMAND ${CSWIG}
     ARGS -perl5
          ${ITK_SWG_FILE}
          -I${ITK_SWIG_DEFAULT_LIB}
          -noruntime ${CINDEX} ${CSWIG_IGNORE_WARNINGS} -depend ${Bin}/${InputXml}.depend
          -outdir "${LIBRARY_OUTPUT_PATH}/${CMAKE_CFG_INTDIR}"
          -o ${Bin}/${OutputPerlCxx} -c++ ${Bin}/${InputXml}
     TARGET ${Library}
     OUTPUTS ${Bin}/${OutputPerlCxx}
     DEPENDS ${LibraryIndexFiles} ${ITK_SWG_FILES} ${Bin}/${InputXml} ${CSWIG})
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
          -outdir "${LIBRARY_OUTPUT_PATH}/${CMAKE_CFG_INTDIR}" 
          -o ${Bin}/${OutputTclCxx} -python -c++ ${Bin}/${InputXml}
     TARGET ${Library}
     OUTPUTS ${Bin}/${OutputTclCxx}
     DEPENDS ${LibraryIndexFiles}  ${ITK_SWG_FILES} ${Bin}/${InputXml} ${CSWIG})
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
          -outdir ${WRAP_ITK_JAVA_DIR}/InsightToolkit
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
   INSTALL_FILES("${WRAP_ITK_INSTALL_LOCATION}/ClassIndex" FILES "${Bin}/${BaseName}.idx")
   STRING(REGEX REPLACE "wrap_" "" swig_language_file "${BaseName}")
   INSTALL_FILES("${WRAP_ITK_INSTALL_LOCATION}/Tcl-SWIG" FILES "${LIBRARY_OUTPUT_PATH}/${CMAKE_CFG_INTDIR}/${swig_language_file}.tcl")
ENDMACRO(WRAP_TCL_SOURCES)

# macro to create .xml, .idx and Tcl.cxx files
MACRO(WRAP_PERL_SOURCES Source Bin BaseName LibraryName MasterIdx LibraryIndexFiles)
   GCCXML_CREATE_XML_FILE(${Source} ${Bin} ${BaseName}.cxx ${BaseName}.xml ${LibraryName})
   CINDEX_CREATE_IDX_FILE(${Bin} ${BaseName}.xml  ${BaseName}.idx ${LibraryName})
   CSWIG_CREATE_PERL_CXX_FILE(${Bin} "${MasterIdx}" ${BaseName}.idx ${BaseName}.xml
                             ${BaseName}Perl.cxx ${LibraryName} "${LibraryIndexFiles}")
   INSTALL_FILES("${WRAP_ITK_INSTALL_LOCATION}/ClassIndex" FILES "${Bin}/${BaseName}.idx")
   STRING(REGEX REPLACE "wrap_" "" swig_language_file "${BaseName}")
   INSTALL_FILES("${WRAP_ITK_INSTALL_LOCATION}/Perl-SWIG" FILES "${LIBRARY_OUTPUT_PATH}/${CMAKE_CFG_INTDIR}/${swig_language_file}.pl")
ENDMACRO(WRAP_PERL_SOURCES)

# macro to create .xml, .idx and Python.cxx files
MACRO(WRAP_PYTHON_SOURCES Source Bin BaseName LibraryName MasterIdx LibraryIndexFiles)
   GCCXML_CREATE_XML_FILE(${Source} ${Bin} ${BaseName}.cxx ${BaseName}.xml ${LibraryName})
   CINDEX_CREATE_IDX_FILE(${Bin} ${BaseName}.xml  ${BaseName}.idx ${LibraryName})
   CSWIG_CREATE_PYTHON_CXX_FILE(${Bin} "${MasterIdx}" ${BaseName}.idx ${BaseName}.xml
                             ${BaseName}Python.cxx ${LibraryName} "${LibraryIndexFiles}")
   INSTALL_FILES("${WRAP_ITK_INSTALL_LOCATION}/ClassIndex" FILES "${Bin}/${BaseName}.idx")
   STRING(REGEX REPLACE "wrap_" "" swig_language_file "${BaseName}")
   INSTALL_FILES("${WRAP_ITK_INSTALL_LOCATION}/Python-SWIG" FILES "${LIBRARY_OUTPUT_PATH}/${CMAKE_CFG_INTDIR}/${swig_language_file}.py")
ENDMACRO(WRAP_PYTHON_SOURCES)

# macro to create .xml, .idx and Python.cxx files
MACRO(WRAP_JAVA_SOURCES Source Bin BaseName LibraryName MasterIdx LibraryIndexFiles)
   GCCXML_CREATE_XML_FILE(${Source} ${Bin} ${BaseName}.cxx ${BaseName}.xml ${LibraryName})
   CINDEX_CREATE_IDX_FILE(${Bin} ${BaseName}.xml  ${BaseName}.idx ${LibraryName})
   CSWIG_CREATE_JAVA_CXX_FILE(${Bin} "${MasterIdx}" ${BaseName}.idx ${BaseName}.xml
                             ${BaseName}Java.cxx ${LibraryName} "${LibraryIndexFiles}")
   INSTALL_FILES("${WRAP_ITK_INSTALL_LOCATION}/ClassIndex" FILES "${Bin}/${BaseName}.idx")
   STRING(REGEX REPLACE "wrap_" "" swig_language_file "${BaseName}")
   INSTALL_FILES("${WRAP_ITK_INSTALL_LOCATION}/Java-SWIG" FILES "${WRAP_ITK_JAVA_DIR}/InsightToolkit/${swig_language_file}.java")
ENDMACRO(WRAP_JAVA_SOURCES)

#------------------------------------------------------------------------------
MACRO(ITK_WRAP_LIBRARY SRCS LIBRARY_NAME DIRECTORY DEPEND_LIBRARY EXTRA_SOURCES ITK_LINK_LIBRARIES MASTER_IDX SOURCE_DIR BINARY_DIR)
  # Work around CMake bug where CMake doesn't understand paths to generated files (e.g. not yet extant)
  # if those paths have a '//' or '/./' motif in them
  IF("${DIRECTORY}" MATCHES "^[\\.]?$")
    SET(Source_Directory "${SOURCE_DIR}")
    SET(Binary_Directory "${BINARY_DIR}")
  ELSE("${DIRECTORY}" MATCHES "^[\\.]?$")
    SET(Source_Directory "${SOURCE_DIR}/${DIRECTORY}")
    SET(Binary_Directory "${BINARY_DIR}/${DIRECTORY}")
  ENDIF("${DIRECTORY}" MATCHES "^[\\.]?$")
  
  SET(WRAP_SOURCES)
  FOREACH(src ${SRCS})
    SET(WRAP_SOURCES ${WRAP_SOURCES} wrap_${src})
  ENDFOREACH(src)
  
  # loop over cable config files creating two lists:
  # WRAP_TCL_SOURCES: list of generated files
  SET(INDEX_FILE_CONTENT "%JavaLoader=InsightToolkit.itkbase.LoadLibrary(\"${LIBRARY_NAME}Java\")\n")
  SET(INSTALL_INDEX_FILE_CONTENT "%JavaLoader=InsightToolkit.itkbase.LoadLibrary(\"${LIBRARY_NAME}Java\")\n")
  FOREACH(Source ${WRAP_SOURCES})
    SET(WRAP_PERL_SOURCES ${WRAP_PERL_SOURCES} ${Source}Perl.cxx)
    SET(WRAP_TCL_SOURCES ${WRAP_TCL_SOURCES} ${Source}Tcl.cxx)
    SET(WRAP_PYTHON_SOURCES ${WRAP_PYTHON_SOURCES} ${Source}Python.cxx)
    SET(WRAP_JAVA_SOURCES ${WRAP_JAVA_SOURCES} ${Source}Java.cxx)
    STRING(REGEX REPLACE wrap_ "" JAVA_DEP ${Source})
    SET(${LIBRARY_NAME}_JAVA_DEPENDS_INIT ${${LIBRARY_NAME}_JAVA_DEPENDS_INIT} ${JAVA_DEP}.java)
    SET(ALL_IDX_FILES ${ALL_IDX_FILES} ${Binary_Directory}/${Source}.idx )
    SET(INDEX_FILE_CONTENT "${INDEX_FILE_CONTENT}${Binary_Directory}/${Source}.idx\n")
    SET(INSTALL_INDEX_FILE_CONTENT "${INSTALL_INDEX_FILE_CONTENT}${CMAKE_INSTALL_PREFIX}${WRAP_ITK_INSTALL_LOCATION}/ClassIndex/${Source}.idx\n")
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
  
  # Try to extract the module name from the ITK_SWIG_FILE path... this assumes
  # that the module name is the same as the file name, less the .i extension.
  GET_FILENAME_COMPONENT(itk_swig_file_module "${ITK_SWIG_FILE}" NAME_WE)

  IF(WRAP_ITK_TCL)
    IF(ITK_SWIG_FILE)
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
    INSTALL_TARGETS("${WRAP_ITK_INSTALL_LOCATION}/Tcl-SWIG" ${LIBRARY_NAME}Tcl )
    IF(ITK_SWIG_FILE)
      ADD_CUSTOM_COMMAND(
        COMMENT "run native swig on ${ITK_SWIG_FILE}"
        SOURCE ${ITK_SWIG_FILE}
        COMMAND ${CSWIG}
        ARGS -nocable -noruntime ${CSWIG_IGNORE_WARNINGS} -o ${WRAP_FILE}
        -c++ ${ITK_SWIG_FILE}
        -outdir "${LIBRARY_OUTPUT_PATH}/${CMAKE_CFG_INTDIR}"
        TARGET ${LIBRARY_NAME}Tcl
        OUTPUTS ${WRAP_FILE}
        DEPENDS ${ITK_SWIG_FILE} ${CSWIG})
        INSTALL_FILES("${WRAP_ITK_INSTALL_LOCATION}/Tcl-SWIG" FILES "${LIBRARY_OUTPUT_PATH}/${CMAKE_CFG_INTDIR}/${itk_swig_file_module}.tcl")
    ENDIF(ITK_SWIG_FILE)
  ENDIF(WRAP_ITK_TCL)


  IF(WRAP_ITK_PERL)
    IF(ITK_SWIG_FILE)
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
    INSTALL_TARGETS("${WRAP_ITK_INSTALL_LOCATION}/Perl-SWIG" ${LIBRARY_NAME}Perl )
    IF(ITK_SWIG_FILE)
      ADD_CUSTOM_COMMAND(
        COMMENT "run native swig on ${ITK_SWIG_FILE}"
        SOURCE ${ITK_SWIG_FILE}
        COMMAND ${CSWIG} 
        ARGS -nocable -noruntime ${CSWIG_IGNORE_WARNINGS} -o ${WRAP_FILE}
        -perl5 -c++ ${ITK_SWIG_FILE}
        -outdir "${LIBRARY_OUTPUT_PATH}/${CMAKE_CFG_INTDIR}"
        TARGET ${LIBRARY_NAME}Perl
        OUTPUTS ${WRAP_FILE}
        DEPENDS ${ITK_SWIG_FILE} ${CSWIG})
        INSTALL_FILES("${WRAP_ITK_INSTALL_LOCATION}/Perl-SWIG" FILES "${LIBRARY_OUTPUT_PATH}/${CMAKE_CFG_INTDIR}/${itk_swig_file_module}.pl")
    ENDIF(ITK_SWIG_FILE)
  ENDIF(WRAP_ITK_PERL)


  IF(WRAP_ITK_PYTHON)  
    IF(ITK_SWIG_FILE)
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
    INSTALL_TARGETS("${WRAP_ITK_INSTALL_LOCATION}/Python-SWIG" _${LIBRARY_NAME}Python) 
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
        INSTALL_FILES("${WRAP_ITK_INSTALL_LOCATION}/Python-SWIG" FILES "${LIBRARY_OUTPUT_PATH}/${CMAKE_CFG_INTDIR}/${itk_swig_file_module}.py")
    ENDIF(ITK_SWIG_FILE)
  ENDIF(WRAP_ITK_PYTHON)

  IF(WRAP_ITK_JAVA)  
    IF(ITK_SWIG_FILE)
      SET_SOURCE_FILES_PROPERTIES(${ITK_SWIG_FILE_CXX}Java.cxx GENERATED)
      SET(WRAP_FILE ${ITK_SWIG_FILE_CXX}Java.cxx )
    ENDIF(ITK_SWIG_FILE)
    MAKE_DIRECTORY("${WRAP_ITK_JAVA_DIR}/InsightToolkit")
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
    INSTALL_TARGETS("${WRAP_ITK_INSTALL_LOCATION}/Java-SWIG" ${LIBRARY_NAME}Java)
    IF(ITK_SWIG_FILE)
      ADD_CUSTOM_COMMAND(
        COMMENT "run native swig on ${ITK_SWIG_FILE}"
        SOURCE ${ITK_SWIG_FILE}
        COMMAND ${CSWIG} 
        ARGS -nocable -noruntime ${CSWIG_IGNORE_WARNINGS} -o ${WRAP_FILE}
        -I${ITK_SOURCE_DIR}/Code/Common -DITKCommon_EXPORT=
        -outdir ${WRAP_ITK_JAVA_DIR}/InsightToolkit
        -package InsightToolkit -java -c++ ${ITK_SWIG_FILE}
        TARGET ${LIBRARY_NAME}Java
        OUTPUTS ${WRAP_FILE}
        DEPENDS ${ITK_SWIG_FILE} ${CSWIG})
        INSTALL_FILES("${WRAP_ITK_INSTALL_LOCATION}/Java-SWIG" FILES "${LIBRARY_OUTPUT_PATH}/${CMAKE_CFG_INTDIR}/${itk_swig_file_module}.java")
    ENDIF(ITK_SWIG_FILE)
  ENDIF(WRAP_ITK_JAVA)
  
  CONFIGURE_FILE(
    ${WRAP_ITK_CONFIG_DIR}/Master.mdx.in
    ${Binary_Directory}/${LIBRARY_NAME}.mdx IMMEDIATE
    )
  SET(INDEX_FILE_CONTENT ${INSTALL_INDEX_FILE_CONTENT})
  CONFIGURE_FILE(
    ${WRAP_ITK_CONFIG_DIR}/Master.mdx.in
    ${Binary_Directory}/InstallOnly/${LIBRARY_NAME}.mdx IMMEDIATE
    )
   INSTALL_FILES("${WRAP_ITK_INSTALL_LOCATION}/ClassIndex" FILES "${Binary_Directory}/InstallOnly/${LIBRARY_NAME}.mdx")

  SET(SWIG_INC_FILE ${Binary_Directory}/SwigInc.txt)
  SET(SWIG_INC_CONTENTS)
  FOREACH(dir ${WRAP_ITK_SWIG_INCLUDE_DIRS})
    SET(SWIG_INC_CONTENTS "${SWIG_INC_CONTENTS}-I${dir}\n")
  ENDFOREACH(dir)
  CONFIGURE_FILE(${WRAP_ITK_CONFIG_DIR}/SwigInc.txt.in ${SWIG_INC_FILE}
    @ONLY IMMEDIATE)
  
  FOREACH(Source ${WRAP_SOURCES})
    IF(WRAP_ITK_TCL)
      # tcl
      WRAP_TCL_SOURCES(${Source_Directory} ${Binary_Directory}
        ${Source} ${LIBRARY_NAME}Tcl "${MASTER_IDX}" "${ALL_IDX_FILES}")
    ENDIF(WRAP_ITK_TCL)

    IF(WRAP_ITK_PERL)
      # tcl
      WRAP_PERL_SOURCES(${Source_Directory} ${Binary_Directory}
        ${Source} ${LIBRARY_NAME}Perl "${MASTER_IDX}" "${ALL_IDX_FILES}")
    ENDIF(WRAP_ITK_PERL)
    
    IF(WRAP_ITK_PYTHON)
      # python
      WRAP_PYTHON_SOURCES(${Source_Directory} ${Binary_Directory}
        ${Source} _${LIBRARY_NAME}Python "${MASTER_IDX}" "${ALL_IDX_FILES}")
    ENDIF(WRAP_ITK_PYTHON)
    
    IF(WRAP_ITK_JAVA)
      # java
      WRAP_JAVA_SOURCES(${Source_Directory} ${Binary_Directory}
        ${Source} ${LIBRARY_NAME}Java "${MASTER_IDX}" "${ALL_IDX_FILES}")
    ENDIF(WRAP_ITK_JAVA)
  ENDFOREACH(Source)
  
  
  # wrap the package files for tcl and python
  IF(WRAP_ITK_TCL)
    # tcl
    WRAP_TCL_SOURCES(${Source_Directory} ${Binary_Directory}
      wrap_${LIBRARY_NAME}Tcl ${LIBRARY_NAME}Tcl "${MASTER_IDX}" "${ALL_IDX_FILES}")
    IF(ITK_EXTRA_TCL_WRAP)
      WRAP_TCL_SOURCES(${Source_Directory} ${Binary_Directory}
        "${ITK_EXTRA_TCL_WRAP}" ${LIBRARY_NAME}Tcl "${MASTER_IDX}" "${ALL_IDX_FILES}")
    ENDIF(ITK_EXTRA_TCL_WRAP)
  ENDIF(WRAP_ITK_TCL)

  IF(WRAP_ITK_PERL)
    # perl
    WRAP_PERL_SOURCES(${Source_Directory} ${Binary_Directory}
      wrap_${LIBRARY_NAME}Perl ${LIBRARY_NAME}Perl "${MASTER_IDX}" "${ALL_IDX_FILES}")
    IF(ITK_EXTRA_PERL_WRAP)
      WRAP_PERL_SOURCES(${Source_Directory} ${Binary_Directory}
        "${ITK_EXTRA_PERL_WRAP}" ${LIBRARY_NAME}Perl "${MASTER_IDX}" "${ALL_IDX_FILES}")
    ENDIF(ITK_EXTRA_PERL_WRAP)
  ENDIF(WRAP_ITK_PERL)
   
  IF(WRAP_ITK_PYTHON)
    # python
    WRAP_PYTHON_SOURCES(${Source_Directory} ${Binary_Directory}
      wrap_${LIBRARY_NAME}Python _${LIBRARY_NAME}Python "${MASTER_IDX}" "${ALL_IDX_FILES}")
    IF(ITK_EXTRA_PYTHON_WRAP)
      FOREACH( extraPython ${ITK_EXTRA_PYTHON_WRAP})
        WRAP_PYTHON_SOURCES(${Source_Directory} ${Binary_Directory}
          ${extraPython} _${LIBRARY_NAME}Python "${MASTER_IDX}" "${ALL_IDX_FILES}")
      ENDFOREACH( extraPython )
    ENDIF(ITK_EXTRA_PYTHON_WRAP)

  ENDIF(WRAP_ITK_PYTHON)

  IF(WRAP_ITK_JAVA)
    # python
    WRAP_JAVA_SOURCES(${Source_Directory} ${Binary_Directory}
      wrap_${LIBRARY_NAME}Java ${LIBRARY_NAME}Java "${MASTER_IDX}" "${ALL_IDX_FILES}")
  ENDIF(WRAP_ITK_JAVA)

ENDMACRO(ITK_WRAP_LIBRARY)

#------------------------------------------------------------------------------
# Include other needed macros -- WRAP_ITK_CMAKE_DIR must be set correctly
INCLUDE("${WRAP_ITK_CMAKE_DIR}/WrapTypeBase.cmake")
INCLUDE("${WRAP_ITK_CMAKE_DIR}/WrapITK.cmake")
INCLUDE("${WRAP_ITK_CMAKE_DIR}/WrapITKLang.cmake")
INCLUDE("${WRAP_ITK_CMAKE_DIR}/WrapTypePrefix.cmake")

