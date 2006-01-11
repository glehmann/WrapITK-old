from itktypes import *

# the following modules are not imported to avoid problems with classes wrapped
# in several modules (for example Image)
from os.path import dirname, join
execfile(join(dirname(__file__), "itkcommonaPy.py"))
execfile(join(dirname(__file__), "itkcommonbPy.py"))
execfile(join(dirname(__file__), "itknumericsPy.py"))
execfile(join(dirname(__file__), "itkbasicfiltersaPy.py"))
execfile(join(dirname(__file__), "itkbasicfiltersbPy.py"))
execfile(join(dirname(__file__), "itkbasicfilterscPy.py"))
execfile(join(dirname(__file__), "itkspatialobjectPy.py"))
execfile(join(dirname(__file__), "itkalgorithmsPy.py"))
execfile(join(dirname(__file__), "itkioPy.py"))
del dirname, join

# new features introduced by itk module
# each new feature use a name in lower case

# set this variable to True to automatically add an progress display to the newly created
# filter.
auto_progress = False

# Function to print itk object info
import sys
def echo(object, f=sys.stderr) :
   ss = StringStream()
   try :
      try:
         object.Print(ss.GetStream())
      except:
         object.Print(ss.GetStream(),Indent.New());
   except:
      print >> f, repr(object)
   else:
      print >> f, ss.GetString()
del sys

# return the size of an imageClass
def size(imageOrFilter) :
  imageOrFilter.Update()
  img = image(imageOrFilter)
  return img.GetLargestPossibleRegion().GetSize()
  
# return a structuring elt
def strel(imageClass, radius=1) :
  # be sure to have an image class
  imageClass = classFromObject(imageClass)
  (tpl, param) = template(imageClass)
  if tpl != Image :
    raise ValueError, "imageClass must be an Image class or object"
  
  # create the structuring element
  (pType, dim) = param
  st = BinaryBallStructuringElement[pType, dim]()
  
  # and fill the radius
  if isinstance(radius, tuple) or isinstance(radius, list) :
    # we must be sure the size of the given radius is the same
    # than the image dim
    if dim != len(radius) :
      raise ValueError, "Radius must have the same size than the image"
    s = st.GetRadius()
    for i, elt in enumerate(radius) :
      s.SetElement(i, elt)
    st.SetRadius(s)
  else :
    st.SetRadius(radius)
    
  # finally, call the boring CreateStructuringElement() method
  st.CreateStructuringElement()
  return st
  
# return an image
def image(input) :
    try :
	img = input.GetOutput()
    except AttributeError :
	img = input
    try :
	img = img.GetPointer()
    except AttributeError :
	pass
    return img

# return the template of a class and its parameters
def template(cl) :
  from itkPyTemplate import classToTemplateDict
  return classToTemplateDict[cl]
  
# return a class from an instance
def classFromObject(obj) :
  import inspect
  if inspect.isclass(obj) :
    # obj is already a class !
    return obj
  else :
    # First, drop the smart pointer
    try:
      obj = obj.GetPointer()
    except:
      pass
    # try to get the real object if elt is a pointer (ends with Ptr)
    try:
      cls = obj.__dict__[obj.__class__]
    except:
      cls = obj.__class__
    # finally, return the class found
    return cls

# return range
def range(imageOrFilter) :
  imageOrFilter.Update()
  img = image(imageOrFilter)
  comp = MinimumMaximumImageCalculator[img].New(Image=img)
  comp.Compute()
  return (comp.GetMinimum(), comp.GetMaximum())

# write an image
def write(imageOrFilter, fileName):
  imageOrFilter.Update()
  img = image(imageOrFilter)
  writer = ImageFileWriter[img].New(Input=img, FileName=fileName)
  writer.Update()
  
# choose the method to call according to the dimension of the image
def show(input, **kargs) :
    img = image(input)
    if img.GetImageDimension() == 3:
	return show3D(input, **kargs)
    else :
	# print "2D not supported yet, use the 3D viewer."
	return show2D(input, **kargs)
    
class show2D :
  def __init__(self, input) :
    # use the tempfile module to get a non used file name and to put
    # the file at the rignt place
    import tempfile
    self.__tmpFile__ = tempfile.NamedTemporaryFile(suffix='.tif')
    write(input, self.__tmpFile__.name)
    # no run imview
    import os
    os.system("imview %s -fork" % self.__tmpFile__.name)
    #tmpFile.close()

# display scalar images in volume
class show3D :
  def __init__(self, input=None, MinOpacity=0.0, MaxOpacity=0.2) :
    import qt
    import vtk
    import itkvtk
    from vtk.qt.QVTKRenderWindowInteractor import QVTKRenderWindowInteractor
    self.__MinOpacity__ = MinOpacity
    self.__MaxOpacity__ = MaxOpacity
    # every QT app needs an app
    self.__app__ = qt.QApplication(['itkviewer'])
    # create the widget
    self.__widget__ = QVTKRenderWindowInteractor()
    self.__ren__ = vtk.vtkRenderer()
    self.__widget__.GetRenderWindow().AddRenderer(self.__ren__)
    self.__itkvtkConverter__ = None
    self.__volumeMapper__ = vtk.vtkVolumeTextureMapper2D()
    self.__volume__ = vtk.vtkVolume()
    self.__volumeProperty__ = vtk.vtkVolumeProperty()
    self.__volume__.SetMapper(self.__volumeMapper__)
    self.__volume__.SetProperty(self.__volumeProperty__)
    self.__ren__.AddVolume(self.__volume__)
    self.__outline__ = None
    self.__outlineMapper__ = None
    self.__outlineActor__ = None
    self.AdaptColorAndOpacity(0, 255)
    if input :
      self.SetInput(input)
      self.AdaptColorAndOpacity()
      
  def Render(self):
    self.__ren__.Render()
    
  def GetWidget(self) :
    return self.__widget__
  
  def GetRenderer(self) :
    return self.__ren__
  
  def GetConverter(self) :
    return self.__itkvtkConverter__
  
  def GetVolumeMapper(self) :
    return self.__volumeMapper__
  
  def GetVolume(self) :
    return self.__volume__
  
  def GetVolumeProperty(self) :
    return self.__volumeProperty__
  
  def Show(self) :
    self.__widget__.show()
    
  def Hide(self) :
    self.__widget__.hide()
    
  def SetInput(self, input) :
    img = image(input)
    self.__input__ = img
    if img :
      # Update to try to avoid to exit if a c++ exception is throwed
      # sadely, it will not prevent the program to exit later...
      # a real fix would be to wrap c++ exception in vtk
      img.Update()
      import itkvtk
      self.__flipper__ = FlipImageFilter[img].New(Input=img)
      axes = self.__flipper__.GetFlipAxes()
      axes.SetElement(1, True)
      self.__flipper__.SetFlipAxes(axes)
      self.__itkvtkConverter__ = itkvtk.ImageToVTKImageFilter[img].New(self.__flipper__)
      self.__volumeMapper__.SetInput(self.__itkvtkConverter__.GetOutput())
      # needed to avoid warnings
      # self.__itkvtkConverter__.GetOutput() must be callable
      import vtk
      if not self.__outline__ :
	  self.__outline__ = vtk.vtkOutlineFilter()
	  self.__outline__.SetInput(self.__itkvtkConverter__.GetOutput())
	  self.__outlineMapper__ = vtk.vtkPolyDataMapper()
	  self.__outlineMapper__.SetInput(self.__outline__.GetOutput())
	  self.__outlineActor__ = vtk.vtkActor()
	  self.__outlineActor__.SetMapper(self.__outlineMapper__)
	  self.__ren__.AddActor(self.__outlineActor__)
      else :
	  self.__outline__.SetInput(self.__itkvtkConverter__.GetOutput())

    self.Render()
    
  def GetInput(self):
    return self.__input__
  
  def AdaptColorAndOpacity(self, minVal=None, maxVal=None):
    if minVal == None or maxVal == None :
      m, M = self.GetRange()
      if minVal == None :
        minVal = m
      if maxVal == None :
        maxVal = M
    self.AdaptOpacity(minVal, maxVal)
    self.AdaptColor(minVal, maxVal)
    
  def AdaptOpacity(self, minVal=None, maxVal=None) :
    import vtk
    if minVal == None or maxVal == None :
      m, M = self.GetRange()
      if minVal == None :
        minVal = m
      if maxVal == None :
        maxVal = M
    opacityTransferFunction = vtk.vtkPiecewiseFunction()
    opacityTransferFunction.AddPoint(minVal, self.__MinOpacity__)
    opacityTransferFunction.AddPoint(maxVal, self.__MaxOpacity__)
    self.__volumeProperty__.SetScalarOpacity(opacityTransferFunction)
    
  def AdaptColor(self, minVal=None, maxVal=None):
    import vtk
    if minVal == None or maxVal == None :
      m, M = self.GetRange()
      if minVal == None :
        minVal = m
      if maxVal == None :
        maxVal = M
    colorTransferFunction = vtk.vtkColorTransferFunction()
    colorTransferFunction.AddHSVPoint(minVal, 0.0, 0.0, 0.0)
    colorTransferFunction.AddHSVPoint((maxVal-minVal)*0.25, 0.66, 1.0, 1.0)
    colorTransferFunction.AddHSVPoint((maxVal-minVal)*0.5,  0.44, 1.0, 1.0)
    colorTransferFunction.AddHSVPoint((maxVal-minVal)*0.75, 0.22, 1.0, 1.0)
    colorTransferFunction.AddHSVPoint(maxVal,               0.0,  1.0, 1.0)
    self.__volumeProperty__.SetColor(colorTransferFunction)
    self.Render()
    
  def GetRange(self) :
    conv = self.GetConverter()
    conv.Update()
    return conv.GetOutput().GetScalarRange()
  
  def GetMaxOpacity(self) :
    return self.__MaxOpacity__
  
  def GetMinOpacity(self) :
    return self.__MinOpacity__
  
  def SetMaxOpacity(self, val) :
    self.__MaxOpacity__ = val
    self.AdaptColorAndOpacity()
    
  def SetMinOpacity(self, val) :
    self.__MinOpacity__ = val
    self.AdaptColorAndOpacity()
