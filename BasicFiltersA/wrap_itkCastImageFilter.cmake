WRAP_CLASS("itk::CastImageFilter" POINTER_WITH_SUPERCLASS)
  FOREACH(d ${WRAP_ITK_DIMS})
    WRAP_TYPES("${ITKM_ID${d}}${ITKM_ID${d}}"  "${ITKT_ID${d}},${ITKT_ID${d}}"  "D")
    WRAP_TYPES("${ITKM_ID${d}}${ITKM_IF${d}}"  "${ITKT_ID${d}},${ITKT_IF${d}}"  "D;F")
    WRAP_TYPES("${ITKM_ID${d}}${ITKM_IUL${d}}" "${ITKT_ID${d}},${ITKT_IUL${d}}" "D;UL")
    WRAP_TYPES("${ITKM_ID${d}}${ITKM_IUS${d}}" "${ITKT_ID${d}},${ITKT_IUS${d}}" "D;US")
    WRAP_TYPES("${ITKM_ID${d}}${ITKM_IUC${d}}" "${ITKT_ID${d}},${ITKT_IUC${d}}" "D") # needed to save in 8 bits
    WRAP_TYPES("${ITKM_ID${d}}${ITKM_ISL${d}}" "${ITKT_ID${d}},${ITKT_ISL${d}}" "D;SL")
    WRAP_TYPES("${ITKM_ID${d}}${ITKM_ISS${d}}" "${ITKT_ID${d}},${ITKT_ISS${d}}" "D;SS")
    WRAP_TYPES("${ITKM_ID${d}}${ITKM_ISC${d}}" "${ITKT_ID${d}},${ITKT_ISC${d}}" "D;SC")
    
    WRAP_TYPES("${ITKM_IF${d}}${ITKM_ID${d}}"  "${ITKT_IF${d}},${ITKT_ID${d}}"  "F;D")
    WRAP_TYPES("${ITKM_IF${d}}${ITKM_IF${d}}"  "${ITKT_IF${d}},${ITKT_IF${d}}"  "F")
    WRAP_TYPES("${ITKM_IF${d}}${ITKM_IUL${d}}" "${ITKT_IF${d}},${ITKT_IUL${d}}" "F;UL")
    WRAP_TYPES("${ITKM_IF${d}}${ITKM_IUS${d}}" "${ITKT_IF${d}},${ITKT_IUS${d}}" "F;US")
    WRAP_TYPES("${ITKM_IF${d}}${ITKM_IUC${d}}" "${ITKT_IF${d}},${ITKT_IUC${d}}" "F") # needed to save in 8 bits
    WRAP_TYPES("${ITKM_IF${d}}${ITKM_ISL${d}}" "${ITKT_IF${d}},${ITKT_ISL${d}}" "F;SL")
    WRAP_TYPES("${ITKM_IF${d}}${ITKM_ISS${d}}" "${ITKT_IF${d}},${ITKT_ISS${d}}" "F;SS")
    WRAP_TYPES("${ITKM_IF${d}}${ITKM_ISC${d}}" "${ITKT_IF${d}},${ITKT_ISC${d}}" "F;SC")
    
    WRAP_TYPES("${ITKM_IUL${d}}${ITKM_ID${d}}"  "${ITKT_IUL${d}},${ITKT_ID${d}}"  "UL;D")
    WRAP_TYPES("${ITKM_IUL${d}}${ITKM_IF${d}}"  "${ITKT_IUL${d}},${ITKT_IF${d}}"  "UL;F")
    WRAP_TYPES("${ITKM_IUL${d}}${ITKM_IUL${d}}" "${ITKT_IUL${d}},${ITKT_IUL${d}}" "UL")
    WRAP_TYPES("${ITKM_IUL${d}}${ITKM_IUS${d}}" "${ITKT_IUL${d}},${ITKT_IUS${d}}" "UL;US")
    WRAP_TYPES("${ITKM_IUL${d}}${ITKM_IUC${d}}" "${ITKT_IUL${d}},${ITKT_IUC${d}}" "UL") # needed to save in 8 bits
    WRAP_TYPES("${ITKM_IUL${d}}${ITKM_ISL${d}}" "${ITKT_IUL${d}},${ITKT_ISL${d}}" "UL;SL")
    WRAP_TYPES("${ITKM_IUL${d}}${ITKM_ISS${d}}" "${ITKT_IUL${d}},${ITKT_ISS${d}}" "UL;SS")
    WRAP_TYPES("${ITKM_IUL${d}}${ITKM_ISC${d}}" "${ITKT_IUL${d}},${ITKT_ISC${d}}" "UL;SC")
    
    WRAP_TYPES("${ITKM_IUS${d}}${ITKM_ID${d}}"  "${ITKT_IUS${d}},${ITKT_ID${d}}"  "US;D")
    WRAP_TYPES("${ITKM_IUS${d}}${ITKM_IF${d}}"  "${ITKT_IUS${d}},${ITKT_IF${d}}"  "US;F")
    WRAP_TYPES("${ITKM_IUS${d}}${ITKM_IUL${d}}" "${ITKT_IUS${d}},${ITKT_IUL${d}}" "US;UL")
    WRAP_TYPES("${ITKM_IUS${d}}${ITKM_IUS${d}}" "${ITKT_IUS${d}},${ITKT_IUS${d}}" "US")
    WRAP_TYPES("${ITKM_IUS${d}}${ITKM_IUC${d}}" "${ITKT_IUS${d}},${ITKT_IUC${d}}" "US") # needed to save in 8 bits
    WRAP_TYPES("${ITKM_IUS${d}}${ITKM_ISL${d}}" "${ITKT_IUS${d}},${ITKT_ISL${d}}" "US;SL")
    WRAP_TYPES("${ITKM_IUS${d}}${ITKM_ISS${d}}" "${ITKT_IUS${d}},${ITKT_ISS${d}}" "US;SS")
    WRAP_TYPES("${ITKM_IUS${d}}${ITKM_ISC${d}}" "${ITKT_IUS${d}},${ITKT_ISC${d}}" "US;SC")
    
    WRAP_TYPES("${ITKM_IUC${d}}${ITKM_ID${d}}"  "${ITKT_IUC${d}},${ITKT_ID${d}}"  "UC;D")
    WRAP_TYPES("${ITKM_IUC${d}}${ITKM_IF${d}}"  "${ITKT_IUC${d}},${ITKT_IF${d}}"  "UC;F")
    WRAP_TYPES("${ITKM_IUC${d}}${ITKM_IUL${d}}" "${ITKT_IUC${d}},${ITKT_IUL${d}}" "UC;UL")
    WRAP_TYPES("${ITKM_IUC${d}}${ITKM_IUS${d}}" "${ITKT_IUC${d}},${ITKT_IUS${d}}" "UC;US")
    WRAP_TYPES("${ITKM_IUC${d}}${ITKM_IUC${d}}" "${ITKT_IUC${d}},${ITKT_IUC${d}}" "UC")
    WRAP_TYPES("${ITKM_IUC${d}}${ITKM_ISL${d}}" "${ITKT_IUC${d}},${ITKT_ISL${d}}" "UC;SL")
    WRAP_TYPES("${ITKM_IUC${d}}${ITKM_ISS${d}}" "${ITKT_IUC${d}},${ITKT_ISS${d}}" "UC;SS")
    WRAP_TYPES("${ITKM_IUC${d}}${ITKM_ISC${d}}" "${ITKT_IUC${d}},${ITKT_ISC${d}}" "UC;SC")
    
    WRAP_TYPES("${ITKM_ISL${d}}${ITKM_ID${d}}"  "${ITKT_ISL${d}},${ITKT_ID${d}}"  "SL;D")
    WRAP_TYPES("${ITKM_ISL${d}}${ITKM_IF${d}}"  "${ITKT_ISL${d}},${ITKT_IF${d}}"  "SL;F")
    WRAP_TYPES("${ITKM_ISL${d}}${ITKM_IUL${d}}" "${ITKT_ISL${d}},${ITKT_IUL${d}}" "SL;UL")
    WRAP_TYPES("${ITKM_ISL${d}}${ITKM_IUS${d}}" "${ITKT_ISL${d}},${ITKT_IUS${d}}" "SL;US")
    WRAP_TYPES("${ITKM_ISL${d}}${ITKM_IUC${d}}" "${ITKT_ISL${d}},${ITKT_IUC${d}}" "SL") # needed to save in 8 bits
    WRAP_TYPES("${ITKM_ISL${d}}${ITKM_ISL${d}}" "${ITKT_ISL${d}},${ITKT_ISL${d}}" "SL")
    WRAP_TYPES("${ITKM_ISL${d}}${ITKM_ISS${d}}" "${ITKT_ISL${d}},${ITKT_ISS${d}}" "SL;SS")
    WRAP_TYPES("${ITKM_ISL${d}}${ITKM_ISC${d}}" "${ITKT_ISL${d}},${ITKT_ISC${d}}" "SL;SC")
    
    WRAP_TYPES("${ITKM_ISS${d}}${ITKM_ID${d}}"  "${ITKT_ISS${d}},${ITKT_ID${d}}"  "SS;D")
    WRAP_TYPES("${ITKM_ISS${d}}${ITKM_IF${d}}"  "${ITKT_ISS${d}},${ITKT_IF${d}}"  "SS;F")
    WRAP_TYPES("${ITKM_ISS${d}}${ITKM_IUL${d}}" "${ITKT_ISS${d}},${ITKT_IUL${d}}" "SS;UL")
    WRAP_TYPES("${ITKM_ISS${d}}${ITKM_IUS${d}}" "${ITKT_ISS${d}},${ITKT_IUS${d}}" "SS;US")
    WRAP_TYPES("${ITKM_ISS${d}}${ITKM_IUC${d}}" "${ITKT_ISS${d}},${ITKT_IUC${d}}" "SS") # needed to save in 8 bits
    WRAP_TYPES("${ITKM_ISS${d}}${ITKM_ISL${d}}" "${ITKT_ISS${d}},${ITKT_ISL${d}}" "SS;SL")
    WRAP_TYPES("${ITKM_ISS${d}}${ITKM_ISS${d}}" "${ITKT_ISS${d}},${ITKT_ISS${d}}" "SS")
    WRAP_TYPES("${ITKM_ISS${d}}${ITKM_ISC${d}}" "${ITKT_ISS${d}},${ITKT_ISC${d}}" "SS;SC")
    
    WRAP_TYPES("${ITKM_ISC${d}}${ITKM_ID${d}}"  "${ITKT_ISC${d}},${ITKT_ID${d}}"  "SC;D")
    WRAP_TYPES("${ITKM_ISC${d}}${ITKM_IF${d}}"  "${ITKT_ISC${d}},${ITKT_IF${d}}"  "SC;F")
    WRAP_TYPES("${ITKM_ISC${d}}${ITKM_IUL${d}}" "${ITKT_ISC${d}},${ITKT_IUL${d}}" "SC;UL")
    WRAP_TYPES("${ITKM_ISC${d}}${ITKM_IUS${d}}" "${ITKT_ISC${d}},${ITKT_IUS${d}}" "SC;US")
    WRAP_TYPES("${ITKM_ISC${d}}${ITKM_IUC${d}}" "${ITKT_ISC${d}},${ITKT_IUC${d}}" "SC") # needed to save in 8 bits
    WRAP_TYPES("${ITKM_ISC${d}}${ITKM_ISL${d}}" "${ITKT_ISC${d}},${ITKT_ISL${d}}" "SC;SL")
    WRAP_TYPES("${ITKM_ISC${d}}${ITKM_ISS${d}}" "${ITKT_ISC${d}},${ITKT_ISS${d}}" "SC;SS")
    WRAP_TYPES("${ITKM_ISC${d}}${ITKM_ISC${d}}" "${ITKT_ISC${d}},${ITKT_ISC${d}}" "SC")
    
    # vector types
    WRAP_TYPES("${ITKM_IVD${d}${d}}${ITKM_IVD${d}${d}}"  "${ITKT_IVD${d}${d}},${ITKT_IVD${d}${d}}"  "VD")
    WRAP_TYPES("${ITKM_IVF${d}${d}}${ITKM_IVF${d}${d}}"  "${ITKT_IVF${d}${d}},${ITKT_IVF${d}${d}}"  "VF")
    WRAP_TYPES("${ITKM_ICVD${d}${d}}${ITKM_ICVD${d}${d}}"  "${ITKT_ICVD${d}${d}},${ITKT_ICVD${d}${d}}"  "CVD")
    WRAP_TYPES("${ITKM_ICVF${d}${d}}${ITKM_ICVF${d}${d}}"  "${ITKT_ICVF${d}${d}},${ITKT_ICVF${d}${d}}"  "CVF")
  ENDFOREACH(d)
  
END_WRAP_CLASS()

