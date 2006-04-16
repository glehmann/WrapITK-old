

import itk
from sys import argv

dim = 2
PType = itk.US
IType = itk.Image[PType, dim]

reader = itk.ImageFileReader[IType].New(FileName=argv[1])
inputImage = reader.GetOutput()
# it is not required to update the filter: itk.size() update it
# to get the information it needs
size = itk.size(inputImage)

scale = itk.ScaleTransform[itk.D, dim].New(Parameters=[eval( argv[3] ), eval( argv[3] )])
# sequence typemap is not supported yet for itk::Point
centralPoint = itk.Point[itk.D, dim]()
centralPoint[0] = size[0] / 2.
centralPoint[1] = size[1] / 2.
scale.SetCenter( centralPoint )

interpolator = itkLinearInterpolateImageFunction[PType, dime, itk.D].New()

resampler = itkResampleImageFilter[IType, IType].New(reader)
resampler.SetTransform( scale.GetPointer() )
resampler.SetInterpolator( interpolator.GetPointer() )
resampler.SetSize( size )
resampler.SetOutputSpacing( inputImage.GetSpacing() )

writer = itk.ImageFileWriter[IType].New(resampler, FileName=argv[2])
writer.Update()




