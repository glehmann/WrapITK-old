WRAP_CLASS("InterpolateImageFunction" POINTER)
  FOREACH(d ${WRAP_DIMS})
    COND_WRAP("${ITKM_IF${d}}${ITKM_D}"  "${ITKT_IF${d}},${ITKT_D}"  "F")
    COND_WRAP("${ITKM_IUS${d}}${ITKM_D}" "${ITKT_IUS${d}},${ITKT_D}" "US")
  ENDFOREACH(d)
END_WRAP_CLASS()

#------------------------------------------------------------------------------
# class
WRAP_CLASS("LinearInterpolateImageFunction" POINTER)
  FOREACH(d ${WRAP_DIMS})
    COND_WRAP("${ITKM_IF${d}}${ITKM_D}"  "${ITKT_IF${d}},${ITKT_D}"  "F")
    COND_WRAP("${ITKM_IUS${d}}${ITKM_D}" "${ITKT_IUS${d}},${ITKT_D}" "US")
  ENDFOREACH(d)
END_WRAP_CLASS()

#------------------------------------------------------------------------------
# class
WRAP_CLASS("NearestNeighborInterpolateImageFunction" POINTER)
  FOREACH(d ${WRAP_DIMS})
    COND_WRAP("${ITKM_IF${d}}${ITKM_D}"  "${ITKT_IF${d}},${ITKT_D}"  "F")
    COND_WRAP("${ITKM_IUS${d}}${ITKM_D}" "${ITKT_IUS${d}},${ITKT_D}" "US")
  ENDFOREACH(d)
END_WRAP_CLASS()

#------------------------------------------------------------------------------
# class
WRAP_CLASS("BSplineInterpolateImageFunction" POINTER)
  FOREACH(d ${WRAP_DIMS})
    COND_WRAP("${ITKM_IF${d}}${ITKM_D}"            "${ITKT_IF${d}},${ITKT_D}" "F")
    COND_WRAP("${ITKM_IUS${d}}${ITKM_D}"           "${ITKT_IUS${d}},${ITKT_D}" "US")
    COND_WRAP("${ITKM_IF${d}}${ITKM_D}${ITKM_F}"   "${ITKT_IF${d}},${ITKT_D},${ITKT_F}" "F")
    COND_WRAP("${ITKM_IUS${d}}${ITKM_D}${ITKM_US}" "${ITKT_IUS${d}},${ITKT_D},${ITKT_US}" "US")
  ENDFOREACH(d)
END_WRAP_CLASS()

#------------------------------------------------------------------------------
# class
WRAP_CLASS("BSplineResampleImageFunction" POINTER)
  FOREACH(d ${WRAP_DIMS})
    COND_WRAP("${ITKM_IF${d}}${ITKM_D}"  "${ITKT_IF${d}},${ITKT_D}" "F")
    COND_WRAP("${ITKM_IUS${d}}${ITKM_D}" "${ITKT_IUS${d}},${ITKT_D}" "US")
  ENDFOREACH(d)
END_WRAP_CLASS()
