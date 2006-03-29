# MAKE_DIRECTORY(Java/Tests)

# compile the test programs
FOREACH(test simplePipeline)
  ADD_CUSTOM_COMMAND(
    OUTPUT ${test}.class
    DEPENDS ${WrapITK_BINARY_DIR}/Java/InsightToolkit.jar ${test}.java
    COMMAND ${JAVA_COMPILE}
    ARGS -classpath "${WrapITK_BINARY_DIR}/Java/InsightToolkit.jar" -d "${CMAKE_CURRENT_BINARY_DIR}" ${CMAKE_CURRENT_SOURCE_DIR}/${test}.java
  )
  ADD_CUSTOM_TARGET(${test} ALL DEPENDS ${test}.class)
ENDFOREACH(test)


# and now add the tests

ADD_TEST(JavaSimplePipelineUC2
  ${JAVA_RUNTIME}
  -classpath .:${WrapITK_BINARY_DIR}/Java/InsightToolkit.jar
  simplePipeline
  ${WrapITK_SOURCE_DIR}/images/cthead1.png
  out.png
)
