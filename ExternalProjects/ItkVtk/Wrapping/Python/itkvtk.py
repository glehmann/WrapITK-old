
import itk
import ItkVtkPy

names = [name for name in dir(ItkVtkPy) if not name.startswith("__")]
for name in names :
    setattr(itk, name, ItkVtkPy.__dict__[name])
    
# some cleanup
del itk, ItkVtkPy, names, name

# also keep ItkVtkPy members in that namespace
from ItkVtkPy import *
