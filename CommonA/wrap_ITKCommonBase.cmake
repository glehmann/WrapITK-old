WRAP_NON_TEMPLATE_CLASS("itk::Command"            POINTER)
WRAP_NON_TEMPLATE_CLASS("itk::DataObject"         POINTER)
WRAP_NON_TEMPLATE_CLASS("itk::Directory"          POINTER)
WRAP_NON_TEMPLATE_CLASS("itk::DynamicLoader"      POINTER)
WRAP_NON_TEMPLATE_CLASS("itk::LightObject"        POINTER)
WRAP_NON_TEMPLATE_CLASS("itk::Object"             POINTER)
WRAP_NON_TEMPLATE_CLASS("itk::ObjectFactoryBase"  POINTER)
WRAP_NON_TEMPLATE_CLASS("itk::LightProcessObject" POINTER)
WRAP_NON_TEMPLATE_CLASS("itk::ProcessObject"      POINTER)
WRAP_NON_TEMPLATE_CLASS("itk::OutputWindow"       POINTER)
WRAP_NON_TEMPLATE_CLASS("itk::Version"            POINTER)
WRAP_NON_TEMPLATE_CLASS("itk::TimeStamp")
WRAP_NON_TEMPLATE_CLASS("itk::Indent")
WRAP_NON_TEMPLATE_CLASS("itk::StringStream")
WRAP_NON_TEMPLATE_CLASS("itk::MetaDataDictionary")

# gcc-xml on windows cannot be allowed to see the full MultiThreader
# header because currently gcc-xml and cswig cannot properly wrap functions
# that use __stdcall specifiers, which one part of MultiThreader.h does on
# windows. Just pass the stub header which will keep gcc-xml away from the 
# real header on windows.
SET(WRAPPER_AUTO_INCLUDE_HEADERS OFF)
WRAP_INCLUDE("itkMultiThreaderStub.h")
WRAP_NON_TEMPLATE_CLASS("itk::MultiThreader"      POINTER)

