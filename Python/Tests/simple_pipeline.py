#!/usr/bin/env

import itk, sys, itkTypes

PType = itkTypes.itkCType.GetCType(sys.argv[1])
IType = itk.Image[PType, 2]

reader = itk.ImageFileReader[IType].New(FileName=sys.argv[2])
writer = itk.ImageFileWriter[IType].New(reader, FileName=sys.argv[3])
writer.Update()
