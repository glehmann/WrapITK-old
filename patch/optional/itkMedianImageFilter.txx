*** itk/Insight/Code/BasicFilters/itkMedianImageFilter.txx	2006-01-07 15:10:19.000000000 +0100
--- itk-mima2/Insight/Code/BasicFilters/itkMedianImageFilter.txx	2005-10-31 23:01:07.000000000 +0100
***************
*** 152,157 ****
--- 152,170 ----
  }
  
  
+ template <class TInputImage, class TOutput>
+ void
+ MedianImageFilter<TInputImage, TOutput>
+ ::SetRadius(const unsigned long s)
+ {
+   InputSizeType k;
+   for (unsigned int i = 0; i< InputImageDimension; i++)
+     {
+     k[i] = s;
+     }
+   this->SetRadius(k);
+ }
+ 
  /**
   * Standard "PrintSelf" method
   */
