
import itk, vtk
import ItkVtk

names = [name for name in dir(ItkVtk) if not name.startswith("__")]
for name in names :
    setattr(itk, name, ItkVtk.__dict__[name])
    
# some cleanup
del itk, vtk, ItkVtk, names, name

# also keep ItkVtk members in that namespace
from ItkVtk import *
