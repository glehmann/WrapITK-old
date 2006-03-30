#
#  Example on the use of the SigmoidImageFilter
#

import itk
from sys import argv

dim = 2
IType = itk.Image[itk.US, dim]

reader = itk.ImageFileReader[IType].New( FileName=argv[1] )
filter  = itk.SigmoidImageFilter[IType, IType].New( reader,
                  OutputMinimum=eval( argv[3] ),
                  OutputMaximum=eval( argv[4] ),
                  Alpha=eval( argv[5] ),
                  Beta=eval( argv[6] ),
                  )
writer = itk.ImageFileWriter[IType].New( filter, FileName=argv[2] )

writer.Update()

