class itkCType :
   __cTypes__ = {}

   def __init__(self,name,shortName):
      self.__name=name
      self.__shortName=shortName

      itkCType.__cTypes__[self.__name]=self

   def __del__(self):
      try:
         del itkCType.__cTypes__[self.__name]
      except:
         pass

   def __repr__(self):
      return "<itkCType %s>" % self.__name

   def GetCType(name):
      try:
         return(itkCType.__cTypes__[name])
      except KeyError:
         return(None)
   GetCType=staticmethod(GetCType)


F=itkPyTemplate.itkCType("float",          "F")
D=itkPyTemplate.itkCType("double",         "D")
UC=itkPyTemplate.itkCType("unsigned char", "UC")
US=itkPyTemplate.itkCType("unsigned short","US")
UI=itkPyTemplate.itkCType("unsigned int",  "UI")
UL=itkPyTemplate.itkCType("unsigned long", "UL")
SC=itkPyTemplate.itkCType("signed char",   "SC")
SS=itkPyTemplate.itkCType("signed short",  "SS")
# SI=itkPyTemplate.itkCType("signed int",    "SI")
SL=itkPyTemplate.itkCType("signed long",   "SL")
B=itkPyTemplate.itkCType("bool",           "B")
