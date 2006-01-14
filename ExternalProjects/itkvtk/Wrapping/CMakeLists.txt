#------------------------------------------------------------------------------
FIND_PACKAGE(CableSwig)
SET(CMAKE_MODULE_PATH ${CableSwig_DIR}/SWIG/CMake)
SET(SWIG_INC ${VTK_INCLUDE_DIRS} ${ITK_INCLUDE_DIRS}
                    ${itkvtk_SOURCE_DIR}
  )
#------------------------------------------------------------------------------
INCLUDE("${ITK_SOURCE_DIR}/Wrapping/CSwig/itkConfigWrapping.cmake")
INCLUDE("${ITK_SOURCE_DIR}/Wrapping/CSwig/WrapTypeBase.cmake")
INCLUDE("${ITK_SOURCE_DIR}/Wrapping/CSwig/WrapITK.cmake")
INCLUDE("${ITK_SOURCE_DIR}/Wrapping/CSwig/WrapTypePrefix.cmake")

#------------------------------------------------------------------------------
SET(MODULE_NAME "ItkVtk")
SET(ITK_LIBRARY "${MODULE_NAME}")
STRING(TOLOWER ${ITK_LIBRARY} ITK_LIBRARY_LANG)
SET(ITK_LANG_FILE "${itkvtk_BINARY_DIR}/Wrapping/${ITK_LIBRARY}")
SET(WrapITK_PART_DIR "${itkvtk_BINARY_DIR}/Wrapping")

SET(ITK_CSWIG_PYTHON ${WRAP_PYTHON})
IF(ITK_CSWIG_PYTHON)
  FIND_PACKAGE(PythonLibs)
  INCLUDE_DIRECTORIES(${PYTHON_INCLUDE_PATH})
  INSTALL_FILES(/lib/InsightToolkit/python FILES "${itkvtk_BINARY_DIR}/Wrapping/${MODULE_NAME}Py.py")
  INSTALL_FILES(/lib/InsightToolkit/python FILES "${itkvtk_BINARY_DIR}/Wrapping/${MODULE_NAME}.py")
  INSTALL_FILES(/lib/InsightToolkit FILES "${itkvtk_BINARY_DIR}/bin/ITK${MODULE_NAME}Python.py")
  INSTALL_FILES(/lib/InsightToolkit/python FILES "${itkvtk_SOURCE_DIR}/Wrapping/Python/${ITK_LIBRARY_LANG}.py")
ENDIF(ITK_CSWIG_PYTHON)



WRITE_LANG_BEGIN(${ITK_LIBRARY})

#------------------------------------------------------------------------------
# create a list of groups
# Add here modules that must be imported before the others.
SET(WRAP_GROUPS
  # nothing to add here for now
)
  
# include every wrap_*.cmake files in the directory
AUTO_INCLUDE_WRAP_CMAKE(WRAP_GROUPS "")
  

#------------------------------------------------------------------------------
# create the wrap_ITKBasicFilters*.cxx files
WRITE_MODULE("ItkVtk" "${WrapITK_PART_DIR}" "${WRAP_GROUPS}")

#------------------------------------------------------------------------------
# create the ITKBasicFilters libraries
FOREACH(file ${WRAP_GROUPS})
  IF(ITK_CSWIG_PYTHON)
    INSTALL_FILES(/lib/InsightToolkit/python FILES "${itkvtk_BINARY_DIR}/bin/${file}.py")
  ENDIF(ITK_CSWIG_PYTHON)
ENDFOREACH(file ${WRAP_GROUPS})
   
SET(SWIG_INC
   ${SWIG_INC}
   ${ITK_INCLUDE_DIRS}
   ${itkvtk_SOURCE_DIR}/src
   ${VTK_INCLUDE_DIRS}
)


SET(MASTER_INDEX_FILES
	 ${ITK_MASTER_INDEX_FILES}
	 ${itkvtk_BINARY_DIR}/Wrapping/ITKItkVtk.mdx
)

SET(ITK_SWG_FILES ${ITK_SWG_FILES} "${itkvtk_SOURCE_DIR}/Wrapping/itk.swg")


ITK_WRAP_LIBRARY("${WRAP_GROUPS}" "ITK${MODULE_NAME}"
"Wrapping" "" "" "${ITK_LIBRARIES}"
  "${MASTER_INDEX_FILES}" "${itkvtk_SOURCE_DIR}"
"${itkvtk_BINARY_DIR}")

#------------------------------------------------------------------------------
WRITE_LANG_END()

#------------------------------------------------------------------------------
IF(ITK_CSWIG_PYTHON)
   FILE(WRITE ${ITK_LANG_FILE}.py
      "from InsightToolkit import *\n"
      "from vtk import *\n"
      "\n"
      "__itk_import_data__ = itkbase.preimport()\n"
      "from ITK${MODULE_NAME}Python import *\n"
      "itkbase.postimport(__itk_import_data__)\n"
   )
ENDIF(ITK_CSWIG_PYTHON)

