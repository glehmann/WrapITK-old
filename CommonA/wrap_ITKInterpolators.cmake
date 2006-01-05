WRAP_CLASS("InterpolateImageFunction" POINTER)
  COND_WRAP("${ITKM_IF2}${ITKM_D}"  "${ITKT_IF2},${ITKT_D}"  "F")
  COND_WRAP("${ITKM_IF3}${ITKM_D}"  "${ITKT_IF3},${ITKT_D}"  "F")
  COND_WRAP("${ITKM_IUS2}${ITKM_D}" "${ITKT_IUS2},${ITKT_D}" "US")
  COND_WRAP("${ITKM_IUS3}${ITKM_D}" "${ITKT_IUS3},${ITKT_D}" "US")
END_WRAP_CLASS()

#------------------------------------------------------------------------------
# class
WRAP_CLASS("LinearInterpolateImageFunction" POINTER)
  COND_WRAP("${ITKM_IF2}${ITKM_D}"  "${ITKT_IF2},${ITKT_D}"  "F")
  COND_WRAP("${ITKM_IF3}${ITKM_D}"  "${ITKT_IF3},${ITKT_D}"  "F")
  COND_WRAP("${ITKM_IUS2}${ITKM_D}" "${ITKT_IUS2},${ITKT_D}" "US")
  COND_WRAP("${ITKM_IUS3}${ITKM_D}" "${ITKT_IUS3},${ITKT_D}" "US")
END_WRAP_CLASS()

#------------------------------------------------------------------------------
# class
WRAP_CLASS("NearestNeighborInterpolateImageFunction" POINTER)
  COND_WRAP("${ITKM_IF2}${ITKM_D}"  "${ITKT_IF2},${ITKT_D}"  "F")
  COND_WRAP("${ITKM_IF3}${ITKM_D}"  "${ITKT_IF3},${ITKT_D}"  "F")
  COND_WRAP("${ITKM_IUS2}${ITKM_D}" "${ITKT_IUS2},${ITKT_D}" "US")
  COND_WRAP("${ITKM_IUS3}${ITKM_D}" "${ITKT_IUS3},${ITKT_D}" "US")
END_WRAP_CLASS()

#------------------------------------------------------------------------------
# class
WRAP_CLASS("BSplineInterpolateImageFunction" POINTER)
  COND_WRAP("${ITKM_IF2}${ITKM_D}"            "${ITKT_IF2},${ITKT_D}" "F")
  COND_WRAP("${ITKM_IF3}${ITKM_D}"            "${ITKT_IF3},${ITKT_D}" "F")
  COND_WRAP("${ITKM_IUS2}${ITKM_D}"           "${ITKT_IUS2},${ITKT_D}" "US")
  COND_WRAP("${ITKM_IUS3}${ITKM_D}"           "${ITKT_IUS3},${ITKT_D}" "US")
  COND_WRAP("${ITKM_IF2}${ITKM_D}${ITKM_F}"   "${ITKT_IF2},${ITKT_D},${ITKT_F}" "F")
  COND_WRAP("${ITKM_IF3}${ITKM_D}${ITKM_F}"   "${ITKT_IF3},${ITKT_D},${ITKT_F}" "F")
  COND_WRAP("${ITKM_IUS2}${ITKM_D}${ITKM_US}" "${ITKT_IUS2},${ITKT_D},${ITKT_US}" "US")
  COND_WRAP("${ITKM_IUS3}${ITKM_D}${ITKM_US}" "${ITKT_IUS3},${ITKT_D},${ITKT_US}" "US")
END_WRAP_CLASS()

#------------------------------------------------------------------------------
# class
WRAP_CLASS("BSplineResampleImageFunction" POINTER)
  COND_WRAP("${ITKM_IF2}${ITKM_D}"  "${ITKT_IF2},${ITKT_D}" "F")
  COND_WRAP("${ITKM_IF3}${ITKM_D}"  "${ITKT_IF3},${ITKT_D}" "F")
  COND_WRAP("${ITKM_IUS2}${ITKM_D}" "${ITKT_IUS2},${ITKT_D}" "US")
  COND_WRAP("${ITKM_IUS3}${ITKM_D}" "${ITKT_IUS3},${ITKT_D}" "US")
END_WRAP_CLASS()
