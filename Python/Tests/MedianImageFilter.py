#
#  Example on the use of the MedianImageFilter
#

import itk
from sys import argv

dim = 2
IType = itk.Image[itk.US, dim]

reader = itk.ImageFileReader[IType].New( FileName=argv[1] )
filter  = itk.MedianImageFilter[IType, IType].New( reader, Radius=eval( argv[3] ) )
writer = itk.ImageFileWriter[IType].New( filter, FileName=argv[2] )

writer.Update()
