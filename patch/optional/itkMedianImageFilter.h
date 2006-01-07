*** itk/Insight/Code/BasicFilters/itkMedianImageFilter.h	2006-01-07 15:09:43.000000000 +0100
--- itk-mima2/Insight/Code/BasicFilters/itkMedianImageFilter.h	2005-10-24 13:50:53.000000000 +0200
***************
*** 91,96 ****
--- 91,101 ----
     * \sa ImageToImageFilter::GenerateInputRequestedRegion() */
    virtual void GenerateInputRequestedRegion() throw(InvalidRequestedRegionError);
  
+   /** Overloads SetRadius to allow a single long integer argument
+    * that is used as the radius of all the dimensions of the
+    * Neighborhood (resulting in a "square" neighborhood). */
+   void SetRadius(const unsigned long);
+   
  protected:
    MedianImageFilter();
    virtual ~MedianImageFilter() {}
