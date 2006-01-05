WRAP_CLASS("ImageSource" POINTER)
  COND_WRAP("${ITKM_ID2}"  "${ITKT_ID2}"  "D")
  COND_WRAP("${ITKM_IF2}"  "${ITKT_IF2}"  "F")
  COND_WRAP("${ITKM_IUL2}" "${ITKT_IUL2}" "") # needed for watershed
  COND_WRAP("${ITKM_IUS2}" "${ITKT_IUS2}" "US")
  COND_WRAP("${ITKM_IUC2}" "${ITKT_IUC2}" "") # needed to save in 8 bits
  COND_WRAP("${ITKM_ISL2}" "${ITKT_ISL2}" "SL")
  COND_WRAP("${ITKM_ISS2}" "${ITKT_ISS2}" "SS")
  COND_WRAP("${ITKM_ISC2}" "${ITKT_ISC2}" "SC")
  COND_WRAP("${ITKM_IVD22}"  "${ITKT_IVD22}"  "VD")
  COND_WRAP("${ITKM_IVF22}"  "${ITKT_IVF22}"  "VF")
  COND_WRAP("${ITKM_ICVD22}"  "${ITKT_ICVD22}"  "CVD")
  COND_WRAP("${ITKM_ICVF22}"  "${ITKT_ICVF22}"  "CVF")
  
  COND_WRAP("${ITKM_ID3}"  "${ITKT_ID3}"  "D")
  COND_WRAP("${ITKM_IF3}"  "${ITKT_IF3}"  "F")
  COND_WRAP("${ITKM_IUL3}" "${ITKT_IUL3}" "") # needed for watershed
  COND_WRAP("${ITKM_IUS3}" "${ITKT_IUS3}" "US")
  COND_WRAP("${ITKM_IUC3}" "${ITKT_IUC3}" "") # needed to save in 8 bits
  COND_WRAP("${ITKM_ISL3}" "${ITKT_ISL3}" "SL")
  COND_WRAP("${ITKM_ISS3}" "${ITKT_ISS3}" "SS")
  COND_WRAP("${ITKM_ISC3}" "${ITKT_ISC3}" "SC")
  COND_WRAP("${ITKM_IVD33}"  "${ITKT_IVD33}"  "VD")
  COND_WRAP("${ITKM_IVF33}"  "${ITKT_IVF33}"  "VF")
  COND_WRAP("${ITKM_ICVD33}"  "${ITKT_ICVD33}"  "CVD")
  COND_WRAP("${ITKM_ICVF33}"  "${ITKT_ICVF33}"  "CVF")
END_WRAP_CLASS()
