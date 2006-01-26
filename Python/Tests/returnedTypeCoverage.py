import itk, re
itk.auto_progress = True
try:
    import itkvtk
except:
    pass
from itkPyTemplate import itkPyTemplate


def exploreTpl(tpl):
    for cl in tpl.itervalues():
	exploreMethods(cl)
	# try to instanciate the class
	try :
	    obj = cl.New()
	    exploreMethods(obj)
	except:
	    pass
	try :
	    exploreMethods(cl())
	except:
	    pass
    
def exploreMethods(obj):
    excludeList = ['Delete', 'Unregister', 'UnRegister', 'Update', 'UpdateLargestPossibleRegion', 'GenerateInputRequestedRegion', 'GenerateOutputInformation', 'GenerateData', 'GetImageIO', 'EnlargeOutputRequestedRegion', 'UpdateOutputData', 'UpdateOutputInformation']
    attrNameList = [i for i in dir(obj) if isinstance(i, str) and i[0].isupper() and i not in excludeList]
	    
    for attrName in attrNameList:
# 	print "   +++", attrName
	try :
	    exec "s = obj.%s()" % attrName
	    if isUnwrappedTypeString(s):
		print repr(s), ":", attrName #, ":" , repr(obj)
	except :
	    # try with some parameters
	    if attrName not in ['GetElement', 'RegisterFactory', 'UnRegisterFactory', 'PropagateRequestedRegion', 'Resize'] and not attrName.startswith('Set') :
 #		print '   ***', attrName
		for param in [0, '', False, None] :
		    try :
			exec "s = obj.%s(param)" % attrName
			if isUnwrappedTypeString(s):
			    print repr(s), ":", attrName #, ":", repr(obj)
		    except :
			pass
	
def isUnwrappedTypeString(s):
    if not isinstance(s, str):
	return False
    if not s[0] == "_":
	return False
    for t in ['double', 'float', 'signed_char', 'signed_short', 'signed_long', 'unsigned_char', 'unsigned_short', 'unsigned_long', 'char', 'short', 'long', 'bool', 'int', 'unsigned_int', 'void'] :
	if re.match('^_[0-9a-z]+_p_%s$' % t, s) :
	    return False
    return True
    
attrNameList = [i for i in dir(itk) if i[0].isupper() and len(i) > 2]

# remove attr which cause problems
attrNameList.remove('BinaryBallStructuringElement')
attrNameList.remove('Neighborhood')
# attrNameList.remove('BSplineDecompositionImageFilter')
# attrNameList.remove('AtanImageFilter')
# attrNameList.remove('Atan2ImageFilter')
attrNameList.remove('ChangeInformationImageFilter')
attrNameList.remove('GeodesicActiveContourLevelSetImageFilter')
attrNameList.remove('Image')
attrNameList.remove('ImageBase')
attrNameList.remove('ImageFileReader')
attrNameList.remove('ImageFileWriter')
attrNameList.remove('ImageRegistrationMethod')
attrNameList.remove('BSplineDownsampleImageFilter')
attrNameList.remove('BSplineUpsampleImageFilter')
attrNameList.remove('CropImageFilter')
attrNameList.remove('LevelSetFunction')
attrNameList.remove('MattesMutualInformationImageToImageMetric')
attrNameList.remove('MeanReciprocalSquareDifferenceImageToImageMetric')
attrNameList.remove('MeanSquaresImageToImageMetric')
attrNameList.remove('MultiResolutionImageRegistrationMethod')
attrNameList.remove('MultiResolutionPyramidImageFilter')
attrNameList.remove('MutualInformationImageToImageMetric')
attrNameList.remove('NormalizedCorrelationImageToImageMetric')
attrNameList.remove('ParallelSparseFieldLevelSetImageFilter')
attrNameList.remove('PyBuffer')
attrNameList.remove('RawImageIO')
attrNameList.remove('RecursiveMultiResolutionPyramidImageFilter')
attrNameList.remove('ResampleImageFilter')
attrNameList.remove('RescaleIntensityImageFilter')
attrNameList.remove('SegmentationLevelSetImageFilter')
attrNameList.remove('ShapeDetectionLevelSetImageFilter')
attrNameList.remove('SparseFieldFourthOrderLevelSetImageFilter')
attrNameList.remove('SparseFieldLevelSetImageFilter')
attrNameList.remove('SpatialObject')
attrNameList.remove('SpatialObjectTreeNode')
attrNameList.remove('WatershedImageFilter')
attrNameList.remove('TreeNode')
attrNameList.remove('ThresholdSegmentationLevelSetImageFilter')
attrNameList.remove('PointSet')

for name in attrNameList:
    attr = itk.__dict__[name]
    print "-----------", name, "-----------"
    if isinstance(attr, itkPyTemplate) :
	exploreTpl(attr)
    else :
	exploreMethods(attr)
        try :
	    exploreMethods(cl.New())
	except:
	    pass
	try :
	    exploreMethods(cl())
	except:
	    pass
								
