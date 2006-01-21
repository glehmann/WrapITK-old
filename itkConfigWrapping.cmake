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
# WRAP_ITK_SWG_FILES 
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
# This file sets, among others, WRAP_ITK_GCCXML_INCLUDE_DIRS.
# Modify this variable to add more include directories for gcc_xml.
# This file also sets a default value for WRAPPER_MASTER_INDEX_OUTPUT_DIR.
# Change it after including this file if needed.
#
# A note on convention: Global variables (those shared between macros) are
# defined in ALL_CAPS (or partially all-caps, for the WRAP_pixel_type) values
# listed above. Variables local to a macro are in lower-case.
# Moreover, only variables defined in this file (or listed) above are shared
# across macros defined in different files. All other global variables are
# only used by the macros defined in a given cmake file.
###############################################################################

###############################################################################
# Define fundamental wrapping macro which sets up the global variables used
# across all of the wrapping macros included at the end of this file. 
# All variables set here are optional and have sensible default values.
# Also define some other global defaults like WRAPPER_MASTER_INDEX_OUTPUT_DIR.
###############################################################################
MACRO(BEGIN_WRAPPER_LIBRARY library_name)
  SET(WRAPPER_LIBRARY_NAME "${library_name}")
  
  # WRAPPER_LIBRARY_SOURCE_DIR. Directory to be scanned for wrap_*.cmake files. 
  SET(WRAPPER_LIBRARY_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}")

  # WRAPPER_LIBRARY_OUTPUT_DIR. Directory in which generated cxx, xml, and idx
  # files will be placed. 
  SET(WRAPPER_LIBRARY_OUTPUT_DIR "${CMAKE_CURRENT_BINARY_DIR}")

  # WRAPPER_LIBRARY_AUTO_LOAD. Controls whether this library will be auto-loaded
  # by language support files.
  SET(WRAPPER_LIBRARY_AUTO_LOAD ON) 

  # WRAPPER_LIBRARY_DEPENDS. List of names of other wrapper libraries that
  # define symbols used by this wrapper library. Note that there's always an implied 
  # dependence on VXLNumerics.
  SET(WRAPPER_LIBRARY_DEPENDS)

  # WRAPPER_LIBRARY_LINK_LIBRARIES. List of other libraries that should
  # be linked to the wrapper library.
    SET(WRAPPER_LIBRARY_LINK_LIBRARIES )

  # WRAPPER_LIBRARY_GROUPS. List of wrap_*.cmake groups in the source dir
  # that should be included/wrapped before the rest. Just the group name is needed,
  # not the full path or file name. 
  SET(WRAPPER_LIBRARY_GROUPS )

  # WRAPPER_LIBRARY_CABLESWIG_INPUTS. List of C++ source files to be used
  # as input for CableSwig. This list is then appended to by
  # WRAPPER_LIBRARY_AUTO_INCLUDE_WRAP_FILES. A full path to each input is required.
  SET(WRAPPER_LIBRARY_CABLESWIG_INPUTS )

  # WRAPPER_LIBRARY_SWIG_INPUTS. SWIG input files to be fed to swig (not
  # CableSwig). A full path to each input is required.
  SET(WRAPPER_LIBRARY_SWIG_INPUTS ) 

  # WRAPPER_LIBRARY_CXX_SOURCES. C++ sources to be compiled and linked in
  # to the wrapper library (with no prior processing by swig, etc.)
  # A full path to each input is required.
  SET(WRAPPER_LIBRARY_CXX_SOURCES ) 

ENDMACRO(BEGIN_WRAPPER_LIBRARY)

SET(WRAPPER_MASTER_INDEX_OUTPUT_DIR "${PROJECT_BINARY_DIR}/MasterIndex")

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


###############################################################################
# Set various variables in order
###############################################################################
# set the default include files for the generated wrapper files
SET(WRAPPER_DEFAULT_INCLUDE
  Offset
  Vector
  CovariantVector
  ContinuousIndex
  Array
  FixedArray
  RGBPixel
  Image
  Point
  LevelSet
  BinaryBallStructuringElement
  SpatialObject
)

# make sure required stuff is set
SET(WRAP_ITK_GCCXML_INCLUDE_DIRS ${ITK_INCLUDE_DIRS})

# TODO: Not sure if it's necessary to add all the language-specific include dirs
# to the GCCXML_INCLUDE_DIRS...

IF(WRAP_ITK_TCL)
  SET(WRAP_ITK_GCCXML_INCLUDE_DIRS ${WRAP_ITK_GCCXML_INCLUDE_DIRS} ${TCL_INCLUDE_PATH} ${TK_INCLUDE_PATH})
  INCLUDE_DIRECTORIES(${TCL_INCLUDE_PATH} ${TK_INCLUDE_PATH})
ENDIF(WRAP_ITK_TCL)

IF(WRAP_ITK_PYTHON)
  # Python include directory.
  SET(WRAP_ITK_GCCXML_INCLUDE_DIRS ${WRAP_ITK_GCCXML_INCLUDE_DIRS}
    ${PYTHON_INCLUDE_PATH})
  INCLUDE_DIRECTORIES(${PYTHON_INCLUDE_PATH} )
ENDIF(WRAP_ITK_PYTHON)

IF(WRAP_ITK_PERL)
  INCLUDE_DIRECTORIES(${PERL_INCLUDE_PATH})
ENDIF(WRAP_ITK_PERL)

IF(WRAP_ITK_JAVA)
  # Java include directories.
  SET(WRAP_ITK_GCCXML_INCLUDE_DIRS ${WRAP_ITK_GCCXML_INCLUDE_DIRS}
      ${JAVA_INCLUDE_PATH} ${JAVA_INCLUDE_PATH2} ${JAVA_AWT_INCLUDE_PATH})
  INCLUDE_DIRECTORIES(${JAVA_INCLUDE_PATH} ${JAVA_INCLUDE_PATH2} ${JAVA_AWT_INCLUDE_PATH})
ENDIF(WRAP_ITK_JAVA)

#------------------------------------------------------------------------------
# System dependant wraping stuff
SET(ITK_WRAP_NEEDS_DEPEND 1)
IF(${CMAKE_MAKE_PROGRAM} MATCHES make)
  SET(ITK_WRAP_NEEDS_DEPEND 0)
ENDIF(${CMAKE_MAKE_PROGRAM} MATCHES make)

SET(CSWIG_DEFAULT_LIB ${CableSwig_DIR}/SWIG/Lib )

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


###############################################################################
# Include other needed macros -- WRAP_ITK_CMAKE_DIR must be set correctly
###############################################################################
INCLUDE("${WRAP_ITK_CMAKE_DIR}/CreateCableSwigInputs.cmake")
INCLUDE("${WRAP_ITK_CMAKE_DIR}/CreateWrapperLibrary.cmake")
INCLUDE("${WRAP_ITK_CMAKE_DIR}/CreateLanguageSupport.cmake")

###############################################################################
# Create wrapper names for simple types to ensure consistent naming
###############################################################################
INCLUDE("${WRAP_ITK_CMAKE_DIR}/WrapTypeBase.cmake")
INCLUDE("${WRAP_ITK_CMAKE_DIR}/WrapTypePrefix.cmake")

