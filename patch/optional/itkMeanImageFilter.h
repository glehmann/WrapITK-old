*** itk/Insight/Code/BasicFilters/itkMeanImageFilter.txx	2006-01-07 15:09:43.000000000 +0100
--- itk-mima2/Insight/Code/BasicFilters/itkMeanImageFilter.txx	2005-10-24 13:50:53.000000000 +0200
***************
*** 146,151 ****
--- 146,164 ----
      }
  }
  
+ template< class TInputImage, class TOutputImage>
+ void
+ MeanImageFilter< TInputImage, TOutputImage>
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
