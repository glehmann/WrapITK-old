*** /usr/include/InsightToolkit/Common/itkImageRegionConstIterator.h.orig	2006-01-25 13:52:39.000000000 +0100
--- /usr/include/InsightToolkit/Common/itkImageRegionConstIterator.h	2006-01-25 12:33:28.000000000 +0100
***************
*** 176,182 ****
     * provide overloaded APIs that return different types of Iterators, itk
     * returns ImageIterators and uses constructors to cast from an
     * ImageIterator to a ImageRegionConstIterator. */
!   ImageRegionConstIterator( const ImageIterator<TImage> &it)
    {
      this->ImageIterator<TImage>::operator=(it);
      IndexType ind = this->GetIndex();
--- 176,182 ----
     * provide overloaded APIs that return different types of Iterators, itk
     * returns ImageIterators and uses constructors to cast from an
     * ImageIterator to a ImageRegionConstIterator. */
! /*  ImageRegionConstIterator( const ImageIterator<TImage> &it)
    {
      this->ImageIterator<TImage>::operator=(it);
      IndexType ind = this->GetIndex();
***************
*** 185,191 ****
      m_SpanBeginOffset = m_SpanEndOffset
        - static_cast<long>(this->m_Region.GetSize()[0]);
    }
! 
    /** Constructor that can be used to cast from an ImageConstIterator to an
     * ImageRegionConstIterator. Many routines return an ImageIterator but for a
     * particular task, you may want an ImageRegionConstIterator.  Rather than
--- 185,191 ----
      m_SpanBeginOffset = m_SpanEndOffset
        - static_cast<long>(this->m_Region.GetSize()[0]);
    }
! */
    /** Constructor that can be used to cast from an ImageConstIterator to an
     * ImageRegionConstIterator. Many routines return an ImageIterator but for a
     * particular task, you may want an ImageRegionConstIterator.  Rather than
