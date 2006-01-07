*** itk/Insight/Code/BasicFilters/itkCropImageFilter.h	2006-01-07 15:09:43.000000000 +0100
--- itk-mima2/Insight/Code/BasicFilters/itkCropImageFilter.h	2005-10-24 13:50:59.000000000 +0200
***************
*** 78,83 ****
--- 78,111 ----
    itkSetMacro(LowerBoundaryCropSize, SizeType);
    itkGetMacro(LowerBoundaryCropSize, SizeType);
    
+   void SetUpperBoundaryCropSize(const unsigned long bound)
+     {
+     SizeType s;
+     s.Fill( bound );
+     this->SetUpperBoundaryCropSize( s );
+     }
+     
+   void SetLowerBoundaryCropSize(const unsigned long bound)
+     {
+     SizeType s;
+     s.Fill( bound );
+     this->SetLowerBoundaryCropSize( s );
+     }
+     
+   void SetBoundaryCropSize(const SizeType & s)
+     {
+     this->SetUpperBoundaryCropSize( s );
+     this->SetLowerBoundaryCropSize( s );
+     }
+ 
+   void SetBoundaryCropSize(const unsigned long bound)
+     {
+     SizeType s;
+     s.Fill( bound );
+     this->SetBoundaryCropSize( s );
+     }
+ 
+   
                   
  protected:
    CropImageFilter()
