SILENT = 0; WARN = 1; ERROR = 2
DebugLevel = WARN

def LoadModule(name, namespace = None):
  """This function causes a SWIG module to be loaded into memory after its dependencies
  are satisfied. Information about the templates defined therein is looked up from 
  a config file, and PyTemplate instances for each are created. These template 
  instances are placed in a module with the given name that is either looked up 
  from sys.modules or created and placed there if it does not already exist.
  Optionally, a 'namespace' parameter can be provided. If it is provided, this
  namespace will be updated with the new template instantiations.
  The raw classes loaded from the named module's SWIG interface are placed in a 
  'swig' sub-module. If the namespace parameter is provided, this information will
  be placed in a sub-module named 'swig' therein as well. This latter submodule
  will be created if it does not already exist."""
  import sys, imp, itkPyTemplate
  
  # find the module's name in sys.modules, or create a new module so named
  this_module = sys.modules.setdefault(name, imp.new_module(name))
 
  # if this library and it's template instantiations have already been loaded
  # into sys.modules, bail out
  if hasattr(this_module, '__templates_loaded') : return
  
  # We're definitely going to load the templates. We set templates_loaded here
  # instead of at the end of the file to protect against cyclical dependencies
  # that could kill the recursive lookup below.
  this_module.__templates_loaded = True 
  
  # Now, we we definitely need to load the template instantiations from the
  # named module, and possibly also load the underlying SWIG module. Before we
  # can load the template instantiations of this module, we need to load those
  # of the modules on which this one depends. Ditto for the SWIG modules.
  # So, we recursively satisfy the dependencies of named module and create the
  # template instantiations.
  # Dependencies are looked up from the auto-generated configuration files, via 
  # the module_data instance defined at the bottom of this file, which knows how
  # to find those configuration files.
  data = module_data[name]
  if data:
    for dep in data.depends:
      LoadModule(dep)
  
  # SWIG-generated modules have 'Python' appended. Only load the SWIG module if
  # we haven't already.
  swigModuleName = name + "Python"
  if not swigModuleName in sys.modules: module = LoadSWIGLibrary(swigModuleName)
  
  # OK, now the modules on which this one depends are loaded and template-instantiated,
  # and the SWIG module for this one is also loaded.
  # We're going to put the things we load and create in two places: the optional 
  # 'namespace' parameter, and the this_module variable's namespace.
  
  # make a new 'swig' sub-module for this_module. Also look up or create a 
  # different 'swig' module for 'namespace'. Since 'namespace' may be used to 
  # collect symbols from multiple different ITK modules, we don't want to 
  # stomp on an existing 'swig' module, nor do we want to share 'swig' modules
  # between this_module and namespace.
  
  this_module.swig = imp.new_module('swig')
  if namespace: swig = namespace.setdefault('swig', imp.new_module('swig'))
  for k, v in module.__dict__.items():
    if not k.startswith('__'): setattr(this_module.swig, k, v)
    if namespace and not k.startswith('__'): setattr(swig, k, v)

  data = module_data[name]
  if data:
    for template in data.templates:
      if len(template) == 4: 
        # this is a template description      
        pyClassName, cppClassName, swigClassName, templateParams = template
        # It doesn't matter if an itkPyTemplate for this class name already exists
        # since every instance of itkPyTemplate with the same name shares the same
        # state. So we just make a new instance and add the new templates.
        templateContainer = itkPyTemplate.itkPyTemplate(cppClassName)
        try: templateContainer.__set__(templateParams, getattr(module, swigClassName))
        except Exception, e: DebugPrintError("%s not loaded from module %s because of exception:\n %s" %(swigClassName, name, e))
        setattr(this_module, pyClassName, templateContainer)
        if namespace:
          current_value = namespace.get(pyClassName)
          if current_value != None and current_value != templateContainer:
            DebugPrintError("Namespace already has a value for %s, which is not an itkPyTemplate instance for class %s. Overwriting old value." %(pyClassName, cppClassName))
          namespace[pyClassName] = templateContainer
        
      else:
        # this is a description of a non-templated class
        pyClassName, cppClassName, swigClassName = template
        try: swigClass = getattr(module, swigClassName)
        except Exception, e: DebugPrintError("%s not found in module %s because of exception:\n %s" %(swigClassName, name, e))
        itkPyTemplate.registerNoTpl(cppClassName, swigClass)
        setattr(this_module, pyClassName, swigClass)
        if namespace:
          current_value = namespace.get(pyClassName)
          if current_value != None and current_value != swigClass:
            DebugPrintError("Namespace already has a value for %s, which is not class %s. Overwriting old value." %(pyClassName, cppClassName))
          namespace[pyClassName] = swigClass
  
def LoadSWIGLibrary(moduleName):
  """Do all the work to set up the environment so that a SWIG-generated library
  can be properly loaded. This invloves setting paths, etc., defined in itkConfig."""
  import sys, imp, itkConfig
  
  # To share symbols across extension modules, we must set
  #     sys.setdlopenflags(dl.RTLD_NOW|dl.RTLD_GLOBAL)
  #
  # Since RTLD_NOW==0x002 and RTLD_GLOBAL==0x100 very commonly
  # we will just guess that the proper flags are 0x102 when there
  # is no dl module.

  # Save the current dlopen flags and set the ones we need.
  try:
    import dl
    newflags = dl.RTLD_NOW|dl.RTLD_GLOBAL
  except:
    newflags = 0x102  # No dl module, so guess (see above).
  try:
    oldflags = sys.getdlopenflags()
    sys.setdlopenflags(newflags)
  except:
    oldflags = None
  
  # set the path so that the imported module can load swig-generated shared  
  # libraries or other swig-generated scripts.
  sys.path.insert(1, itkConfig.swig_lib)
  sys.path.insert(1, itkConfig.swig_py)
  
  # find and load the module
  try:
    fp = None # needed in case next line raises exception, so that finally block works
    fp, pathname, description = imp.find_module(moduleName, [itkConfig.swig_py,])
    return imp.load_module(moduleName, fp, pathname, description)
  finally:
    # Since we may exit via an exception, close fp explicitly.
    if fp: fp.close()
    # and restore environment to normalcy
    sys.path.remove(itkConfig.swig_lib)
    sys.path.remove(itkConfig.swig_py)
    if oldflags and hasattr(sys, 'setdlopenflags'):
      # try to avoid raising an exception, because if we do, the import exception
      # that might have occured above in the try block won't get reported.
      try: sys.setdlopenflags(oldflags)
      except: pass

class ModuleData(dict):
  """A dictionary that knows how to look up module configuration data from the
  auto-generated configuration files. The location of these files is specified in
  itkConfig."""
  
  def __getitem__(self, key):
    import os, itkConfig
    try:
      return dict.__getitem__(self, key)
    except KeyError:
      # search order for keyConfig.py: 
      # (1) itkConfig.config_py directory
      # (2) __file__/Configuration
      # (3) ./Configuration
      # (4) .
      data = self.__find_file(key, [itkConfig.config_py, 
        os.path.join(__file__, 'Configuration'), 'Configuration', '.'])
      if data:
        return data
      else:
        DebugPrintError("Could not find configuration data for module %s." %key)
        
  def __find_file(self, module, paths):
    import os
    configFile = "%sConfig.py" %module
    for path in paths:
      try: listing = os.listdir(path)
      except: continue
      if configFile in listing:
        result = self.AttributeDict() # so we can write 'result.depends, etc., instead of result['depends']'
        execfile(os.path.join(path, configFile), result)
        self[file] = result
        return result
    return None
  
  class AttributeDict(dict):
    """A dictionary that can be accessed with __getattribute__, so that d[key] or
    d.key both return the value for that key."""    
    def __getattribute__(self, key):
      try:
        return self[key]
      except:
        return dict.__getattribute__(self, key)

def DebugPrintError(error):
  import sys
  if DebugLevel == WARN:
    print >> sys.stderr, error
  elif DebugLevel == ERROR:
    raise RuntimeError(error)


module_data = ModuleData()