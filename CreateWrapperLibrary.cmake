# Macro definitions for creating cableswig input libraries from cable-formatted
# input cxx files.
# Convention: Variable names in ALL_CAPS are global, and are shared between macros
# lower-case variable names indicate that that variable is to be considered local.

MACRO(WRAPPER_LIBRARY_CREATE_LIBRARY)
  
  # STEP 1
  # Make lists of all of the files that are to be generated
  
  # Add the generated module wrappers. These files are not included in the general
  # WRAPPER_LIBRARY_CABLESWIG_INPUTS list because they are specific for each language.
  SET(wrap_perl_sources "${WRAPPER_LIBRARY_OUTPUT_DIR}/${WRAPPER_LIBRARY_NAME}PerlPerl.cxx)
  SET(wrap_tcl_sources "${WRAPPER_LIBRARY_OUTPUT_DIR}/${WRAPPER_LIBRARY_NAME}PerlTcl.cxx)
  SET(wrap_python_sources "${WRAPPER_LIBRARY_OUTPUT_DIR}/${WRAPPER_LIBRARY_NAME}PerlPython.cxx)
  SET(wrap_java_sources "${WRAPPER_LIBRARY_OUTPUT_DIR}/${WRAPPER_LIBRARY_NAME}PerlJava.cxx)
  
  # Loop over cable config files creating three lists:
  # wrap_xxx_sources: list of generated files for each language
  # [install_]index_file_content: list of idx files which will be generated, to create 
  # the master index file from.
  # library_idx_files: differently-formatted list of idx files
  SET(index_file_content "%JavaLoader=InsightToolkit.itkbase.LoadLibrary(\"${WRAPPER_LIBRARY_NAME}Java\")\n")
  SET(install_index_file_content "%JavaLoader=InsightToolkit.itkbase.LoadLibrary(\"${WRAPPER_LIBRARY_NAME}Java\")\n")
  SET(library_idx_files)
  FOREACH(source ${WRAPPER_LIBRARY_CABLESWIG_INPUTS})
    GET_FILENAME_COMPONENT(base_name ${source} NAME_WE)
    SET(wrap_perl_sources ${wrap_perl_sources} "${WRAPPER_LIBRARY_OUTPUT_DIR}/${base_name}Perl.cxx)
    SET(wrap_tcl_sources ${wrap_tcl_sources} "${WRAPPER_LIBRARY_OUTPUT_DIR}/${base_name}Tcl.cxx)
    SET(wrap_python_sources ${wrap_python_sources} "${WRAPPER_LIBRARY_OUTPUT_DIR}/${base_name}Python.cxx)
    SET(wrap_java_sources ${wrap_java_sources} "${WRAPPER_LIBRARY_OUTPUT_DIR}/${base_name}Java.cxx)
    # add each source's name to a java dependencies list for later use
    STRING(REGEX REPLACE wrap_ "" JAVA_DEP ${base_name})
    SET(${WRAPPER_LIBRARY_NAME}_java_Depends_init ${${WRAPPER_LIBRARY_NAME}_java_Depends_init} ${JAVA_DEP}.java)
    SET(library_idx_files ${library_idx_files} "${WRAPPER_LIBRARY_OUTPUT_DIR}/${base_name}.idx" )
    SET(index_file_content "${index_file_content}${WRAPPER_LIBRARY_OUTPUT_DIR}/${base_name}.idx\n")
    SET(install_index_file_content "${install_index_file_content}${CMAKE_INSTALL_PREFIX}${WRAP_ITK_INSTALL_LOCATION}/ClassIndex/${base_name}.idx\n")
  ENDFOREACH(source)
  
  # Loop over the extra swig input files and add them to the generated files lists.
  FOREACH(source ${WRAPPER_LIBRARY_SWIG_INPUTS})
    GET_FILENAME_COMPONENT(base_name ${source} NAME_WE)
    SET(wrap_perl_sources ${wrap_perl_sources} "${WRAPPER_LIBRARY_OUTPUT_DIR}/${base_name}Perl.cxx)
    SET(wrap_tcl_sources ${wrap_tcl_sources} "${WRAPPER_LIBRARY_OUTPUT_DIR}/${base_name}Tcl.cxx)
    SET(wrap_python_sources ${wrap_python_sources} "${WRAPPER_LIBRARY_OUTPUT_DIR}/${base_name}Python.cxx)
    SET(wrap_java_sources ${wrap_java_sources} "${WRAPPER_LIBRARY_OUTPUT_DIR}/${base_name}Java.cxx)
  ENDFOREACH(source)

  SET(${WRAPPER_LIBRARY_NAME}_JAVA_DEPENDS  "${${WRAPPER_LIBRARY_NAME}_java_Depends_init}" CACHE INTERNAL "" FORCE)

  # Mark each of the generated sources as being generated, so CMake knows not to
  # expect them to already exist.
  SET_SOURCE_FILES_PROPERTIES(
    ${wrap_perl_sources} 
    ${wrap_tcl_sources} 
    ${wrap_python_sources} 
    ${wrap_java_sources} 
    GENERATED )
    
  # STEP 2
  # Configure the master index file and SWIG include file, and provide an install
  # version and install rule for the former.
  
  SET(library_master_index_file "${WRAPPER_MASTER_INDEX_OUTPUT_DIR}/${LIBRARY_NAME}.mdx")
  SET(gccxml_inc_file "${WRAPPER_LIBRARY_OUTPUT_DIR}/gcc_xml.inc")

  SET(CONFIG_INDEX_FILE_CONTENT ${index_file_content})
  CONFIGURE_FILE( "${WRAP_ITK_CONFIG_DIR}/Master.mdx.in" "${library_master_index_file}"
     @ONLY IMMEDIATE )
    
  SET(CONFIG_INDEX_FILE_CONTENT ${install_index_file_content})
  CONFIGURE_FILE( "${WRAP_ITK_CONFIG_DIR}/Master.mdx.in"
    "${PROJECT_BINARY_DIR}/MasterIndices/InstallOnly/${LIBRARY_NAME}.mdx" 
    @ONLY IMMEDIATE )
  INSTALL_FILES("${WRAP_ITK_INSTALL_LOCATION}/ClassIndex" 
    FILES "${PROJECT_BINARY_DIR}/MasterIndices/InstallOnly/${LIBRARY_NAME}.mdx")

  SET(CONFIG_GCCXML_INC_CONTENTS)
  FOREACH(dir ${WRAP_ITK_GCCXML_INCLUDE_DIRS})
    SET(CONFIG_GCCXML_INC_CONTENTS "${CONFIG_GCCXML_INC_CONTENTS}-I${dir}\n")
  ENDFOREACH(dir)
  CONFIGURE_FILE("${WRAP_ITK_CONFIG_DIR}/gcc_xml.inc.in" "${gccxml_inc_file}"
    @ONLY IMMEDIATE)

  # STEP 3
  # Create a list of needed master index (mdx) files from the WRAPPER_LIBRARY_DEPENDS
  # information. Check in both WRAPPER_MASTER_INDEX_OUTPUT_DIR (where the current
  # project is putting new master index files) and WRAP_ITK_MASTER_INDEX_DIRECTORY
  # which, if it exists, is where a previously-built WrapITK has stored its master
  # indices. Also add the VXLNumerics master index to the list, as well as the current
  # master index.
  SET(master_index_files "${library_master_index_file}")
  SET(depends_libs VXLNumerics ${WRAPPER_LIBRARY_DEPENDS})
  FOREACH(dep ${depends_libs})
    SET(no_dep_found 1)
    SET(local_mdx "${WRAPPER_MASTER_INDEX_OUTPUT_DIR}/${dep}.mdx")
    IF(EXISTS "${local_mdx}")
      SET(master_index_files ${master_index_files} "${local_mdx}")
      SET(no_dep_found 0)
    ENDIF(EXISTS "${local_mdx}")
    
    IF(no_dep_found AND WRAP_ITK_MASTER_INDEX_DIRECTORY)
      SET(wrapitk_mdx "${WRAP_ITK_MASTER_INDEX_DIRECTORY}/${dep}.mdx")
      IF(EXISTS "$wrapitk_mdx")
        SET(master_index_files ${master_index_files} "${wrapitk_mdx}")
        SET(no_dep_found 0)
      ENDIF(EXISTS "${wrapitk_mdx}")
    ENDIF(no_dep_found AND WRAP_ITK_MASTER_INDEX_DIRECTORY)

    IF(no_dep_found)
      MESSAGE(FATAL_ERROR "Could not find master index file ${dep}.mdx")
    ENDIF(no_dep_found)
  ENDFOREACH(dep)
  
  
  # STEP 4
  # Generate the XML, index, and CXX files from the Cable input files, and add
  # the wrapper library. Then call a macro from CreateLanguageSupport.cmake
  # to create needed support files for the given language.
  IF(WRAP_ITK_PERL)
    SET(library_type "SHARED")
    SET(custom_library_prefix "")
    CREATE_WRAPPER_FILES_AND_LIBRARY("Perl" "pl" "${wrap_perl_sources}"
      "${master_index_files}" "${library_idx_files}" "${gccxml_inc_file}" 
      ${library_type} ${custom_library_prefix})

    CREATE_PERL_LANGUAGE_SUPPORT()
  ENDIF(WRAP_ITK_PERL)
  
  IF(WRAP_ITK_TCL)
    SET(library_type "SHARED")
    SET(custom_library_prefix "")
    CREATE_WRAPPER_FILES_AND_LIBRARY("Tcl" "tcl" "${wrap_tcl_sources}"
      "${master_index_files}" "${library_idx_files}" "${gccxml_inc_file}" 
      ${library_type} ${custom_library_prefix})

    CREATE_TCL_LANGUAGE_SUPPORT()
  ENDIF(WRAP_ITK_TCL)

  IF(WRAP_ITK_PYTHON)
    SET(library_type "MODULE")
    SET(custom_library_prefix "_")
    CREATE_WRAPPER_FILES_AND_LIBRARY("Python" "py" "${wrap_python_sources}"
      "${master_index_files}" "${library_idx_files}" "${gccxml_inc_file}" 
      ${library_type} ${custom_library_prefix})

    CREATE_PYTHON_LANGUAGE_SUPPORT()
  ENDIF(WRAP_ITK_PYTHON)

  IF(WRAP_ITK_JAVA)
    SET(library_type "MODULE")
    SET(custom_library_prefix "")
    CREATE_WRAPPER_FILES_AND_LIBRARY("Java" "java" "${wrap_java_sources}"
      "${master_index_files}" "${library_idx_files}" "${gccxml_inc_file}" 
      ${library_type} ${custom_library_prefix})

    CREATE_JAVA_LANGUAGE_SUPPORT()
  ENDIF(WRAP_ITK_JAVA)
ENDMACRO(WRAPPER_LIBRARY_CREATE_LIBRARY)


MACRO(CREATE_WRAPPER_FILES_AND_LIBRARY language extension library_sources
      master_index_files library_idx_files gccxml_inc_file 
      library_type custom_library_prefix)
      
  SET(library_name "${custom_library_prefix}${WRAPPER_LIBRARY_NAME}${language}")
  SET(cable_files "${WRAPPER_LIBRARY_OUTPUT_DIR}/${WRAPPER_LIBRARY_NAME}{Language}.cxx"
    ${WRAPPER_LIBRARY_CABLESWIG_INPUTS})
  CREATE_WRAPPER_FILES("${library_name}" "${language}" "${extension}" "${master_index_files}" "${library_idx_files}" 
    "${cable_files}" "${gccxml_inc_file}")
  CREATE_WRAPPER_LIBRARY("${library_name}" "${library_sources}" "${language}" ${library_type} ${custom_library_prefix})
ENDMACRO(CREATE_WRAPPER_FILES_AND_LIBRARY)


MACRO(CREATE_WRAPPER_FILES language extension mdx_files library_idx_files cable_input_files gccxml_inc_file)
  FOREACH(cable_file ${cable_input_files})
    GET_FILENAME_COMPONENT(base_name "${cable_file}" NAME_WE)
    SET(xml_file "${WRAPPER_LIBRARY_OUTPUT_DIR}/${base_name}.xml")
    SET(idx_file "${WRAPPER_LIBRARY_OUTPUT_DIR}/${base_name}.idx")
    SET(cxx_file "${WRAPPER_LIBRARY_OUTPUT_DIR}/${base_name}${language}.cxx"
    
    # Create the XML file
    GCCXML_CREATE_XML_FILE("${library_name}" "${cable_file}" "${xml_file}" "${gccxml_inc_file}")
    
    # Create the idx file and provide an install rule
    CINDEX_CREATE_IDX_FILE("${library_name}" "${xml_file}" "${idx_file}")
    INSTALL_FILES("${WRAP_ITK_INSTALL_LOCATION}/ClassIndex" FILES "${idx_file}")
    
    # Create the wrapper CXX file with cswig and an install rule for the generated language file
    CSWIG_CREATE_CXX_FILE("${library_name}" "${language}" "${idx_file}" "${xml_file}" "${cxx_file}"
      "${master_index_files}" "${library_idx_files}")
    STRING(REGEX REPLACE "wrap_" "" simple_base "${base_name}")
    SET(swig_language_file "${LIBRARY_OUTPUT_PATH}/${CMAKE_CFG_INTDIR}/${simple_base_name}.${extension}")
    INSTALL_FILES("${WRAP_ITK_INSTALL_LOCATION}/${language}-SWIG" FILES "${swig_language_file}")    
  ENDFOREACH(file)
  
  # Create any extra CXX files from raw swig .i input files specified, and provide
  # install rules for the generated language output. Guess that the generated language
  # output will have the same name as the .i input file.
  FOREACH(swig_input ${WRAPPER_LIBRARY_SWIG_INPUTS})
    GET_FILENAME_COMPONENT(base_name ${swig_input} NAME_WE)
    SET(cxx_output "${WRAPPER_LIBRARY_OUTPUT_DIR}/${base_name}${language}.cxx)
    CREATE_EXTRA_SWIG_FILE("${library_name}" "${language}" "${swig_input}" "${cxx_output}")
    SET(swig_language_file "${LIBRARY_OUTPUT_PATH}/${CMAKE_CFG_INTDIR}/${base_name}.${extension}")
    INSTALL_FILES("${WRAP_ITK_INSTALL_LOCATION}/${language}-SWIG" FILES "${swig_language_file}")
  ENDFOREACH(swig_input)
  
ENDMACRO(CREATE_WRAPPER_FILES)


MACRO(GCCXML_CREATE_XML_FILE library_name input_cxx output_xml gccxml_inc_file)
# First, deal with dependencies. Specifically, this XML file will need to be
# re-generated when files that it included (and so on recursively) change.
# The cswig program, run later, will write out a 'depends' file based on this
# XML file that specifies what these dependencies are. Thus, when 'cmake' is
# run a second time, if any of those files has changed then the XML file will
# be re-generated. There is an additional wrinkle, however: if the dependencies
# have changed enough that one of the files doesn't exist any more, specifying
# a dependence on that now-defunct file will cause a make error (because make 
# won't know how to generate that file). So, if certain dependencies are gone,
# then the XML file will need to be regenerated too.

   SET(CABLE_SWIG_DEPEND)
   SET(regenerate_xml)

  IF(${CMAKE_MAKE_PROGRAM} MATCHES "make")
    # If the make program is not an IDE then include the depend file in a way 
    # that will make cmake re-run if it changes
    IF(EXISTS "${output_xml}.depend")
    ELSE(EXISTS "${output_xml}.depend")
      CONFIGURE_FILE(
        "${WRAP_ITK_CONFIG_DIR}/empty.depend.in"
       "${output_xml}.depend" COPYONLY IMMEDIATE)
    ENDIF(EXISTS "${output_xml}.depend")
    INCLUDE("${output_xml}.depend")
  ELSE(${CMAKE_MAKE_PROGRAM} MATCHES "make")
    # for IDE generators like MS dev only include the depend files
    # if they exist. This is to prevent excessive reloading of
    # workspaces after each build. This also means
    # that the depends will not be correct until cmake
    # is run once after the build has completed once, and the depend files have
    # been created by cswig.
    INCLUDE("${output_xml}.depend" OPTIONAL)
    ENDIF(${CMAKE_MAKE_PROGRAM} MATCHES "make")

  IF(CABLE_SWIG_DEPEND)
    # There are dependencies.  Make sure all the files are present.
    # If not, regenerate the XML file.
    FOREACH(f ${CABLE_SWIG_DEPEND})
      IF(EXISTS ${f})
      ELSE(EXISTS ${f})
        SET(regenerate_xml 1)
      ENDIF(EXISTS ${f})
    ENDFOREACH(f)
  ELSE(CABLE_SWIG_DEPEND)
    # No dependencies found. This means that either the XML hasn't been generated
    # yet, or the dependency file itself has disappeared. In case of the latter,
    # (simultaneous with a change in the dependent files themselves, we need to
    # re-generate the XML.
    SET(regenerate_xml 1)
  ENDIF(CABLE_SWIG_DEPEND)
   
  IF(regenerate_xml)
    # Force the XML file to be (re)made by making it depend on its dependency
    # file, which we then create again so that it is newer than the current XML
    # file (if the latter even exists). This forces the XML-creation rule to run.
    SET(CABLE_SWIG_DEPEND "${output_xml}.depend")
    CONFIGURE_FILE("${WRAP_ITK_CONFIG_DIR}/empty.depend.in"
      "${output_xml}.depend" COPYONLY IMMEDIATE)
  ENDIF(regenerate_xml)


  # Finally, the dependencies are taken care of. Add the XML-generation rule!
  ADD_CUSTOM_COMMAND(
    SOURCE ${input_cxx}
    COMMAND ${GCCXML}
    ARGS -fxml-start=_cable_
         -fxml=${output_xml}
         --gccxml-gcc-options ${gccxml_inc_file}
         -DCSWIG 
         -DCABLE_CONFIGURATION 
         ${input_cxx}
    TARGET ${library_name}
    OUTPUTS ${output_xml}
    DEPENDS ${GCCXML} ${CABLE_SWIG_DEPEND})
ENDMACRO(GCCXML_CREATE_XML_FILE)


MACRO(CINDEX_CREATE_IDX_FILE library_name input_xml output_idx)
   ADD_CUSTOM_COMMAND(
     SOURCE ${input_xml}
     COMMAND ${CABLE_INDEX}
     ARGS ${input_xml} ${output_idx}
     TARGET ${library_name}
     OUTPUTS ${output_idx}
     DEPENDS ${input_xml} ${CABLE_INDEX})
ENDMACRO(CINDEX_CREATE_IDX_FILE)


# Set the language-specific cswig args to be used by CSWIG_CREATE_CXX_FILE
SET(CSWIG_ARGS_Tcl
  "-I${CSWIG_DEFAULT_LIB}/tcl"
  -tcl
  -pkgversion 1.0)
SET(CSWIG_ARGS_Perl
  "-I${CSWIG_DEFAULT_LIB}/perl5"
  -perl5)
SET(CSWIG_ARGS_Python
  "-I${CSWIG_DEFAULT_LIB}/python"
  -python)
SET(CSWIG_ARGS_Java
  "-I${CSWIG_DEFAULT_LIB}/java"
  -java
  -package InsightToolkit)
SET(CSWIG_NO_EXCEPTION_REGEX_Python "ContinuousIndex\\.xml$")

MACRO(CSWIG_CREATE_CXX_FILE library_name language input_idx input_xml output_cxx master_index_files library_idx_files)
   SET(cindex)
   FOREACH(mdx ${master_index_files})
     SET(cindex ${cindex} -Cindex "${mdx}")
   ENDFOREACH(mdx)
   
   SET(swig_inc_files)
   FOREACH(file ${WRAP_ITK_SWG_FILES})
       SET(swig_inc_files "-l${file}" ${swig_inc_files})
   ENDFOREACH(file)
  
  # Some files shouldn't have swig-exception handling turned on. Currently they're
  # identified by regular expressions. If we find one, we set a CSWIG flag
  # to define the NO_EXCEPTIONS symbol, which we use in itk.swg for conditional
  # compilation of the exception handling.
  # TODO: Is any of this really necessary?
  SET(no_exception_regex "${language}\\.xml$")
  SET(extra_args)
  SET(lang_no_exception_regex ${CSWIG_NO_EXCEPTION_REGEX_${language}})
  IF(lang_no_exception_regex)
      SET(no_exception_regex "(${no_exception_regex})|(${lang_no_exception_regex})")
  ENDIF(lang_no_exception_regex)
  IF("${input_xml}" MATCHES "${no_exception_regex}")
     SET(extra_args "-DNO_EXCEPTIONS")
  IF("${input_xml}" MATCHES "${no_exception_regex}")

   ADD_CUSTOM_COMMAND(
     SOURCE ${input_idx}
     COMMAND ${CSWIG}
     ARGS ${swig_inc_files}
          -I${CSWIG_DEFAULT_LIB}
          ${CSWIG_IGNORE_WARNINGS}
          -noruntime
          ${cindex}
          -depend ${input_xml}.depend
          -outdir ${LIBRARY_OUTPUT_PATH}/${CMAKE_CFG_INTDIR}
          -o ${output_cxx}
          -c++
          ${CSWIG_ARGS_${language}}
          ${extra_args}
          ${input_xml}
     TARGET ${library_name}
    OUTPUTS ${output_cxx}
     DEPENDS ${library_idx_files} ${WRAP_ITK_SWG_FILES} ${input_xml} ${CSWIG})
ENDMACRO(CSWIG_CREATE_CXX_FILE)


MACRO(CREATE_EXTRA_SWIG_FILES library_name language swig_input cxx_output)
  ADD_CUSTOM_COMMAND(
    COMMENT "run native swig on ${swig_input}"
    SOURCE ${swig_input}
    COMMAND ${CSWIG}
    ARGS  -nocable 
          -noruntime 
          ${CSWIG_IGNORE_WARNINGS}
          -outdir ${LIBRARY_OUTPUT_PATH}/${CMAKE_CFG_INTDIR}
          -o ${cxx_output}
          -c++
          ${CSWIG_ARGS_${language}}
          ${swig_input}
    TARGET ${library_name}
    OUTPUTS ${cxx_output}
    DEPENDS ${CSWIG})
ENDMACRO(CREATE_EXTRA_SWIG_FILES)


# Set the language-specific link libraries to be used by CREATE_WRAPPER_LIBRARY
# TODO: Are there really no Java link libs required? The ITK wrappers specify
# that ${JAVA_LIBRARY} be linked in, but that variable is never defined!
SET(LINK_LIBRARIES_Tcl ${TCL_LIBRARY})
SET(LINK_LIBRARIES_Perl ${PERL_LIBRARY})
SET(LINK_LIBRARIES_Python ${PYTHON_LIBRARY})
SET(LINK_LIBRARIES_Java )
  
MACRO(CREATE_WRAPPER_LIBRARY library_name sources language library_type custom_library_prefix)
  ADD_LIBRARY(${library_name} ${library_type}) 
    ${sources} 
    ${WRAPPER_LIBRARY_CXX_SOURCES})
    
  IF(ITK_WRAP_NEEDS_DEPEND)
    FOREACH(dep ${WRAPPER_LIBRARY_DEPENDS})
      ADD_DEPENDENCIES(${library_name} ${custom_library_prefix}${dep}${language})
    ENDFOREACH(dep)
  ENDIF(ITK_WRAP_NEEDS_DEPEND)
  
  IF(custom_library_prefix)
    SET_TARGET_PROPERTIES( ${library_name} PROPERTIES PREFIX "")
  ENDIF(custom_library_prefix)
  
  SET_TARGET_PROPERTIES(${library_name} PROPERTIES LINK_FLAGS "${CSWIG_EXTRA_LINKFLAGS}")
  TARGET_LINK_LIBRARIES(${library_name} 
    ${WRAPPER_LIBRARY_LINK_LIBRARIES} 
    SwigRuntime${language} 
    ${LINK_LIBRARIES_${language}} )
  INSTALL_TARGETS("${WRAP_ITK_INSTALL_LOCATION}/${language}-SWIG" ${library_name})
ENDMACRO(CREATE_WRAPPER_LIBRARY)