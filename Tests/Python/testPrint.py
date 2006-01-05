from InsightToolkit import *
from itkPython import *
import sys

reader = itkImageFileReaderIUC2.New()
reader.SetFileName("C:/Creatis/homersbrain.bmp")
reader.Update()

print "Reader : "
itkPrint(reader)
print "Reader Output : "
itkPrint(reader.GetOutput())

