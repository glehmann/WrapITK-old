"""itk.py : Top-level container module for ITK wrappers."""
import itkBase, itkConfig, itkLazy, itkTypes, itkExtras, os, sys

if itkConfig.LazyLoading:
  # If we are loading lazily (on-demand), make a dict mapping the available 
  # classes/functions/etc. (read from the configuration modules) to the 
  # modules they are declared in. Then pass that dict to a LazyITKModule
  # instance and do some surgery on sys.modules so that the 'itk' module
  # becomes that new instance instead of what is executed from this file.
  lazyAttributes = {}
  for module, data in itkBase.module_data.items():
    templateNames = [ t[0] for t in data['templates'] ]
    lazyAttributes.update( (n, module) for n in templateNames)
  sys.modules[__name__] = itkLazy.LazyITKModule(__name__, lazyAttributes)
else: 
  # Load the modules in the order specified in the known_modules list
  # for consistency.
  for module in itkBase.known_modules:
      itkBase.LoadModule(module, globals())

# Now load up the itk module (either this module, or the LazyITKModule
# instance created above) with the types and extras information.
thisModule =  sys.modules[__name__]
for k, v in itkTypes.__dict__.items():
  if k != 'itkCType': setattr(thisModule, k, v)
for k, v in itkExtras.__dict__.items():
  setattr(thisModule, k, v)

# Clean up the namespace -- only matters if we aren't using lazy loading.
del configModules, module, thisModule
del itkBase, itkConfig, itkLazy, itkTypes, itkExtras, os, sys
