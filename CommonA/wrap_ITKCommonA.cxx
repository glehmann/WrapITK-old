/*=========================================================================

  Program:   Insight Segmentation & Registration Toolkit
  Module:    $RCSfile: wrap_ITKCommonA.cxx,v $
  Language:  C++
  Date:      $Date: 2005/08/19 10:29:28 $
  Version:   $Revision: 1.2 $

  Copyright (c) Insight Software Consortium. All rights reserved.
  See ITKCopyright.txt or http://www.itk.org/HTML/Copyright.htm for details.

     This software is distributed WITHOUT ANY WARRANTY; without even 
     the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR 
     PURPOSE.  See the above copyright notices for more information.

=========================================================================*/
#ifdef CABLE_CONFIGURATION
namespace _cable_
{
  const char* const package = ITK_WRAP_PACKAGE;
  const char* const groups[] =
  {
    "ITKCommonBase",
    "ITKInterpolators",
    "ITKRegions",
    "itkArray",
    "itkBinaryBallStructuringElement",
    "itkContinuousIndex",
    "itkDifferenceImageFilter",
    "itkDenseFiniteDifferenceImageFilter",
    "itkEventObject", 
    "itkFiniteDifferenceFunction",
    "itkFiniteDifferenceImageFilter",
    "itkFixedArray",
    "itkFunctionBase",
    "itkImage_2D",
    "itkImage_3D",
    "itkImageSource",
    "itkImageConstIterator",
    "itkImageRegionIterator",
    "itkImageRegionConstIterator",
    "itkImageFunction",
    "itkImageToImageFilter_2D",
    "itkImageToImageFilter_3D",
    "itkInPlaceImageFilter_2D",
    "itkInPlaceImageFilter_3D",
    "itkIndex",
    "itkLevelSet",
    "itkNeighborhood",
    "itkPoint",
    "itkSize",
    "itkMatrix",
#ifdef ITK_TCL_WRAP
    "ITKUtils",
#endif
#ifdef ITK_PYTHON_WRAP
    "ITKPyUtils",
#ifdef ITK_PYTHON_NUMERICS
    "itkPyBuffer",
#endif
#endif
    "SwigExtras",
    "itkVector",
    "itkVectorContainer",
    "itkSimpleDataObjectDecorator",
    "itkOffset",
    "itkImageBoundaryCondition",
    "itkPointSet",
    "itkDefaultStaticMeshTraits",
  };
}
#endif
