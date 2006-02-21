WRAP_CLASS("itk::ImageToImageFilter" POINTER)
  FOREACH(d ${WRAP_ITK_DIMS})
    COND_WRAP("${ITKM_ID${d}}${ITKM_ID${d}}"  "${ITKT_ID${d}},${ITKT_ID${d}}"  "D")
    COND_WRAP("${ITKM_ID${d}}${ITKM_IF${d}}"  "${ITKT_ID${d}},${ITKT_IF${d}}"  "D;F")
    COND_WRAP("${ITKM_ID${d}}${ITKM_IUL${d}}" "${ITKT_ID${d}},${ITKT_IUL${d}}" "D") # needed for watershed
    COND_WRAP("${ITKM_ID${d}}${ITKM_IUS${d}}" "${ITKT_ID${d}},${ITKT_IUS${d}}" "D;US")
    COND_WRAP("${ITKM_ID${d}}${ITKM_IUC${d}}" "${ITKT_ID${d}},${ITKT_IUC${d}}" "D") # needed to save in 8 bits
    COND_WRAP("${ITKM_ID${d}}${ITKM_ISL${d}}" "${ITKT_ID${d}},${ITKT_ISL${d}}" "D;SL")
    COND_WRAP("${ITKM_ID${d}}${ITKM_ISS${d}}" "${ITKT_ID${d}},${ITKT_ISS${d}}" "D;SS")
    COND_WRAP("${ITKM_ID${d}}${ITKM_ISC${d}}" "${ITKT_ID${d}},${ITKT_ISC${d}}" "D;SC")
    
    COND_WRAP("${ITKM_IF${d}}${ITKM_ID${d}}"  "${ITKT_IF${d}},${ITKT_ID${d}}"  "F;D")
    COND_WRAP("${ITKM_IF${d}}${ITKM_IF${d}}"  "${ITKT_IF${d}},${ITKT_IF${d}}"  "F")
    COND_WRAP("${ITKM_IF${d}}${ITKM_IUL${d}}" "${ITKT_IF${d}},${ITKT_IUL${d}}" "F") # needed for watershed
    COND_WRAP("${ITKM_IF${d}}${ITKM_IUS${d}}" "${ITKT_IF${d}},${ITKT_IUS${d}}" "F;US")
    COND_WRAP("${ITKM_IF${d}}${ITKM_IUC${d}}" "${ITKT_IF${d}},${ITKT_IUC${d}}" "F") # needed to save in 8 bits
    COND_WRAP("${ITKM_IF${d}}${ITKM_ISL${d}}" "${ITKT_IF${d}},${ITKT_ISL${d}}" "F;SL")
    COND_WRAP("${ITKM_IF${d}}${ITKM_ISS${d}}" "${ITKT_IF${d}},${ITKT_ISS${d}}" "F;SS")
    COND_WRAP("${ITKM_IF${d}}${ITKM_ISC${d}}" "${ITKT_IF${d}},${ITKT_ISC${d}}" "F;SC")
    
    COND_WRAP("${ITKM_IUL${d}}${ITKM_ID${d}}"  "${ITKT_IUL${d}},${ITKT_ID${d}}"  "UL;D")
    COND_WRAP("${ITKM_IUL${d}}${ITKM_IF${d}}"  "${ITKT_IUL${d}},${ITKT_IF${d}}"  "UL;F")
    COND_WRAP("${ITKM_IUL${d}}${ITKM_IUL${d}}" "${ITKT_IUL${d}},${ITKT_IUL${d}}" "UL")
    COND_WRAP("${ITKM_IUL${d}}${ITKM_IUS${d}}" "${ITKT_IUL${d}},${ITKT_IUS${d}}" "US") # needed for relabel component
    COND_WRAP("${ITKM_IUL${d}}${ITKM_IUC${d}}" "${ITKT_IUL${d}},${ITKT_IUC${d}}" "") # needed to save in 8 bits and for relabel component
    COND_WRAP("${ITKM_IUL${d}}${ITKM_ISL${d}}" "${ITKT_IUL${d}},${ITKT_ISL${d}}" "SL") # needed for relabel component
    COND_WRAP("${ITKM_IUL${d}}${ITKM_ISS${d}}" "${ITKT_IUL${d}},${ITKT_ISS${d}}" "SS") # needed for relabel component
    COND_WRAP("${ITKM_IUL${d}}${ITKM_ISC${d}}" "${ITKT_IUL${d}},${ITKT_ISC${d}}" "SC") # needed for relabel component
    
    COND_WRAP("${ITKM_IUS${d}}${ITKM_ID${d}}"  "${ITKT_IUS${d}},${ITKT_ID${d}}"  "US;D")
    COND_WRAP("${ITKM_IUS${d}}${ITKM_IF${d}}"  "${ITKT_IUS${d}},${ITKT_IF${d}}"  "US;F")
    COND_WRAP("${ITKM_IUS${d}}${ITKM_IUL${d}}" "${ITKT_IUS${d}},${ITKT_IUL${d}}" "US") # needed for watershed
    COND_WRAP("${ITKM_IUS${d}}${ITKM_IUS${d}}" "${ITKT_IUS${d}},${ITKT_IUS${d}}" "US")
    COND_WRAP("${ITKM_IUS${d}}${ITKM_IUC${d}}" "${ITKT_IUS${d}},${ITKT_IUC${d}}" "US") # needed to save in 8 bits
    COND_WRAP("${ITKM_IUS${d}}${ITKM_ISL${d}}" "${ITKT_IUS${d}},${ITKT_ISL${d}}" "US;SL")
    COND_WRAP("${ITKM_IUS${d}}${ITKM_ISS${d}}" "${ITKT_IUS${d}},${ITKT_ISS${d}}" "US;SS")
    COND_WRAP("${ITKM_IUS${d}}${ITKM_ISC${d}}" "${ITKT_IUS${d}},${ITKT_ISC${d}}" "US;SC")
    
    COND_WRAP("${ITKM_IUC${d}}${ITKM_ID${d}}"  "${ITKT_IUC${d}},${ITKT_ID${d}}"  "UC;D")
    COND_WRAP("${ITKM_IUC${d}}${ITKM_IF${d}}"  "${ITKT_IUC${d}},${ITKT_IF${d}}"  "UC;F")
    COND_WRAP("${ITKM_IUC${d}}${ITKM_IUL${d}}" "${ITKT_IUC${d}},${ITKT_IUL${d}}" "UC") # needed for watershed
    COND_WRAP("${ITKM_IUC${d}}${ITKM_IUS${d}}" "${ITKT_IUC${d}},${ITKT_IUS${d}}" "UC;US")
    COND_WRAP("${ITKM_IUC${d}}${ITKM_IUC${d}}" "${ITKT_IUC${d}},${ITKT_IUC${d}}" "UC")
    COND_WRAP("${ITKM_IUC${d}}${ITKM_ISL${d}}" "${ITKT_IUC${d}},${ITKT_ISL${d}}" "UC;SL")
    COND_WRAP("${ITKM_IUC${d}}${ITKM_ISS${d}}" "${ITKT_IUC${d}},${ITKT_ISS${d}}" "UC;SS")
    COND_WRAP("${ITKM_IUC${d}}${ITKM_ISC${d}}" "${ITKT_IUC${d}},${ITKT_ISC${d}}" "UC;SC")
    
    COND_WRAP("${ITKM_ISL${d}}${ITKM_ID${d}}"  "${ITKT_ISL${d}},${ITKT_ID${d}}"  "SL;D")
    COND_WRAP("${ITKM_ISL${d}}${ITKM_IF${d}}"  "${ITKT_ISL${d}},${ITKT_IF${d}}"  "SL;F")
    COND_WRAP("${ITKM_ISL${d}}${ITKM_IUL${d}}" "${ITKT_ISL${d}},${ITKT_IUL${d}}" "SL") # needed for watershed
    COND_WRAP("${ITKM_ISL${d}}${ITKM_IUS${d}}" "${ITKT_ISL${d}},${ITKT_IUS${d}}" "SL;US")
    COND_WRAP("${ITKM_ISL${d}}${ITKM_IUC${d}}" "${ITKT_ISL${d}},${ITKT_IUC${d}}" "SL") # needed to save in 8 bits
    COND_WRAP("${ITKM_ISL${d}}${ITKM_ISL${d}}" "${ITKT_ISL${d}},${ITKT_ISL${d}}" "SL")
    COND_WRAP("${ITKM_ISL${d}}${ITKM_ISS${d}}" "${ITKT_ISL${d}},${ITKT_ISS${d}}" "SL;SS")
    COND_WRAP("${ITKM_ISL${d}}${ITKM_ISC${d}}" "${ITKT_ISL${d}},${ITKT_ISC${d}}" "SL;SC")
    
    COND_WRAP("${ITKM_ISS${d}}${ITKM_ID${d}}"  "${ITKT_ISS${d}},${ITKT_ID${d}}"  "SS;D")
    COND_WRAP("${ITKM_ISS${d}}${ITKM_IF${d}}"  "${ITKT_ISS${d}},${ITKT_IF${d}}"  "SS;F")
    COND_WRAP("${ITKM_ISS${d}}${ITKM_IUL${d}}" "${ITKT_ISS${d}},${ITKT_IUL${d}}" "SS") # needed for watershed
    COND_WRAP("${ITKM_ISS${d}}${ITKM_IUS${d}}" "${ITKT_ISS${d}},${ITKT_IUS${d}}" "SS;US")
    COND_WRAP("${ITKM_ISS${d}}${ITKM_IUC${d}}" "${ITKT_ISS${d}},${ITKT_IUC${d}}" "SS") # needed to save in 8 bits
    COND_WRAP("${ITKM_ISS${d}}${ITKM_ISL${d}}" "${ITKT_ISS${d}},${ITKT_ISL${d}}" "SS;SL")
    COND_WRAP("${ITKM_ISS${d}}${ITKM_ISS${d}}" "${ITKT_ISS${d}},${ITKT_ISS${d}}" "SS")
    COND_WRAP("${ITKM_ISS${d}}${ITKM_ISC${d}}" "${ITKT_ISS${d}},${ITKT_ISC${d}}" "SS;SC")
    
    COND_WRAP("${ITKM_ISC${d}}${ITKM_ID${d}}"  "${ITKT_ISC${d}},${ITKT_ID${d}}"  "SC;D")
    COND_WRAP("${ITKM_ISC${d}}${ITKM_IF${d}}"  "${ITKT_ISC${d}},${ITKT_IF${d}}"  "SC;F")
    COND_WRAP("${ITKM_ISC${d}}${ITKM_IUL${d}}" "${ITKT_ISC${d}},${ITKT_IUL${d}}" "SC") # needed for watershed
    COND_WRAP("${ITKM_ISC${d}}${ITKM_IUS${d}}" "${ITKT_ISC${d}},${ITKT_IUS${d}}" "SC;US")
    COND_WRAP("${ITKM_ISC${d}}${ITKM_IUC${d}}" "${ITKT_ISC${d}},${ITKT_IUC${d}}" "SC") # needed to save in 8 bits
    COND_WRAP("${ITKM_ISC${d}}${ITKM_ISL${d}}" "${ITKT_ISC${d}},${ITKT_ISL${d}}" "SC;SL")
    COND_WRAP("${ITKM_ISC${d}}${ITKM_ISS${d}}" "${ITKT_ISC${d}},${ITKT_ISS${d}}" "SC;SS")
    COND_WRAP("${ITKM_ISC${d}}${ITKM_ISC${d}}" "${ITKT_ISC${d}},${ITKT_ISC${d}}" "SC")
    

    # dim=3 -> dim=2, dim=3 -> dim=2
    FOREACH(d2 ${WRAP_ITK_DIMS})
      IF (NOT "${d}" EQUAL "${d2}") # this was already taken care of elsewhere
        COND_WRAP("${ITKM_ID${d}}${ITKM_ID${d2}}"   "${ITKT_ID${d}},${ITKT_ID${d2}}"   "D")
        COND_WRAP("${ITKM_IF${d}}${ITKM_IF${d2}}"   "${ITKT_IF${d}},${ITKT_IF${d2}}"   "F")
        COND_WRAP("${ITKM_IUL${d}}${ITKM_IUL${d2}}" "${ITKT_IUL${d}},${ITKT_IUL${d2}}" "UL")
        COND_WRAP("${ITKM_IUS${d}}${ITKM_IUS${d2}}" "${ITKT_IUS${d}},${ITKT_IUS${d2}}" "US")
        COND_WRAP("${ITKM_IUC${d}}${ITKM_IUC${d2}}" "${ITKT_IUC${d}},${ITKT_IUC${d2}}" "UC")
        COND_WRAP("${ITKM_ISL${d}}${ITKM_ISL${d2}}" "${ITKT_ISL${d}},${ITKT_ISL${d2}}" "SL")
        COND_WRAP("${ITKM_ISS${d}}${ITKM_ISS${d2}}" "${ITKT_ISS${d}},${ITKT_ISS${d2}}" "SS")
        COND_WRAP("${ITKM_ISC${d}}${ITKM_ISC${d2}}" "${ITKT_ISC${d}},${ITKT_ISC${d2}}" "SC")
      ENDIF(NOT "${d}" EQUAL "${d2}")
    ENDFOREACH(d2)

    
    # vector types
    COND_WRAP("${ITKM_IVD${d}${d}}${ITKM_IVD${d}${d}}"  "${ITKT_IVD${d}${d}},${ITKT_IVD${d}${d}}"  "VD")
    COND_WRAP("${ITKM_IVF${d}${d}}${ITKM_IVF${d}${d}}"  "${ITKT_IVF${d}${d}},${ITKT_IVF${d}${d}}"  "VF")
    COND_WRAP("${ITKM_ICVD${d}${d}}${ITKM_ICVD${d}${d}}"  "${ITKT_ICVD${d}${d}},${ITKT_ICVD${d}${d}}"  "CVD")
    COND_WRAP("${ITKM_ICVF${d}${d}}${ITKM_ICVF${d}${d}}"  "${ITKT_ICVF${d}${d}},${ITKT_ICVF${d}${d}}"  "CVF")

    # int -> RGB
    COND_WRAP("${ITKM_IUC${d}}${ITKM_IRGBUC${d}}" "${ITKT_IUC${d}},${ITKT_IRGBUC${d}}" "UC;RGBUC")
    COND_WRAP("${ITKM_IUS${d}}${ITKM_IRGBUS${d}}" "${ITKT_IUS${d}},${ITKT_IRGBUS${d}}" "US;RGBUS")

    # RGB -> int
    COND_WRAP("${ITKM_IRGBUS${d}}${ITKM_IUS${d}}" "${ITKT_IRGBUS${d}},${ITKT_IUS${d}}" "US;RGBUS")
    COND_WRAP("${ITKM_IRGBUC${d}}${ITKM_IUC${d}}" "${ITKT_IRGBUC${d}},${ITKT_IUC${d}}" "UC;RGBUC")

    # RGB -> RGB
    COND_WRAP("${ITKM_IRGBUS${d}}${ITKM_IRGBUS${d}}" "${ITKT_IRGBUS${d}},${ITKT_IRGBUS${d}}" "RGBUS")
    COND_WRAP("${ITKM_IRGBUC${d}}${ITKM_IRGBUC${d}}" "${ITKT_IRGBUC${d}},${ITKT_IRGBUC${d}}" "RGBUC")

  ENDFOREACH(d)
END_WRAP_CLASS()

