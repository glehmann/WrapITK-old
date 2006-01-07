*** itk/Insight/Code/BasicFilters/itkSimpleContourExtractorImageFilter.txx	2006-01-07 15:09:44.000000000 +0100
--- itk-mima2/Insight/Code/BasicFilters/itkSimpleContourExtractorImageFilter.txx	2005-10-24 13:50:53.000000000 +0200
***************
*** 178,183 ****
--- 178,196 ----
      }
  }
    
+ template <class TInputImage, class TOutput>
+ void
+ SimpleContourExtractorImageFilter<TInputImage, TOutput>
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
