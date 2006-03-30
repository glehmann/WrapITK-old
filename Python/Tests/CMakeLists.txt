SET(PYTHON "${PYTHON_EXECUTABLE}")

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

  ADD_TEST(PythonBinaryDilateImageFilter
    ${PYTHON}
    ${CMAKE_CURRENT_SOURCE_DIR}/BinaryDilateImageFilter.py
    ${WrapITK_SOURCE_DIR}/images/2th_cthead1.png
    PythonBinaryDilateImageFilter.png
  )

  ADD_TEST(PythonBinaryErodeImageFilter
    ${PYTHON}
    ${CMAKE_CURRENT_SOURCE_DIR}/BinaryErodeImageFilter.py
    ${WrapITK_SOURCE_DIR}/images/2th_cthead1.png
    PythonBinaryErodeImageFilter.png
  )

  ADD_TEST(PythonBinaryThresholdImageFilter
    ${PYTHON}
    ${CMAKE_CURRENT_SOURCE_DIR}/BinaryThresholdImageFilter.py
    ${WrapITK_SOURCE_DIR}/images/cthead1.png
    PythonBinaryThresholdImageFilter.png
    50 150
    0 65535
  )

  ADD_TEST(PythonCastImageFilter
    ${PYTHON}
    ${CMAKE_CURRENT_SOURCE_DIR}/CastImageFilter.py
    ${WrapITK_SOURCE_DIR}/images/cthead1.png
    PythonCastImageFilter.png
  )

  ADD_TEST(PythonGrayscaleDilateImageFilter
    ${PYTHON}
    ${CMAKE_CURRENT_SOURCE_DIR}/GrayscaleDilateImageFilter.py
    ${WrapITK_SOURCE_DIR}/images/cthead1.png
    PythonGrayscaleDilateImageFilter.png
  )

  ADD_TEST(PythonGrayscaleErodeImageFilter
    ${PYTHON}
    ${CMAKE_CURRENT_SOURCE_DIR}/GrayscaleErodeImageFilter.py
    ${WrapITK_SOURCE_DIR}/images/cthead1.png
    PythonGrayscaleErodeImageFilter.png
  )

  ADD_TEST(PythonMeanImageFilter
    ${PYTHON}
    ${CMAKE_CURRENT_SOURCE_DIR}/MeanImageFilter.py
    ${WrapITK_SOURCE_DIR}/images/cthead1.png
    PythonMeanImageFilter.png
    3
  )

  ADD_TEST(PythonMedianImageFilter
    ${PYTHON}
    ${CMAKE_CURRENT_SOURCE_DIR}/MedianImageFilter.py
    ${WrapITK_SOURCE_DIR}/images/cthead1.png
    PythonMedianImageFilter.png
    3
  )

  ADD_TEST(PythonSigmoidImageFilter
    ${PYTHON}
    ${CMAKE_CURRENT_SOURCE_DIR}/SigmoidImageFilter.py
    ${WrapITK_SOURCE_DIR}/images/cthead1.png
    PythonSigmoidImageFilter.png
    10 240 10 170
  )

  ADD_TEST(PythonThresholdImageFilter
    ${PYTHON}
    ${CMAKE_CURRENT_SOURCE_DIR}/ThresholdImageFilter.py
    ${WrapITK_SOURCE_DIR}/images/cthead1.png
    PythonThresholdImageFilter.png
    150 150
  )

ENDIF(WRAP_unsigned_short AND WRAP_2)


IF(WRAP_float AND WRAP_2)
  ADD_TEST(PythonCurvatureAnisotropicDiffusionImageFilter
    ${PYTHON}
    ${CMAKE_CURRENT_SOURCE_DIR}/CurvatureAnisotropicDiffusionImageFilter.py
    ${WrapITK_SOURCE_DIR}/images/cthead1.png
    PythonCurvatureAnisotropicDiffusionImageFilter.png
    5 0.125 3
  )

  ADD_TEST(PythonCurvatureFlowImageFilter
    ${PYTHON}
    ${CMAKE_CURRENT_SOURCE_DIR}/CurvatureFlowImageFilter.py
    ${WrapITK_SOURCE_DIR}/images/cthead1.png
    PythonCurvatureFlowImageFilter.png
    5 0.125 1.0
  )

  ADD_TEST(PythonSmoothingRecursiveGaussianImageFilter
    ${PYTHON}
    ${CMAKE_CURRENT_SOURCE_DIR}/SmoothingRecursiveGaussianImageFilter.py
    ${WrapITK_SOURCE_DIR}/images/cthead1.png
    PythonSmoothingRecursiveGaussianImageFilter.png
    3
  )

  ADD_TEST(PythonLaplacianImageFilter
    ${PYTHON}
    ${CMAKE_CURRENT_SOURCE_DIR}/LaplacianImageFilter.py
    ${WrapITK_SOURCE_DIR}/images/cthead1.png
    PythonLaplacianImageFilter.png
  )

ENDIF(WRAP_float AND WRAP_2)



UNIQUE(types "${WRAP_ITK_SCALAR};UC")
FOREACH(d ${WRAP_ITK_DIMS})
  FOREACH(t ${types})
    ADD_TEST(PythonSimplePipeline${t}${d} ${PYTHON}
      ${CMAKE_CURRENT_SOURCE_DIR}/simple_pipeline.py
      ${t}
      ${d}
      ${WrapITK_SOURCE_DIR}/images/cthead1.png
      simple_pipeline${t}${d}.img
    )
  ENDFOREACH(t)
ENDFOREACH(d)
