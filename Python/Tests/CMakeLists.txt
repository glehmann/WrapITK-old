SET(PYTHON python)

# some tests will fail if dim=2 and unsigned short are not wrapped
INTERSECTION(WRAP_2 2 "${WRAP_ITK_DIMS}")
IF(WRAP_unsigned_short AND WRAP_2)
  ADD_TEST(PythonTypemaps ${PYTHON} ${CMAKE_CURRENT_SOURCE_DIR}/typemaps.py)
  
  ADD_TEST(PythonTemplate ${PYTHON} ${CMAKE_CURRENT_SOURCE_DIR}/template.py)
  
  ADD_TEST(PythonItkFunctions ${PYTHON}
    ${CMAKE_CURRENT_SOURCE_DIR}/itk-functions.py
    ${WrapITK_SOURCE_DIR}/images/cthead1.png out.png
  )
  
  ADD_TEST(PythonModuleToModule ${PYTHON}
    ${CMAKE_CURRENT_SOURCE_DIR}/module2module.py
    ${WrapITK_SOURCE_DIR}/images/cthead1.png
  )
ENDIF(WRAP_unsigned_short AND WRAP_2)

  
FOREACH(d ${WRAP_ITK_DIMS})
  FOREACH(t ${WRAP_ITK_SCALAR})
    ADD_TEST(PythonSimplePipeline${t}${d} ${PYTHON}
      ${CMAKE_CURRENT_SOURCE_DIR}/simple_pipeline.py
      ${t}
      ${d}
      ${WrapITK_SOURCE_DIR}/images/cthead1.png
      simple_pipeline${t}${d}.img
    )
  ENDFOREACH(t)
ENDFOREACH(d)
