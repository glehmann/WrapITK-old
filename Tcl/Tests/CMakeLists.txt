SET(ITKWISH "${WrapITK_BINARY_DIR}/Tcl/itkwish")

ADD_TEST(TclListAll sh ${ITKWISH} ${CMAKE_CURRENT_SOURCE_DIR}/ListAll.tcl)

# this test is broken I thinkk because of a bug in itk::ParallelSparseFieldLevelSetImageFilter::PrintSelf()
# TODO: run this test, once the bug is fixed
# ADD_TEST(TclPrintAll sh ${ITKWISH} ${CMAKE_CURRENT_SOURCE_DIR}/PrintAll.tcl)
