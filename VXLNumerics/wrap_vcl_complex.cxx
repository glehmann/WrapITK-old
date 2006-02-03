/* These wrappers are not automatically generated via CMake because the 
 * force_instatantiate section is necessary.
 * Other classes avoid this by formulating the typedefs in the wrappers
 * namespace as follows: 'typedef class<template params>::class ...;' which
 * forces an instantiation of the class in GCC_XML, so that all of the 
 * methods will be created properly. This is not possible with vcl_complex,
 * because on some systems vcl_complex is just a #define'd synonym for
 * std::complex, and 'typedef std::complex<...>::std::complex ...;' is not
 * valid. So we have to have the manual force_instantiate section to get 
 * GCC_XML to create the correct methods for vcl_comples.
 */

#include "vcl_complex.h"

#ifdef CABLE_CONFIGURATION
namespace _cable_
{
   const char* const group = "vcl_complex";
   namespace wrappers
   {
      typedef vcl_complex< double > vcl_complexD;

      typedef vcl_complex< float > vcl_complexF;

      typedef vcl_complex< long double > vcl_complexLD;
   }
}
void force_instantiate() 
{ 
  using namespace _cable_::wrappers;
  sizeof(vcl_complexD);
  sizeof(vcl_complexF);
  sizeof(vcl_complexLD);
}
#endif