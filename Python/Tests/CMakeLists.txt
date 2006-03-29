# configure the tests
SET(PYTHON_TEST_LIB_PATH "${WrapITK_BINARY_DIR}/bin")
SET(PYTHON_TEST_PYTHON_PATH "${WrapITK_BINARY_DIR}/Python")
FOREACH(t typemaps.py template.py itk-functions.py module2module.py simple_pipeline.py)
  CONFIGURE_FILE("${CMAKE_CURRENT_SOURCE_DIR}/${t}.in"
                "${CMAKE_CURRENT_BINARY_DIR}/${t}"
                @ONLY IMMEDIATE)
ENDFOREACH(t)

# some tests will fail if dim=2 and unsigned short are not wrapped
INTERSECTION(WRAP_2 2 "${WRAP_ITK_DIMS}")
IF(WRAP_unsigned_short AND WRAP_2)
  ADD_TEST(PythonTypemaps ${PYTHON_EXECUTABLE} ${CMAKE_CURRENT_BINARY_DIR}/typemaps.py)
  
  ADD_TEST(PythonTemplate ${PYTHON_EXECUTABLE} ${CMAKE_CURRENT_BINARY_DIR}/template.py)
  
  ADD_TEST(PythonItkFunctions ${PYTHON_EXECUTABLE}
    ${CMAKE_CURRENT_BINARY_DIR}/itk-functions.py
    ${WrapITK_SOURCE_DIR}/images/cthead1.png out.png
  )
  
  ADD_TEST(PythonModuleToModule ${PYTHON_EXECUTABLE}
    ${CMAKE_CURRENT_BINARY_DIR}/module2module.py
    ${WrapITK_SOURCE_DIR}/images/cthead1.png
  )
ENDIF(WRAP_unsigned_short AND WRAP_2)

UNIQUE(types "${WRAP_ITK_SCALAR};UC")
FOREACH(d ${WRAP_ITK_DIMS})
  FOREACH(t ${types})
    ADD_TEST(PythonSimplePipeline${t}${d} ${PYTHON_EXECUTABLE}
      ${CMAKE_CURRENT_BINARY_DIR}/simple_pipeline.py
      ${t}
      ${d}
      ${WrapITK_SOURCE_DIR}/images/cthead1.png
      simple_pipeline${t}${d}.img
    )
  ENDFOREACH(t)
ENDFOREACH(d)
