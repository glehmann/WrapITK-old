*** /usr/include/InsightToolkit/Common/itkImageRegionIterator.h.orig	2006-01-25 11:35:37.000000000 +0100
--- /usr/include/InsightToolkit/Common/itkImageRegionIterator.h	2006-01-25 11:36:25.000000000 +0100
***************
*** 106,112 ****
     * provide overloaded APIs that return different types of Iterators, itk
     * returns ImageIterators and uses constructors to cast from an
     * ImageIterator to a ImageRegionIterator. */
!   ImageRegionIterator( const ImageIteratorWithIndex<TImage> &it);
    
    /** Set the pixel value */
    void Set( const PixelType & value) const  
--- 106,112 ----
     * provide overloaded APIs that return different types of Iterators, itk
     * returns ImageIterators and uses constructors to cast from an
     * ImageIterator to a ImageRegionIterator. */
! //  ImageRegionIterator( const ImageIteratorWithIndex<TImage> &it);
    
    /** Set the pixel value */
    void Set( const PixelType & value) const  
