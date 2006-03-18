*** /usr/include/InsightToolkit/Common/itkImageRegionIterator.txx.orig	2006-01-25 11:35:44.000000000 +0100
--- /usr/include/InsightToolkit/Common/itkImageRegionIterator.txx	2006-01-25 11:40:16.000000000 +0100
***************
*** 46,57 ****
  
  
   
! template< typename TImage >
! ImageRegionIterator<TImage>
! ::ImageRegionIterator( const ImageIteratorWithIndex<TImage> &it):
!   ImageRegionConstIterator<TImage>(it)
! { 
! }
  
   
  template< typename TImage >
--- 46,57 ----
  
  
   
! //template< typename TImage >
! //ImageRegionIterator<TImage>
! //::ImageRegionIterator( const ImageIteratorWithIndex<TImage> &it):
! //  ImageRegionConstIterator<TImage>(it)
! //{ 
! //}
  
   
  template< typename TImage >
