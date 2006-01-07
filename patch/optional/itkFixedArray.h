*** itk/Insight/Code/Common/itkFixedArray.h	2006-01-07 15:10:11.000000000 +0100
--- itk-mima2/Insight/Code/Common/itkFixedArray.h	2005-10-24 13:50:58.000000000 +0200
***************
*** 206,211 ****
--- 206,238 ----
    SizeType      Size() const;
    void Fill(const ValueType&);
      
+ //#ifdef SWIGPYTHON
+   const ValueType __getitem__(unsigned int dim) const 
+     {
+     if (dim >= VLength)
+       {throw ExceptionObject(__FILE__, __LINE__, "itk::ERROR: FixedArray: index out of range");}
+     return GetElement(dim);
+     }
+   void __setitem__(unsigned int dim, ValueType value)
+     {
+     if (dim >= VLength)
+       {throw ExceptionObject(__FILE__, __LINE__, "itk::ERROR: FixedArray: index out of range");}
+     SetElement(dim, value);
+     }
+   
+   const unsigned int __len__() const
+     {
+     return VLength;
+     }
+   
+   const char * __str__() const
+     {
+     OStringStream msg;
+     msg << "<FixedArray " << *this << ">";
+     return msg.str().c_str();
+     }  
+ //#endif
+ 
  private:
    /** Internal C array representation. */
    CArray  m_InternalArray;
