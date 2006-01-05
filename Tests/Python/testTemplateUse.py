import InsightToolkit as itk
import itkPython as itkPy

#########################################################
reader = itk.itkImageFileReaderIUC2_New()
reader.SetFileName("C:/Creatis/homersbrain.bmp")

writer = itkPy.itkImageFileWriter[reader.GetOutput()].New()
writer.SetInput(reader.GetOutput())

writer.SetFileName("./testout1.png")
writer.Update()

#########################################################
reader = itkPy.itkImageFileReader[itkPy.itkImage[itkPy.itkUC,2]].New()
reader.SetFileName("C:/Creatis/homersbrain.bmp")

writer = itkPy.itkImageFileWriter[reader.GetOutput()].New()
writer.SetInput(reader.GetOutput())

writer.SetFileName("./testout2.png")
writer.Update()

