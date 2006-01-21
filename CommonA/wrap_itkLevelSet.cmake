# auto include feature must be disable because the class is not in the file
# with the same name
SET(itk_AutoInclude OFF)

WRAP_CLASS("LevelSetNode" DEREF)
  SET(WRAPPER_TEMPLATES "${itk_Wrap_LevelSetNode}")
END_WRAP_CLASS()
