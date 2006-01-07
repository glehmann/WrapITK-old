*** itk/Insight/Code/Common/itkIndex.h	2006-01-07 15:10:12.000000000 +0100
--- itk-mima2/Insight/Code/Common/itkIndex.h	2005-10-24 13:50:58.000000000 +0200
***************
*** 239,245 ****
     * \warning No bound checking is performed
     * \sa GetIndex()
     * \sa SetElement() */
!   IndexValueType GetElement( unsigned long element )
      { return m_Index[ element ]; }
  
    /** Return a basis vector of the form [0, ..., 0, 1, 0, ... 0] where the "1"
--- 239,245 ----
     * \warning No bound checking is performed
     * \sa GetIndex()
     * \sa SetElement() */
!   IndexValueType GetElement( unsigned long element ) const
      { return m_Index[ element ]; }
  
    /** Return a basis vector of the form [0, ..., 0, 1, 0, ... 0] where the "1"
***************
*** 259,264 ****
--- 259,292 ----
     *    Index<3> index = {5, 2, 7}; */
    IndexValueType m_Index[VIndexDimension];
    
+ 
+ //#ifdef SWIGPYTHON
+   const IndexValueType __getitem__(unsigned int dim) const 
+     {
+     if (dim >= VIndexDimension)
+       {throw ExceptionObject(__FILE__, __LINE__, "itk::ERROR: Index: index out of range");}
+     return GetElement(dim);
+     }
+   void __setitem__(unsigned int dim, IndexValueType value)
+     {
+     if (dim >= VIndexDimension)
+       {throw ExceptionObject(__FILE__, __LINE__, "itk::ERROR: Index: index out of range");}
+     SetElement(dim, value);
+     }
+   
+   const unsigned int __len__() const
+     {
+     return VIndexDimension;
+     }
+   
+   const char * __str__() const
+     {
+     OStringStream msg;
+     msg << "<Index " << *this << ">";
+     return msg.str().c_str();
+     }  
+ //#endif
+ 
  };
  
  namespace Functor
