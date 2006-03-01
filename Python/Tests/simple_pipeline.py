#!/usr/bin/env python

def custom_callback(name):
  print "loading %s submodule..." % name
import itkConfig
itkConfig.ImportCallback = custom_callback

import itk, sys

# first argument is the pixel type
PType = itk.ctype(sys.argv[1])
# second arguement the image dimension
dim = int(sys.argv[2])

# get the image type
IType = itk.Image[PType, dim]

# create the reader
reader = itk.ImageFileReader[IType].New(FileName=sys.argv[3])
# use a filter outside the IO sub module to be sure objects can be pass
# from one module to one other
cast1 = itk.CastImageFilter[IType, IType].New(reader)
cast1.Update()
shift = itk.ShiftScaleImageFilter[IType, IType].New(cast1)
shift.Update()
cast2 = itk.CastImageFilter[IType, IType].New(shift)
cast2.Update()
# and the writer
writer = itk.ImageFileWriter[IType].New(cast2, FileName=sys.argv[4])

# execute the filters in the pipeline !
writer.Update()
