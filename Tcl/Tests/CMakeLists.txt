SET(ITKWISH "${WrapITK_BINARY_DIR}/Tcl/itkwish")

ADD_TEST(TclListAll sh ${ITKWISH} ${CMAKE_CURRENT_SOURCE_DIR}/ListAll.tcl)

# this test is broken I think because of a bug in itk::ParallelSparseFieldLevelSetImageFilter::PrintSelf()
# TODO: run this test, once the bug is fixed
# ADD_TEST(TclPrintAll sh ${ITKWISH} ${CMAKE_CURRENT_SOURCE_DIR}/PrintAll.tcl)

INTERSECTION(WRAP_2 2 "${WRAP_ITK_DIMS}")
IF(WRAP_unsigned_short AND WRAP_2)
  ADD_TEST(TclBinaryDilateImageFilter
    sh ${ITKWISH}
    ${CMAKE_CURRENT_SOURCE_DIR}/BinaryDilateImageFilter.tcl
    ${WrapITK_SOURCE_DIR}/images/2th_cthead1.png
    TclBinaryDilateImageFilter.png
  )

  ADD_TEST(TclBinaryErodeImageFilter
    sh ${ITKWISH}
    ${CMAKE_CURRENT_SOURCE_DIR}/BinaryErodeImageFilter.tcl
    ${WrapITK_SOURCE_DIR}/images/2th_cthead1.png
    TclBinaryErodeImageFilter.png
  )

  ADD_TEST(TclBinaryThresholdImageFilter
    sh ${ITKWISH}
    ${CMAKE_CURRENT_SOURCE_DIR}/BinaryThresholdImageFilter.tcl
    ${WrapITK_SOURCE_DIR}/images/cthead1.png
    TclBinaryThresholdImageFilter.png
    50 150
    0 65535
  )

  ADD_TEST(TclCastImageFilter
    sh ${ITKWISH}
    ${CMAKE_CURRENT_SOURCE_DIR}/CastImageFilter.tcl
    ${WrapITK_SOURCE_DIR}/images/cthead1.png
    TclCastImageFilter.png
  )

# need to find a dicom image for this test

#   ADD_TEST(TclDicomSliceRead
#     sh ${ITKWISH}
#     ${CMAKE_CURRENT_SOURCE_DIR}/DicomSliceRead.tcl
#     ${WrapITK_SOURCE_DIR}/images/cthead1.png
#     DicomSliceRead.png
#   )

  ADD_TEST(TclMeanImageFilter
    sh ${ITKWISH}
    ${CMAKE_CURRENT_SOURCE_DIR}/MeanImageFilter.tcl
    ${WrapITK_SOURCE_DIR}/images/cthead1.png
    TclMeanImageFilter.png
    3
  )

  ADD_TEST(TclMedianImageFilter
    sh ${ITKWISH}
    ${CMAKE_CURRENT_SOURCE_DIR}/MedianImageFilter.tcl
    ${WrapITK_SOURCE_DIR}/images/cthead1.png
    TclMedianImageFilter.png
    3
  )

  ADD_TEST(TclSigmoidImageFilter
    sh ${ITKWISH}
    ${CMAKE_CURRENT_SOURCE_DIR}/SigmoidImageFilter.tcl
    ${WrapITK_SOURCE_DIR}/images/cthead1.png
    TclSigmoidImageFilter.png
    10 240 10 170
  )

ENDIF(WRAP_unsigned_short AND WRAP_2)



IF(WRAP_float AND WRAP_2)
#   ADD_TEST(TclCannyEdgeDetectionImageFilter
#     sh ${ITKWISH}
#     ${CMAKE_CURRENT_SOURCE_DIR}/CannyEdgeDetectionImageFilter.tcl
#     ${WrapITK_SOURCE_DIR}/images/cthead1.png
#     TclCannyEdgeDetectionImageFilter.png
#   )

  ADD_TEST(TclCurvatureAnisotropicDiffusionImageFilter
    sh ${ITKWISH}
    ${CMAKE_CURRENT_SOURCE_DIR}/CurvatureAnisotropicDiffusionImageFilter.tcl
    ${WrapITK_SOURCE_DIR}/images/cthead1.png
    TclCurvatureAnisotropicDiffusionImageFilter.png
    5 0.125 3
  )

  ADD_TEST(TclCurvatureFlowImageFilter
    sh ${ITKWISH}
    ${CMAKE_CURRENT_SOURCE_DIR}/CurvatureFlowImageFilter.tcl
    ${WrapITK_SOURCE_DIR}/images/cthead1.png
    TclCurvatureFlowImageFilter.png
    5 0.125 1.0
  )

  ADD_TEST(TclGradientAnisotropicDiffusionImageFilter
    sh ${ITKWISH}
    ${CMAKE_CURRENT_SOURCE_DIR}/GradientAnisotropicDiffusionImageFilter.tcl
    ${WrapITK_SOURCE_DIR}/images/cthead1.png
    GradientAnisotropicDiffusionImageFilter.png
    5 0.125 1.0
  )
ENDIF(WRAP_float AND WRAP_2)


UNIQUE(types "${WRAP_ITK_SCALAR};UC")
FOREACH(TCL_TEST_IMAGE_DIMENSION ${WRAP_ITK_DIMS})
  FOREACH(TCL_TEST_PIXEL_TYPE ${types})

    SET(TEST_FILE_NAME simplePipeline${TCL_TEST_PIXEL_TYPE}${TCL_TEST_IMAGE_DIMENSION})

    CONFIGURE_FILE("${CMAKE_CURRENT_SOURCE_DIR}/simplePipeline.tcl.in"
                  "${CMAKE_CURRENT_BINARY_DIR}/${TEST_FILE_NAME}.tcl"
                  @ONLY IMMEDIATE)

    ADD_TEST(TclSimplePipeline${TCL_TEST_PIXEL_TYPE}${TCL_TEST_IMAGE_DIMENSION}
      sh ${ITKWISH}
      ${TEST_FILE_NAME}.tcl
      ${WrapITK_SOURCE_DIR}/images/cthead1.png
      ${TEST_FILE_NAME}.img
    )

  ENDFOREACH(TCL_TEST_PIXEL_TYPE)
ENDFOREACH(TCL_TEST_IMAGE_DIMENSION)
