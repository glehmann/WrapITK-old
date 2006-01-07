*** itk/Insight/Code/BasicFilters/itkRescaleIntensityImageFilter.txx	2006-01-07 15:10:07.000000000 +0100
--- itk-mima2/Insight/Code/BasicFilters/itkRescaleIntensityImageFilter.txx	2005-10-24 13:50:53.000000000 +0200
***************
*** 33,43 ****
  RescaleIntensityImageFilter<TInputImage, TOutputImage>
  ::RescaleIntensityImageFilter()
  {
!   m_OutputMaximum   = NumericTraits<OutputPixelType>::Zero;
!   m_OutputMinimum   = NumericTraits<OutputPixelType>::max();
  
!   m_InputMaximum   = NumericTraits<InputPixelType>::Zero;
!   m_InputMinimum   = NumericTraits<InputPixelType>::max();
    
    m_Scale = 1.0;
    m_Shift = 0.0;
--- 33,43 ----
  RescaleIntensityImageFilter<TInputImage, TOutputImage>
  ::RescaleIntensityImageFilter()
  {
!   m_OutputMaximum   = NumericTraits<OutputPixelType>::max();
!   m_OutputMinimum   = NumericTraits<OutputPixelType>::NonpositiveMin();
  
!   m_InputMaximum   = NumericTraits<InputPixelType>::max();
!   m_InputMinimum   = NumericTraits<InputPixelType>::NonpositiveMin();
    
    m_Scale = 1.0;
    m_Shift = 0.0;
