# Auto-load the modules described in the itkConfig.config_py directory (usually
# WrapITK/Python/Configuration, and populate the 'itk' namespace with the templates.
import itkBase, itkConfig, os
# First, find all the xxxConfig.py files in the config_py dir, and strip off the
# 'Config.py' part of the filename.
configModules = [f[:-9] for f in os.listdir(itkConfig.config_py) if f.endswith('Config.py')]
configModules.sort()

for module in configModules:
  # If the configuration defines an auto_load attribute and it's set to True
  # then load the module into the global 'itk' namespace
  if ( hasattr(itkBase.module_data[module], 'auto_load') and 
       itkBase.module_data[module].auto_load == True ):
    itkBase.LoadModule(module, globals())

del itkBase, itkConfig, os

from itkTypes import *
del itkCType
from itkExtras import *