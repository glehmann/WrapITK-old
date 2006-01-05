from itkPython import *

print "#######################################################################"
print itkImage
print "-----------------------------------------------------------------------"
for elt in itkImage.keys():
   print elt
print "-----------------------------------------------------------------------"
for elt in itkImage.items():
   print elt
print "-----------------------------------------------------------------------"
print itkImage[itkUS,2]
print
print "#######################################################################"
print itkDifferenceImageFilter
print "-----------------------------------------------------------------------"
for elt in itkDifferenceImageFilter.keys():
   print elt
print "-----------------------------------------------------------------------"
for elt in itkDifferenceImageFilter.items():
   print elt
print "-----------------------------------------------------------------------"
print itkDifferenceImageFilter[itkImage[itkUS,2],itkImage[itkUS,2]]
print itkDifferenceImageFilter[itkImage[itkUS,2].New(),itkImage[itkUS,2]]
print itkDifferenceImageFilter[itkImage[itkUS,2].New().GetPointer(),itkImage[itkUS,2]]

