import InsightToolkit.*;

// This example illustrates how C++ classes can be used from Java using SWIG.
// The Java class gets mapped onto the C++ class and behaves as if it is a Java class.

public class simplePipeline {
  public static void main(String argv[])
  {
    itkImageFileReaderIUC2_Pointer reader = itkImageFileReaderIUC2.itkImageFileReaderIUC2_New();
    reader.SetFileName(argv[0]);

    itkImageFileWriterIUC2_Pointer writer = itkImageFileWriterIUC2.itkImageFileWriterIUC2_New();
    writer.SetInput(reader.GetOutput());
    writer.SetFileName(argv[1]);
    writer.Update();
  }
}
