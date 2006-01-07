*** itk/Insight/Code/BasicFilters/itkVotingBinaryImageFilter.h	2006-01-07 15:09:44.000000000 +0100
--- itk-mima2/Insight/Code/BasicFilters/itkVotingBinaryImageFilter.h	2005-10-24 13:50:53.000000000 +0200
***************
*** 103,108 ****
--- 103,113 ----
     * \sa ImageToImageFilter::GenerateInputRequestedRegion() */
    virtual void GenerateInputRequestedRegion() throw(InvalidRequestedRegionError);
  
+   /** Overloads SetRadius to allow a single long integer argument
+    * that is used as the radius of all the dimensions of the
+    * Neighborhood (resulting in a "square" neighborhood). */
+   void SetRadius(const unsigned long);
+   
  protected:
    VotingBinaryImageFilter();
    virtual ~VotingBinaryImageFilter() {}
