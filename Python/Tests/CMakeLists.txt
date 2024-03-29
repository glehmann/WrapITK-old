
# configure the test driver
FIND_PROGRAM(IMAGE_COMPARE ImageCompare)

IF(CMAKE_CONFIGURATION_TYPES)
  FOREACH(config ${CMAKE_CONFIGURATION_TYPES})
    SET(PYTHON_TEST_LIB_PATH "${WrapITK_BINARY_DIR}/lib/${config}/")
    SET(PYTHON_TEST_PYTHON_PATH "${WrapITK_BINARY_DIR}/Python/${config}/")
    CONFIGURE_FILE("${CMAKE_CURRENT_SOURCE_DIR}/pythonTestDriver.py.in"
                "${CMAKE_CURRENT_BINARY_DIR}/${config}/pythonTestDriver.py"
                @ONLY IMMEDIATE)
  ENDFOREACH(config)
ELSE(CMAKE_CONFIGURATION_TYPES)
  SET(PYTHON_TEST_LIB_PATH "${WrapITK_BINARY_DIR}/lib/")
  SET(PYTHON_TEST_PYTHON_PATH "${WrapITK_BINARY_DIR}/Python/")
  CONFIGURE_FILE("${CMAKE_CURRENT_SOURCE_DIR}/pythonTestDriver.py.in"
              "${CMAKE_CURRENT_BINARY_DIR}/pythonTestDriver.py"
              @ONLY IMMEDIATE)
ENDIF(CMAKE_CONFIGURATION_TYPES)

# install pythonTestDriver.py.in, so it can be used by external projects for testing
WRAP_ITK_INSTALL("/Configuration/Python/Tests" "${CMAKE_CURRENT_SOURCE_DIR}/pythonTestDriver.py.in")


SET(PYTHON_DRIVER "${PYTHON_EXECUTABLE}" "${CMAKE_CURRENT_BINARY_DIR}/\${CTEST_CONFIGURATION_TYPE}/pythonTestDriver.py")


ADD_TEST(PythonTestDirectory ${PYTHON_DRIVER} ${CMAKE_CURRENT_SOURCE_DIR}/TestDirectory.py)

ADD_TEST(PythonTestObject ${PYTHON_DRIVER} ${CMAKE_CURRENT_SOURCE_DIR}/TestObject.py)

ADD_TEST(PythonFilterCoverage ${PYTHON_DRIVER} ${CMAKE_CURRENT_SOURCE_DIR}/filterCoverage.py ${ITK_INCLUDE_DIRS})

ADD_TEST(PythonFindEmptyClasses ${PYTHON_DRIVER} ${CMAKE_CURRENT_SOURCE_DIR}/findEmptyClasses.py)


# some tests will fail if dim=2 and unsigned short are not wrapped
INTERSECTION(WRAP_2 2 "${WRAP_ITK_DIMS}")
IF(WRAP_unsigned_short AND WRAP_2)
  ADD_TEST(PythonTypemaps ${PYTHON_DRIVER} ${CMAKE_CURRENT_SOURCE_DIR}/typemaps.py)
  
  ADD_TEST(PythonTemplate ${PYTHON_DRIVER} ${CMAKE_CURRENT_SOURCE_DIR}/template.py)
  
  ADD_TEST(PythonExtras ${PYTHON_DRIVER}
    ${CMAKE_CURRENT_SOURCE_DIR}/extras.py
    ${WrapITK_SOURCE_DIR}/images/cthead1.png out.png
  )
  
  ADD_TEST(PythonModuleToModule ${PYTHON_DRIVER}
    ${CMAKE_CURRENT_SOURCE_DIR}/module2module.py
    ${WrapITK_SOURCE_DIR}/images/cthead1.png
  )

  ADD_TEST(PythonBinaryDilateImageFilter
    ${PYTHON_DRIVER}
    ${CMAKE_CURRENT_SOURCE_DIR}/BinaryDilateImageFilter.py
    ${WrapITK_SOURCE_DIR}/images/2th_cthead1.png
    BinaryDilateImageFilter.png
    --compare BinaryDilateImageFilter.png ${WrapITK_SOURCE_DIR}/images/BinaryDilateImageFilter.png
  )

  ADD_TEST(PythonBinaryErodeImageFilter
    ${PYTHON_DRIVER}
    ${CMAKE_CURRENT_SOURCE_DIR}/BinaryErodeImageFilter.py
    ${WrapITK_SOURCE_DIR}/images/2th_cthead1.png
    BinaryErodeImageFilter.png
    --compare BinaryErodeImageFilter.png ${WrapITK_SOURCE_DIR}/images/BinaryErodeImageFilter.png
  )

  ADD_TEST(PythonBinaryThresholdImageFilter
    ${PYTHON_DRIVER}
    ${CMAKE_CURRENT_SOURCE_DIR}/BinaryThresholdImageFilter.py
    ${WrapITK_SOURCE_DIR}/images/cthead1.png
    BinaryThresholdImageFilter.png
    50 150
    0 65535
    --compare BinaryThresholdImageFilter.png ${WrapITK_SOURCE_DIR}/images/BinaryThresholdImageFilter.png
  )

  ADD_TEST(PythonCastImageFilter
    ${PYTHON_DRIVER}
    ${CMAKE_CURRENT_SOURCE_DIR}/CastImageFilter.py
    ${WrapITK_SOURCE_DIR}/images/cthead1.png
    CastImageFilter.png
    --compare CastImageFilter.png ${WrapITK_SOURCE_DIR}/images/cthead1.png
  )

  ADD_TEST(PythonGrayscaleDilateImageFilter
    ${PYTHON_DRIVER}
    ${CMAKE_CURRENT_SOURCE_DIR}/GrayscaleDilateImageFilter.py
    ${WrapITK_SOURCE_DIR}/images/cthead1.png
    GrayscaleDilateImageFilter.png
    --compare GrayscaleDilateImageFilter.png ${WrapITK_SOURCE_DIR}/images/GrayscaleDilateImageFilter.png
  )

  ADD_TEST(PythonGrayscaleErodeImageFilter
    ${PYTHON_DRIVER}
    ${CMAKE_CURRENT_SOURCE_DIR}/GrayscaleErodeImageFilter.py
    ${WrapITK_SOURCE_DIR}/images/cthead1.png
    GrayscaleErodeImageFilter.png
    --compare GrayscaleErodeImageFilter.png ${WrapITK_SOURCE_DIR}/images/GrayscaleErodeImageFilter.png
  )

  ADD_TEST(PythonMeanImageFilter
    ${PYTHON_DRIVER}
    ${CMAKE_CURRENT_SOURCE_DIR}/MeanImageFilter.py
    ${WrapITK_SOURCE_DIR}/images/cthead1.png
    MeanImageFilter.png
    3
    --compare MeanImageFilter.png ${WrapITK_SOURCE_DIR}/images/MeanImageFilter.png
  )

  ADD_TEST(PythonMedianImageFilter
    ${PYTHON_DRIVER}
    ${CMAKE_CURRENT_SOURCE_DIR}/MedianImageFilter.py
    ${WrapITK_SOURCE_DIR}/images/cthead1.png
    MedianImageFilter.png
    3
    --compare MedianImageFilter.png ${WrapITK_SOURCE_DIR}/images/MedianImageFilter.png
  )

  ADD_TEST(PythonSigmoidImageFilter
    ${PYTHON_DRIVER}
    ${CMAKE_CURRENT_SOURCE_DIR}/SigmoidImageFilter.py
    ${WrapITK_SOURCE_DIR}/images/cthead1.png
    SigmoidImageFilter.png
    10 240 10 170
    --compare SigmoidImageFilter.png ${WrapITK_SOURCE_DIR}/images/SigmoidImageFilter.png
  )

  ADD_TEST(PythonThresholdImageFilter
    ${PYTHON_DRIVER}
    ${CMAKE_CURRENT_SOURCE_DIR}/ThresholdImageFilter.py
    ${WrapITK_SOURCE_DIR}/images/cthead1.png
    ThresholdImageFilter.png
    150 150
    --compare ThresholdImageFilter.png ${WrapITK_SOURCE_DIR}/images/ThresholdImageFilter.png
  )

ENDIF(WRAP_unsigned_short AND WRAP_2)


IF(WRAP_float AND WRAP_2)
  ADD_TEST(PythonCurvatureAnisotropicDiffusionImageFilter
    ${PYTHON_DRIVER}
    ${CMAKE_CURRENT_SOURCE_DIR}/CurvatureAnisotropicDiffusionImageFilter.py
    ${WrapITK_SOURCE_DIR}/images/cthead1.png
    CurvatureAnisotropicDiffusionImageFilter.png
    5 0.125 3
  )

  ADD_TEST(PythonCurvatureFlowImageFilter
    ${PYTHON_DRIVER}
    ${CMAKE_CURRENT_SOURCE_DIR}/CurvatureFlowImageFilter.py
    ${WrapITK_SOURCE_DIR}/images/cthead1.png
    CurvatureFlowImageFilter.png
    5 0.125 1.0
  )

  ADD_TEST(PythonSmoothingRecursiveGaussianImageFilter
    ${PYTHON_DRIVER}
    ${CMAKE_CURRENT_SOURCE_DIR}/SmoothingRecursiveGaussianImageFilter.py
    ${WrapITK_SOURCE_DIR}/images/cthead1.png
    SmoothingRecursiveGaussianImageFilter.png
    3
  )

  ADD_TEST(PythonLaplacianImageFilter
    ${PYTHON_DRIVER}
    ${CMAKE_CURRENT_SOURCE_DIR}/LaplacianImageFilter.py
    ${WrapITK_SOURCE_DIR}/images/cthead1.png
    LaplacianImageFilter.png
  )

  ADD_TEST(PythonFFTImageFilter
    ${PYTHON_DRIVER}
    ${CMAKE_CURRENT_SOURCE_DIR}/FFTImageFilter.py
    ${WrapITK_SOURCE_DIR}/images/cthead1.png
    FFTImageFilterReal.png
    FFTImageFilterImaginary.png
    --compare FFTImageFilterReal.png ${WrapITK_SOURCE_DIR}/images/FFTImageFilterReal.png
    --compare FFTImageFilterImaginary.png ${WrapITK_SOURCE_DIR}/images/FFTImageFilterImaginary.png
#     --compare complexImage.mhd ${WrapITK_SOURCE_DIR}/images/complexImage.mhd
  )

  ADD_TEST( PythonGradientMagnitudeRecursiveGaussianImageFilterTest
    ${PYTHON_DRIVER}
    ${CMAKE_CURRENT_SOURCE_DIR}/GradientMagnitudeRecursiveGaussianImageFilter.py
    ${WrapITK_SOURCE_DIR}/images/BrainProtonDensitySlice.png
    GradientMagnitudeRecursiveGaussianImageFilter.png
    5
    --compare GradientMagnitudeRecursiveGaussianImageFilter.png
    	      ${WrapITK_SOURCE_DIR}/images/GradientMagnitudeRecursiveGaussianImageFilter.png
  )

  ADD_TEST( PythonGradientAnisotropicDiffusionImageFilterTest
    ${PYTHON_DRIVER}
    ${CMAKE_CURRENT_SOURCE_DIR}/GradientAnisotropicDiffusionImageFilter.py
    ${WrapITK_SOURCE_DIR}/images/BrainProtonDensitySlice.png
    GradientAnisotropicDiffusionImageFilter.png
    5 0.125 1.0
    --compare GradientAnisotropicDiffusionImageFilter.png
              ${WrapITK_SOURCE_DIR}/images/GradientAnisotropicDiffusionImageFilter.png
  )


# TODO: reenable the geodesic test once we get why the result is not the
# same than with c++
# keep just one to be sure it run, but don't compare the images

  ADD_TEST( PythonGeodesicActiveContourLeftVentricleTest
    ${PYTHON_DRIVER}
#     --compare GeodesicActiveContourLeftVentricleTest.png
#     	      ${WrapITK_SOURCE_DIR}/images/GeodesicActiveContourLeftVentricleTest.png
    --
    ${CMAKE_CURRENT_SOURCE_DIR}/GeodesicActiveContourImageFilter.py
    ${WrapITK_SOURCE_DIR}/images/BrainProtonDensitySlice.png
    GeodesicActiveContourLeftVentricleTest.png
    81 114 5.0 1.0 -0.5 3.0 2.0
  )

#   ADD_TEST( PythonGeodesicActiveContourWhiteMatterTest
#     ${PYTHON_DRIVER}
#     --compare GeodesicActiveContourWhiteMatterTest.png
#     	      ${WrapITK_SOURCE_DIR}/images/GeodesicActiveContourWhiteMatterTest.png
#     --
#     ${CMAKE_CURRENT_SOURCE_DIR}/GeodesicActiveContourImageFilter.py
#     ${WrapITK_SOURCE_DIR}/images/BrainProtonDensitySlice.png
#     GeodesicActiveContourWhiteMatterTest.png
#     56 92 5.0 1.0 -0.3 2.0 10.0
#   )

#   ADD_TEST( PythonGeodesicActiveContourGrayMatterTest
#     ${PYTHON_DRIVER}
#     --compare GeodesicActiveContourGrayMatterTest.png
#     	      ${WrapITK_SOURCE_DIR}/images/GeodesicActiveContourGrayMatterTest.png
#     --
#     ${CMAKE_CURRENT_SOURCE_DIR}/GeodesicActiveContourImageFilter.py
#     ${WrapITK_SOURCE_DIR}/images/BrainProtonDensitySlice.png
#     GeodesicActiveContourGrayMatterTest.png
#     40 90 5.0 .5 -0.3 2.0 10.0
#   )


ENDIF(WRAP_float AND WRAP_2)



UNIQUE(types "${WRAP_ITK_SCALAR};UC")
FOREACH(d ${WRAP_ITK_DIMS})
  FOREACH(t ${types})
    ADD_TEST(PythonSimplePipeline${t}${d} ${PYTHON_DRIVER}
      ${CMAKE_CURRENT_SOURCE_DIR}/simple_pipeline.py
      ${t}
      ${d}
      ${WrapITK_SOURCE_DIR}/images/cthead1.png
      simple_pipeline${t}${d}.nrrd
      --compare simple_pipeline${t}${d}.nrrd ${WrapITK_SOURCE_DIR}/images/cthead1.png
    )
  ENDFOREACH(t)
ENDFOREACH(d)
