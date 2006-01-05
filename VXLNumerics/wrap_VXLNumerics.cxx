/*=========================================================================

  Program:   Insight Segmentation & Registration Toolkit
  Module:    $RCSfile: wrap_VXLNumerics.cxx,v $
  Language:  C++
  Date:      $Date: 2005/08/19 10:29:31 $
  Version:   $Revision: 1.2 $

  Copyright (c) Insight Software Consortium. All rights reserved.
  See ITKCopyright.txt or http://www.itk.org/HTML/Copyright.htm for details.

     This software is distributed WITHOUT ANY WARRANTY; without even 
     the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR 
     PURPOSE.  See the above copyright notices for more information.

=========================================================================*/
#ifdef CABLE_CONFIGURATION
#include "wrap_VXLNumerics.h"
namespace _cable_
{
  const char* const package = ITK_WRAP_PACKAGE;
  const char* const groups[] =
  {
    "vnl_matrix",
    "vnl_vector",
    "vnl_c_vector",
    "vnl_diag_matrix",
    "vnl_file_matrix",
    "vnl_file_vector",
    "vnl_fortran_copy",
    "vnl_matrix_fixed",
    "vnl_matrix_fixed_ref",
    "vnl_matrix_ref",
    "vnl_vector_ref"
  };
}
#endif
