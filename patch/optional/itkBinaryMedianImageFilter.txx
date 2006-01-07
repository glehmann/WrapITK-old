*** itk/Insight/Code/BasicFilters/itkBinaryMedianImageFilter.txx	2006-01-07 15:09:43.000000000 +0100
--- itk-mima2/Insight/Code/BasicFilters/itkBinaryMedianImageFilter.txx	2005-10-24 13:50:53.000000000 +0200
***************
*** 164,169 ****
--- 164,182 ----
      }
  }
  
+ template <class TInputImage, class TOutput>
+ void
+ BinaryMedianImageFilter<TInputImage, TOutput>
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
