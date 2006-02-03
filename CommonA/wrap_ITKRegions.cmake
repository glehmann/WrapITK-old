WRAP_NON_TEMPLATE_CLASS("itk::Region")
WRAP_NON_TEMPLATE_CLASS("itk::MeshRegion")

WRAP_CLASS("itk::ImageRegion")
  FOREACH(d ${WRAP_DIMS})
    WRAP(${d} ${d})
  ENDFOREACH(d)  
END_WRAP_CLASS()
