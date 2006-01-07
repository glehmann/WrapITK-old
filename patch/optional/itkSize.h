*** itk/Insight/Code/Common/itkSize.h	2006-01-07 15:09:45.000000000 +0100
--- itk-mima2/Insight/Code/Common/itkSize.h	2005-10-24 13:50:58.000000000 +0200
***************
*** 18,23 ****
--- 18,24 ----
  #define __itkSize_h
  
  #include "itkMacro.h"
+ #include "itkExceptionObject.h"
  
  namespace itk
  {
***************
*** 188,193 ****
--- 189,221 ----
     * bracketed initializer. */
    SizeValueType m_Size[VDimension];
  
+ //#ifdef SWIGPYTHON
+   const SizeValueType __getitem__(unsigned int dim) const 
+     {
+     if (dim >= VDimension)
+       {throw ExceptionObject(__FILE__, __LINE__, "itk::ERROR: Size: index out of range");}
+     return GetElement(dim);
+     }
+   void __setitem__(unsigned int dim, SizeValueType value)
+     {
+     if (dim >= VDimension)
+       {throw ExceptionObject(__FILE__, __LINE__, "itk::ERROR: Size: index out of range");}
+     SetElement(dim, value);
+     }
+   
+   const unsigned int __len__() const
+     {
+     return VDimension;
+     }
+   
+   const char * __str__() const
+     {
+     OStringStream msg;
+     msg << "<Size " << *this << ">";
+     return msg.str().c_str();
+     }  
+ //#endif
+ 
  };
  
  
***************
*** 219,224 ****
--- 247,253 ----
     extern template std::ostream & operator<<(std::ostream &os, const Size<5> &size);
  #endif
  
+ 
  } // end namespace itk
  
  #endif 
