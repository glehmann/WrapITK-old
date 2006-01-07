*** itk/Insight/Code/BasicFilters/itkPadImageFilter.h	2006-01-07 15:10:04.000000000 +0100
--- itk-mima2/Insight/Code/BasicFilters/itkPadImageFilter.h	2005-10-24 13:50:58.000000000 +0200
***************
*** 18,23 ****
--- 18,24 ----
  #define __itkPadImageFilter_h
  
  #include "itkImageToImageFilter.h"
+ #include "itkSize.h"
  
  namespace itk
  {
***************
*** 78,83 ****
--- 79,122 ----
    itkSetVectorMacro(PadUpperBound, const unsigned long, ImageDimension);
    itkGetVectorMacro(PadLowerBound, const unsigned long, ImageDimension);
    itkGetVectorMacro(PadUpperBound, const unsigned long, ImageDimension);
+   
+   void SetPadLowerBound(const itk::Size<ImageDimension> & bound)
+     {
+     this->SetPadLowerBound( bound.m_Size );
+     }
+     
+   void SetPadUpperBound(const itk::Size<ImageDimension> & bound)
+     {
+     this->SetPadUpperBound( bound.m_Size );
+     }
+     
+   void SetPadBound(const itk::Size<ImageDimension> & bound)
+     {
+     this->SetPadLowerBound( bound );
+     this->SetPadUpperBound( bound );    
+     }
+ 
+   void SetPadLowerBound(const unsigned long bound)
+     {
+     itk::Size<ImageDimension> s;
+     s.Fill( bound );
+     this->SetPadLowerBound( s );
+     }
+     
+   void SetPadUpperBound(const unsigned long bound)
+     {
+     itk::Size<ImageDimension> s;
+     s.Fill( bound );
+     this->SetPadUpperBound( s );
+     }
+     
+   void SetPadBound(const unsigned long bound)
+     {
+     itk::Size<ImageDimension> s;
+     s.Fill( bound );
+     this->SetPadBound( s );
+     }
+ 
                   
    /** PadImageFilter produces an image which is a different resolution
     * than its input image.  As such, PadImageFilter needs to
