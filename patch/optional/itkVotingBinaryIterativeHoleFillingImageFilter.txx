*** itk/Insight/Code/BasicFilters/itkVotingBinaryIterativeHoleFillingImageFilter.txx	2006-01-07 15:10:05.000000000 +0100
--- itk-mima2/Insight/Code/BasicFilters/itkVotingBinaryIterativeHoleFillingImageFilter.txx	2005-10-24 13:50:53.000000000 +0200
***************
*** 96,101 ****
--- 96,114 ----
  
  
  
+ template <class TInputImage >
+ void
+ VotingBinaryIterativeHoleFillingImageFilter<TInputImage>
+ ::SetRadius(const unsigned long s)
+ {
+   InputSizeType k;
+   for (unsigned int i = 0; i< ImageDimension; i++)
+     {
+     k[i] = s;
+     }
+   this->SetRadius(k);
+ }
+ 
  /**
   * Standard "PrintSelf" method
   */
