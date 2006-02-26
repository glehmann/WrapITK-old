WRAP_CLASS("itk::ImageSource" POINTER)
  # Force uchar and ulong image sources for saving in 8 bits and watershed filter
  UNIQUE(image_types "UC;UL;${WRAP_ITK_ALL_TYPES}")
  WRAP_IMAGE_FILTER("${image_types}" 1)
END_WRAP_CLASS()
