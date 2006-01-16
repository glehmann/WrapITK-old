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
    excludeList = ['this', 'thisown']
    attrNameList = [i for i in dir(obj) if isinstance(i, str) and i[0].isupper() and i not in excludeList]
    if attrNameList == [] :
      print obj
	
    
attrNameList = [i for i in dir(itk) if i[0].isupper() and len(i) > 2]

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
								
