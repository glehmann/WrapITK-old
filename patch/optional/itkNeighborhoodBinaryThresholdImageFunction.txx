*** itk/Insight/Code/Common/itkNeighborhoodBinaryThresholdImageFunction.txx	2006-01-07 15:09:45.000000000 +0100
--- itk-mima2/Insight/Code/Common/itkNeighborhoodBinaryThresholdImageFunction.txx	2005-10-24 13:50:53.000000000 +0200
***************
*** 95,100 ****
--- 95,113 ----
  }
  
  
+ template <class TInputImage, class TCoordRep>
+ void
+ NeighborhoodBinaryThresholdImageFunction<TInputImage,TCoordRep>
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
  } // namespace itk
  
  #endif
