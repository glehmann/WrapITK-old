/* This is an itk-specific typemap used by CableSwig.  Also see comments
 * and "throws" code in CableSwig.cxx.
 *   -- Charl P. Botha <cpbotha AT ieee.org>
 */
 
%include exception.i

#ifdef SWIGPYTHON

/* ------------------------------------------------------------
 * PyObject *  - Just pass straight through unmodified
 * This is default behaviour for python.swg, but Cable passes
 * a PyObject * through as a "p._object", so we redo the typemap
 * ------------------------------------------------------------ */
  
%typemap(in)   p._object "$1 = $input;";
%typemap(out)  p._object "$result = $1;";

// some nice typemaps to be able to give size and index object as python sequences (list or tuple or anything with a 
// working __getitem__ method
// sadely, at this time, %typemap(typecheck) cause swig to not declare SWIGTYPE_p_itk__*T*_t, and typemap is not usable
// without typecheck because of poor management of overloaded methods in swig (and in C++)

/*#define itkSTypemap(name, VDimension) \
%typemap(in) itk::##name##<##VDimension##>& (itk::##name##<##VDimension##> itks) { \
  if ((SWIG_ConvertPtr($input,(void **)(&$1),SWIGTYPE_p_itk__##name##T##VDimension##_t, SWIG_POINTER_EXCEPTION | 0)) == -1) { \
    if (PySequence_Check($input) && PyObject_Length($input) == VDimension) { \
      for (int i =0; i < VDimension; i++) { \
          PyObject *o = PySequence_GetItem($input,i); \
          if (!PyInt_Check(o)) { \
            PyErr_SetString(PyExc_ValueError,"Expecting a sequence of int"); \
            return NULL; \
          } \
          itks[i] = PyInt_AsLong(o); \
      } \
      $1 = &itks; \
    }else { \
      SWIG_fail; \
    } \
  } \
} \
%typemap(typecheck) itk::##name##<##VDimension##>& { \
void *ptr = NULL; \
  $1 = 1; \
  if (!PySequence_Check($input)&&(SWIG_ConvertPtr($input,(void**)(&ptr),SWIGTYPE_p_itk__##name##T##VDimension##_t, 0) == -1)) { \
    $1 = 0; \
  } \
} \


itkSTypemap(Size, 2)
itkSTypemap(Size, 3)

itkSTypemap(Index, 2)
itkSTypemap(Index, 3)*/


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

// a implementation of %extend in cableswig would also be great to move back __getitem__ method 
// added in some files in this one
   
#else

/* A "throws" attribute with the "std::exception" type is added synthetically
 * to each method node by CableSwig.cxx.  When gcc_xml starts passing through
 * correct throws types, this typemap could be optionally extended to
 * account for more different types.  For now this is sufficient though.
 */
 
%typemap(throws) std::exception {
   SWIG_exception(SWIG_RuntimeError, const_cast<char*>(_e.what()));
}

#endif



%include std_string.i

/* disable this c linkage warning on windows */
%{
#ifdef _WIN32
#pragma warning ( disable : 4190 )
#pragma warning ( disable : 4049 )
#endif
%}


