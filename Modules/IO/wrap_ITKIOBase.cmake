WRAP_CLASS("itk::RawImageIO" POINTER)
  FOREACH(d ${WRAP_ITK_DIMS})
    WRAP_TEMPLATE("${ITKM_F}${d}" "${ITKT_F},${d}")
  ENDFOREACH(d)
END_WRAP_CLASS()


# non templated IO classes and factories
WRAP_NON_TEMPLATE_CLASS("itk::ImageIOBase" POINTER)
WRAP_NON_TEMPLATE_CLASS("itk::IPLCommonImageIO" POINTER)

SET(io_classes
  AnalyzeImageIO
  BioRadImageIO
  BMPImageIO
  Brains2MaskImageIO
  DICOMImageIO2
  DicomImageIO
  GDCMImageIO
  GE4ImageIO
  GE5ImageIO
  GEAdwImageIO
  GiplImageIO
  JPEGImageIO
  LSMImageIO
  MetaImageIO
  NiftiImageIO
  NrrdImageIO
  PNGImageIO
  SiemensVisionImageIO
  StimulateImageIO
  TIFFImageIO
  VTKImageIO
)

FOREACH(c ${io_classes})
  WRAP_NON_TEMPLATE_CLASS("itk::${c}" POINTER)
  WRAP_NON_TEMPLATE_CLASS("itk::${c}Factory" POINTER)
ENDFOREACH(c)


# *SeriesFileNames
WRAP_NON_TEMPLATE_CLASS("itk::ArchetypeSeriesFileNames" POINTER)
WRAP_NON_TEMPLATE_CLASS("itk::DICOMSeriesFileNames" POINTER)
WRAP_NON_TEMPLATE_CLASS("itk::GDCMSeriesFileNames" POINTER)
WRAP_NON_TEMPLATE_CLASS("itk::NumericSeriesFileNames" POINTER)
WRAP_NON_TEMPLATE_CLASS("itk::RegularExpressionSeriesFileNames" POINTER)

