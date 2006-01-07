*** itk/Insight/Code/Common/itkNeighborhoodBinaryThresholdImageFunction.h	2006-01-07 15:09:45.000000000 +0100
--- itk-mima2/Insight/Code/Common/itkNeighborhoodBinaryThresholdImageFunction.h	2005-10-24 13:50:53.000000000 +0200
***************
*** 103,108 ****
--- 103,113 ----
        return this->EvaluateAtIndex( index ) ; 
      }
    
+   /** Overloads SetRadius to allow a single long integer argument
+    * that is used as the radius of all the dimensions of the
+    * Neighborhood (resulting in a "square" neighborhood). */
+   void SetRadius(const unsigned long);
+   
  protected:
    NeighborhoodBinaryThresholdImageFunction();
    ~NeighborhoodBinaryThresholdImageFunction(){};
