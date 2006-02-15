
import itk, vtk
import ItkVtkGlue

names = [name for name in dir(ItkVtkGlue) if not name.startswith("__")]
for name in names :
    setattr(itk, name, ItkVtkGlue.__dict__[name])
    
# some cleanup
del itk, vtk, ItkVtkGlue, names, name

# also keep ItkVtkGlue members in that namespace
from ItkVtkGlue import *
