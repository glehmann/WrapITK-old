import types
import inspect
import sys
from itkTypes import itkCType
   
classToTemplateDict = {}


def registerNoTpl(name, cl):
  itkPyTemplate.__templates__[normalizeName(name)] = cl
  
  
def normalizeName(name):
  # Normalize the class name to have no ambiguity
  # while searching them
  try:
      name=name.replace(" ","")
      #name=name.replace("::","") -- keep around the namespace prefix
      name=name.replace("*","")
  except:
      return("")
  else:
      return(name)


#------------------------------------------------------------------------------
class itkPyTemplate:
   """
   This class manage access to avaible types of a template C++ class
   """
   __templates__ = {}
   __class_to_template__ = {}
   __named_templates__ = {}
   
   def __init__(self,name):
      # all instances of itkPyTemplate with the same name share a single __dict__
      # and __template__ dictionary. This is essnetially the "borg" pattern
      # where you can make many instances that share the same state.
      self.__template__, self.__dict__ = itkPyTemplate.__named_templates__.setdefault(name, ({},{}))
      self.__name__ = name
  
   # define equality and hash methods to reflect the fact that itkPyTemplate instances
   # with the same name should be considered equal.
   # This could all be done better with a singleton pattern implemented in __new__
   # but that would limit support to python 2.2 and above.
   # TODO: determine if anyone really uses 2.1 and below anymore!
   def __eq__(self, other):
      return isinstance(other, itkPyTemplate) and self.__name__ == other.__name__
  
   def __ne__(self, other):
      return not (self == other)

   def __hash__(self):
      return self.__name__.__hash__()

   def __set__(self,type,cl):
      fullName=normalizeName(self.__name__+"<"+type+">")

      if(itkPyTemplate.__templates__.has_key(fullName)):
         print >>sys.stderr,"Warning: templated class already defined '%s'" % fullName
      itkPyTemplate.__templates__[fullName]=cl

      # Add in items
      param=tuple(self.__find_param__(type))
      if(self.__template__.has_key(param)):
         print >>sys.stderr,"Warning: template already defined '%s'" % fullName
      self.__template__[param]=cl

      # add in __class_to_template__ dictionary
      itkPyTemplate.__class_to_template__[cl] = (self, param)
      
      # Add in parameters
      if cl.__name__.endswith("_Pointer") :
        param=cl.__name__[len("itk"):-len("_Pointer")]
      else :
        # short name does not contain :: and nested namespace
        import re
        shortName = "itk" + re.sub(r'.*::', '', self.__name__)
        param=cl.__name__[len(shortName):]
      if(param.isdigit()):
         param="_"+param
      self.__dict__[param]=cl
      
      # now replace New method by a custom one
      if hasattr(cl, 'New') :
         # the new method needs to call the old one, so keep it with another (hidden) name
         cl.__New_orig__ = cl.New
         cl.New = types.MethodType(New, cl)

   def __find_param__(self,type):
      # find the parameters of the template
      part=type.split(",")

      type=[]
      inner=0
      for elt in part:
         if(inner==0):
            type.append(elt)
         else:
            type[-1]+=","+elt
         inner+=elt.count("<")-elt.count(">")

      # convert types into classes (if possible)
      param=[]
      for elt in type:
         eltNorm=normalizeName(elt)

         if(itkPyTemplate.__templates__.has_key(eltNorm)):
            # elt is a template class
            elt=itkPyTemplate.__templates__[eltNorm]
         elif(itkCType.GetCType(elt.strip())):
            # elt is a c type
            elt=itkCType.GetCType(elt.strip())
         elif(eltNorm.isdigit()):
            # elt is a number
            elt=int(elt)
         else :
            # unable to find type of elt it is
            # use it without changes, but display a warning message, to incite
            # developer to fix the problem
            print >>sys.stderr,"Warning: Unknown type '%s' in template '%s'" % (elt, self.__name__)
         param.append(elt)

      return(param)

   def __getitem__(self,key):
      # Types accepted :
      #  - int
      #  - itkCType for the standard C types (int, float, etc.)
      #  - itk Class (type of the class to use)
      #  - itk Instance (instance of the type to use)
      #  - itk SmartPointer (SmartPointer instance containing the type to use)
      if((type(key)!=types.TupleType)and(type(key)!=types.ListType)):
         key=[key]
         
      param=[]
      for elt in key:
         # In the case of itk SmartPointer, get the pointed object class
         try:
            elt=elt.GetPointer()
         except:
            pass
         # In the case where elt is a pointer <className>Ptr
         try:
            elt=elt.__dict__[elt.__class__]
         except:
            pass

         # In the case of itk class instance, get the class name
         if(not inspect.isclass(elt)):
            if((elt.__class__.__name__[:3]=='itk')and
               (elt.__class__.__name__!="itkCType")):
               elt=elt.__class__

         if(  (not isinstance(elt,itkCType))
            and(not isinstance(elt, int))
            and(not inspect.isclass(elt))):
            raise TypeError,"%s is not of type class, itkCType or int" % repr(elt)
         else:
            param.append(elt)

      try:
         return(self.__template__[tuple(param)])
      except:
         raise KeyError,'itkTemplate : No template %s for the %s class' % \
                  (str(key),self.__name__)

   def __repr__(self):
      return '<template %s>' % self.__name__

   def keys(self):
      return(self.__template__.keys())
   
   # everything after this comment is for dict interface
   # and is a copy/paste from DictMixin
   # only methods to edit dictionary are not there
   def __iter__(self):
      for k in self.keys():
         yield k

   def has_key(self,key):
      try:
         value=self[key]
      except KeyError:
         return False
      return True

   def __contains__(self,key):
      return self.has_key(key)

   # third level takes advantage of second level definitions
   def iteritems(self):
      for k in self:
         yield (k,self[k])

   def iterkeys(self):
      return self.__iter__()

   # fourth level uses definitions from lower levels
   def itervalues(self):
      for _,v in self.iteritems():
         yield v

   def values(self):
      return [v for _,v in self.iteritems()]

   def items(self):
      return list(self.iteritems())

   def get(self,key,default=None):
      try:
         return self[key]
      except KeyError:
         return default

   def __len__(self):
      return len(self.keys())

#------------------------------------------------------------------------------
# create a new New function to manage parameters
def New(self, *args, **kargs) :
        import itk, sys
        
        newItkObject = self.__New_orig__()
        
        # try to get the images from the filters in args
        args = [itk.image(arg) for arg in args]
        
        # args without name are filter used to set input image
        #
        # count SetInput calls to call SetInput, SetInput2, SetInput3, ...
        # usefull with filter which take 2 input (or more) like SubstractImageFiler
        # Ex: substract image2.png to image1.png and save the result in result.png
        # r1 = itk.ImageFileReader.US2.New(FileName='image1.png')
        # r2 = itk.ImageFileReader.US2.New(FileName='image2.png')
        # s = itk.SubtractImageFilter.US2US2US2.New(r1, r2)
        # itk.ImageFileWriter.US2.New(s, FileName='result.png').Update()
        try :
                for setInputNb, arg  in enumerate(args) :
                  methodName = 'SetInput%i' % (setInputNb+1)
                  if methodName in dir(newItkObject) :
                    # first try to use methods called SetInput1, SetInput2, ...
                    # those method should have more chances to work in case of multiple
                    # input types
                    getattr(newItkObject, methodName)(arg)
                  else :
                    # no method called SetInput?
                    # try with the standard SetInput(nb, input)
                    newItkObject.SetInput(setInputNb, arg)
        except TypeError, e :
	        # the exception have (at least) to possible reasons:
	        # + the filter don't take the input number as first argument
		# + arg is an object of wrong type
		# 
		# if it's not the first input, re-raise the exception
		if setInputNb != 0 :
		    raise e
		# it's the first input, try to use the SetInput() method without input number
		newItkObject.SetInput(args[0])
		# but raise an exception if there is more than 1 argument
                if len(args) > 1 :
                        raise TypeError('Object accept only 1 input.')
	except AttributeError :
	        # There is no SetInput() method, try SetImage
		# but before, check the number of inputs
		if len(args) > 1 :
		    raise TypeError('Object accept only 1 input.')
		newItkObject.SetImage(args[0])
		
        # named args : name is the function name, value is argument(s)
        for attribName, value in kargs.iteritems() :
                # use Set as prefix. It allow to use a shorter and more intuitive
                # call (Ex: itk.ImageFileReader.UC2.New(FileName='image.png')) than with the
                # full name (Ex: itk.ImageFileReader.UC2.New(SetFileName='image.png'))
                attrib = getattr(newItkObject, 'Set' + attribName)
                attrib(value)

        # now, try to add observer to display progress
        if itk.auto_progress :
                try :
                        def progress() :
                                clrLine = "\033[2000D\033[K"
                                # newItkObject is kept referenced with a closure
                                p = newItkObject.GetProgress()
                                print >> sys.stderr, clrLine+"%s: %f" % (repr(self), p),
                                if p == 1 :
                                        print >> sys.stderr, clrLine,

                        command = itk.PyCommand.New()
                        command.SetCommandCallable(progress)
                        newItkObject.AddObserver(itk.ProgressEvent(), command.GetPointer())
                except :
                        # it seems that something goes wrong...
                        # as this feature is designed for prototyping, it's not really a problem
                        # if an object  don't have progress reporter, so adding reporter can silently fail
                        pass

        return newItkObject

