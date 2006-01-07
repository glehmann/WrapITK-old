*** itk/Insight/Code/BasicFilters/itkTernaryFunctorImageFilter.h	2006-01-07 15:10:11.000000000 +0100
--- itk-mima2/Insight/Code/BasicFilters/itkTernaryFunctorImageFilter.h	2005-10-24 13:50:53.000000000 +0200
***************
*** 92,102 ****
     * appropriate). */
    void SetFunctor(const FunctorType& functor)
    {
!     if ( m_Functor != functor )
!       {
        m_Functor = functor;
        this->Modified();
!       }
    }
  
  protected:
--- 92,102 ----
     * appropriate). */
    void SetFunctor(const FunctorType& functor)
    {
! //    if ( m_Functor != functor )
! //      {
        m_Functor = functor;
        this->Modified();
! //      }
    }
  
  protected:
