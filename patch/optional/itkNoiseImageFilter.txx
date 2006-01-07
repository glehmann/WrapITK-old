*** itk/Insight/Code/BasicFilters/itkNoiseImageFilter.txx	2006-01-07 15:09:43.000000000 +0100
--- itk-mima2/Insight/Code/BasicFilters/itkNoiseImageFilter.txx	2005-10-24 13:50:53.000000000 +0200
***************
*** 156,161 ****
--- 156,174 ----
      }
  }
  
+ template <class TInputImage, class TOutput>
+ void
+ NoiseImageFilter<TInputImage, TOutput>
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
