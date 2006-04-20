from types import ModuleType
import sys, os
import itkBase, itkConfig, itkTypes, itkExtras

class NotLoaded(object):
  def __init__(self):
    raise RuntimeError('Not Loaded')

class LazyModuleType(ModuleType):  
  def __init__(self, attr_to_module_map, loader):
    self.attr_to_module_map = attr_to_module_map
    self.module_to_attr_map = {}
    for (attr, module) in attr_to_module_map.items():
      self.module_to_attr_map.setdefault(module, []).append(attr)
    self.loader = loader
    self.__dict__.update( (attr, NotLoaded) for attr in attr_to_module_map.keys() )
  def __getattribute__(self, attr):
    value = ModuleType.__getattribute__(self, attr)
    if value is NotLoaded:
      module = self.attr_to_module_map[attr]
      namespace = {}
      self.loader(module, namespace)
      # put things in namespace first, then self.__dict__ to prevent warnings
      # about overwriting the 'NotLoaded' values already in self.__dict__
      self.__dict__.update(namespace)
      value = self.__dict__[attr]
    return value 


# First, find all the xxxConfig.py files in the config_py dir, and strip off the
# 'Config.py' part of the filename.
configModules = [f[:-9] for f in os.listdir(itkConfig.config_py) if f.endswith('Config.py')]
configModules.sort()
attr_to_module_map = {}
for module in configModules:
  templateNames = [t[0] for t in itkBase.module_data[module].templates]
  attr_to_module_map.update( (n, module) for n in templateNames)

itk = LazyModuleType(attr_to_module_map, itkBase.LoadModule)

itk.__dict__.update( (k, v) for k, v in itkTypes.__dict__.items() if not k.startswith('__'))
itk.__dict__.update( (k, v) for k, v in itkExtras.__dict__.items() if not k.startswith('__'))
del itk.__dict__['itkCType']
sys.modules['itk'] = itk

del sys, os, itkBase, itkConfig, LazyModuleType, itkTypes, itkExtras
