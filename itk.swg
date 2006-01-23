/* This is an itk-specific typemap used by CableSwig.  Also see comments
 * and "throws" code in CableSwig.cxx.
 *   -- Charl P. Botha <cpbotha AT ieee.org>
 */
 
 
// Exception support. May be conditionally turned off by defining
// NO_EXCEPTIONS.
#ifndef NO_EXCEPTIONS

%include exception.i

#ifdef SWIGPYTHON

// check if exception is an 'index out of range' exception. If so, throw a python IndexError.
// It allow to use itk objects with __getitem__ method like standard python list
// for example, to format a size object of dim=3 in [1, 2, 3] we can use
// s = "[%s]" % ", ".join(map(str, sizeObject))
// or to get a real python list object
// l = list(sizeObject)
%typemap(throws) std::exception {
   if ( strstr(const_cast<char*>(_e.what()), ": index out of range") == NULL ) {
       SWIG_exception(SWIG_RuntimeError, const_cast<char*>(_e.what()));
   }
   else {
       PyErr_SetString(PyExc_IndexError, const_cast<char*>(_e.what()));
       return NULL;
   }
}
   
#else  // SWIGPYTHON

/* A "throws" attribute with the "std::exception" type is added synthetically
 * to each method node by CableSwig.cxx.  When gcc_xml starts passing through
 * correct throws types, this typemap could be optionally extended to
 * account for more different types.  For now this is sufficient though.
 */
 
%typemap(throws) std::exception {
   SWIG_exception(SWIG_RuntimeError, const_cast<char*>(_e.what()));
}

#endif // SWIGPYTHON

#endif // NO_EXCEPTIONS




#ifdef SWIGPYTHON

/* ------------------------------------------------------------
 * PyObject *  - Just pass straight through unmodified
 * This is default behaviour for python.swg, but Cable passes
 * a PyObject * through as a "p._object", so we redo the typemap
 * ------------------------------------------------------------ */
  
%typemap(in)   p._object "$1 = $input;";
%typemap(out)  p._object "$result = $1;";

// some nice typemaps to be able to give size and index object as python sequences (list, tuple
// or anything with a working __getitem__ method)

#define pySequenceTypemap(name, VDimension) \
%typemap(in) itk::##name##<##VDimension##>& (itk::##name##<##VDimension##> itks) { \
  if ((SWIG_ConvertPtr($input,(void **)(&$1),$1_descriptor, 0)) == -1) { \
    PyErr_Clear(); \
    if (PySequence_Check($input) && PyObject_Length($input) == ##VDimension##) { \
      for (int i =0; i < ##VDimension##; i++) { \
          PyObject *o = PySequence_GetItem($input,i); \
          if (!PyInt_Check(o)) { \
            PyErr_SetString(PyExc_ValueError,"Expecting a sequence of int"); \
            return NULL; \
          } \
          itks[i] = PyInt_AsLong(o); \
      } \
      $1 = &itks; \
    }else if (PyInt_Check($input)) { \
      for (int i =0; i < ##VDimension##; i++) { \
          itks[i] = PyInt_AsLong($input); \
      } \
      $1 = &itks; \
    } else { \
      SWIG_fail; \
    } \
  } \
} \
%typemap(typecheck) itk::##name##<##VDimension##>& { \
  void *ptr; \
  if (SWIG_ConvertPtr($input, &ptr, $1_descriptor, 0) == -1 \
      && ( !PySequence_Check($input) || PyObject_Length($input) != ##VDimension## ) \
      && !PyInt_Check($input) ) { \
    _v = 0; \
    PyErr_Clear(); \
  } else { \
    _v = 1; \
  } \
} \
%typemap(in) itk::##name##<##VDimension##> { \
  itk::##name##<##VDimension##> * s; \
  if ((SWIG_ConvertPtr($input,(void **)(&s),$1_descriptor, 0)) == -1) { \
    PyErr_Clear(); \
    if (PySequence_Check($input) && PyObject_Length($input) == ##VDimension##) { \
      for (int i =0; i < ##VDimension##; i++) { \
          PyObject *o = PySequence_GetItem($input,i); \
          if (!PyInt_Check(o)) { \
            PyErr_SetString(PyExc_ValueError,"Expecting a sequence of int"); \
            return NULL; \
          } \
          $1[i] = PyInt_AsLong(o); \
      } \
    }else if (PyInt_Check($input)) { \
      for (int i =0; i < ##VDimension##; i++) { \
          $1[i] = PyInt_AsLong($input); \
      } \
    } else { \
      SWIG_fail; \
    } \
  } else { \
    $1 = *s; \
  } \
} \
%typemap(typecheck) itk::##name##<##VDimension##> { \
  void *ptr; \
  if (SWIG_ConvertPtr($input, &ptr, $1_descriptor, 0) == -1 \
       && ( !PySequence_Check($input) || PyObject_Length($input) != ##VDimension## ) \
       && !PyInt_Check($input) ) { \
    _v = 0; \
    PyErr_Clear(); \
  } else { \
    _v = 1; \
  } \
} \

pySequenceTypemap(Index, 1)
pySequenceTypemap(Index, 2)
pySequenceTypemap(Index, 3)
pySequenceTypemap(Index, 4)

pySequenceTypemap(Size, 1)
pySequenceTypemap(Size, 2)
pySequenceTypemap(Size, 3)
pySequenceTypemap(Size, 4)



%typemap(out) itk::Image< unsigned char, 2 > * {
  std::string methodName = "$symname";
  if(methodName.find("GetPointer") != -1) {
    // really return a pointer in that case
    $result = SWIG_NewPointerObj((void *)($1), $1_descriptor, 1);
  } else {
    itk::SmartPointer<itk::Image< unsigned char, 2 > > * ptr;
    ptr = new itk::SmartPointer<itk::Image< unsigned char, 2 > >($1);
    $result = SWIG_NewPointerObj((void *)(ptr), $descriptor(itk::SmartPointer<itk::Image< unsigned char, 2 > > *), 1);
  }
}
%typemap(in) itk::Image< unsigned char, 2 > * {
  itk::SmartPointer<itk::Image< unsigned char, 2 > > * sptr;
  itk::Image< unsigned char, 2 > * ptr;
  if ((SWIG_ConvertPtr($input,(void **) &sptr, $descriptor(itk::SmartPointer<itk::Image< unsigned char, 2 > > *), SWIG_POINTER_EXCEPTION)) == -1) {
    // not a smart pointer
    if ((SWIG_ConvertPtr($input,(void **) &ptr, $1_descriptor, SWIG_POINTER_EXCEPTION)) == -1) {
      SWIG_fail;
    } else {
      // we have a simple pointer
      $1 = ptr;
    }
  } else {
    $1 = sptr->GetPointer();
  }
}
%typemap(typecheck) itk::Image< unsigned char, 2 > * {
  void *ptr;
  if (SWIG_ConvertPtr($input, &ptr, $1_descriptor, 0) == -1
      && SWIG_ConvertPtr($input, &ptr, $descriptor(itk::SmartPointer<itk::Image< unsigned char, 2 > > *), 0) == -1) {
    _v = 0;
    PyErr_Clear();
  } else {
    _v = 1;
  }
}


%typemap(out) unsigned char &, const unsigned char &, \
  signed char &, const signed char &, \
  unsigned short &, const unsigned short &, \
  signed short &, const signed short &, \
  unsigned long &, const unsigned long &, \
  signed long &, const signed long & \
  {$result = PyInt_FromLong( *$1 );}

%typemap(out) float &, const float &, \
  double &, const double & \
  {$result = PyFloat_FromDouble( *$1 );}


// a implementation of %extend in cableswig would also be great to move back __getitem__ method 
// added in some files in this one

#endif


%include std_string.i

/* disable this c linkage warning on windows 
TODO: Should this be handled in itkConfigWrapping.cmake? Some errors are already
      disabled. (see around line 234 of that file.)
*/
%{
#ifdef _WIN32
#pragma warning ( disable : 4190 )
#pragma warning ( disable : 4049 )
#endif
%}


