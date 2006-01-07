*** itk/Insight/Code/BasicFilters/itkVotingBinaryIterativeHoleFillingImageFilter.h	2006-01-07 15:17:09.000000000 +0100
--- itk-mima2/Insight/Code/BasicFilters/itkVotingBinaryIterativeHoleFillingImageFilter.h	2005-10-24 13:50:53.000000000 +0200
***************
*** 54,59 ****
--- 54,62 ----
      public ImageToImageFilter< TImage, TImage >
  {
  public:
+   /** Extract dimension from input and output image. */
+   itkStaticConstMacro(ImageDimension, unsigned int,
+                       TImage::ImageDimension);
  
    /** Convenient typedefs for simplifying declarations. */
    typedef TImage InputImageType;
***************
*** 130,135 ****
--- 133,143 ----
    /** Returns the number of pixels that changed when the filter was executed. */
    itkGetConstReferenceMacro( NumberOfPixelsChanged, unsigned int );
  
+   /** Overloads SetRadius to allow a single long integer argument
+    * that is used as the radius of all the dimensions of the
+    * Neighborhood (resulting in a "square" neighborhood). */
+   void SetRadius(const unsigned long);
+   
  protected:
    VotingBinaryIterativeHoleFillingImageFilter();
    virtual ~VotingBinaryIterativeHoleFillingImageFilter() {}
