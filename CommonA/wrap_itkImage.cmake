WRAP_CLASS(ImageBase POINTER)
  FOREACH(d ${WRAP_DIMS})
    WRAP("${d}"  "${d}")
  ENDFOREACH(d)
END_WRAP_CLASS()

WRAP_CLASS("Image" POINTER)
  SET(itk_Wrap "${itk_Wrap_Image}")
END_WRAP_CLASS()