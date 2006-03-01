#!/usr/bin/env python

# def custom_callback(name):
#   print "loading %s submodule..." % name
# import itkConfig
# itkConfig.ImportCallback = custom_callback

import itk, sys

import ITKCommonA
import ITKCommonB
import ITKNumerics
import ITKBasicFiltersA
import ITKBasicFiltersB
import ITKBasicFiltersC
import ITKSpatialObject
import ITKAlgorithms
import ITKIO

PType = itk.US
dim = 2
IType = itk.Image[PType, dim]

# create the reader
reader = itk.ImageFileReader[IType].New(FileName=sys.argv[1])

sources = []
image = ITKCommonA.Image[PType, dim].New()
r = itk.ImageRegion._2()
r.SetSize((10, 10))
image.SetRegions(r)
image.Allocate()

sources.append(("ITKCommonA", image))

flip = ITKBasicFiltersA.FlipImageFilter[IType].New(reader)
sources.append(("ITKBasicFiltersA", flip.GetOutput()))

shift = ITKBasicFiltersB.ShiftScaleImageFilter[IType, IType].New(reader)
sources.append(("ITKBasicFiltersB", shift.GetOutput()))

abs = ITKBasicFiltersC.AbsImageFilter[IType, IType].New(reader)
sources.append(("ITKBasicFiltersC", abs.GetOutput()))

otsu = ITKAlgorithms.OtsuThresholdImageFilter[IType, IType].New(reader)
sources.append(("ITKAlgorithms", otsu.GetOutput()))

sources.append(("ITKIO", reader.GetOutput()))



dests = []
dflip = ITKBasicFiltersA.FlipImageFilter[IType].New()
dests.append(("ITKBasicFiltersA", dflip))

dshift = ITKBasicFiltersB.ShiftScaleImageFilter[IType, IType].New()
dests.append(("ITKBasicFiltersB", dshift))

dabs = ITKBasicFiltersC.AbsImageFilter[IType, IType].New()
dests.append(("ITKBasicFiltersC", dabs))

dotsu = ITKAlgorithms.OtsuThresholdImageFilter[IType, IType].New()
dests.append(("ITKAlgorithms", dotsu))

writer = ITKIO.ImageFileWriter[IType].New(FileName='out.png')
dests.append(("ITKIO", writer))


failure = False
for sname, s in sources:
  for dname, d in dests:
    d.SetInput( s )
    try:
      d.Update()
      print "%s -> %s pass" % (sname, dname)
    except RuntimeError, e:
      print "%s -> %s fail (%s)" % (sname, dname, str(e))
      failure = True
      
sys.exit(failure)