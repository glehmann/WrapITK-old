/*=========================================================================

  Program:   Insight Segmentation & Registration Toolkit
  Module:    $RCSfile: itkPyBuffer.txx,v $
  Language:  C++
  Date:      $Date: 2005/03/25 13:17:57 $
  Version:   $Revision: 1.1 $

  Copyright (c) Insight Software Consortium. All rights reserved.
  See ITKCopyright.txt or http://www.itk.org/HTML/Copyright.htm for details.

     This software is distributed WITHOUT ANY WARRANTY; without even 
     the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR 
     PURPOSE.  See the above copyright notices for more information.

=========================================================================*/
#ifndef _itkPyBuffer_txx
#define _itkPyBuffer_txx

#include "itkPyBuffer.h"
#include "itkPixelTraits.h"

// Deal with slight incompatibilites between NumPy (the future, hopefully), 
// Numeric (old version) and Numarray's Numeric compatibility module (also old).
#ifndef NDARRAY_VERSION 
// NDARRAY_VERSION is only defined by NumPy's arrayobject.h
// In non NumPy arrayobject.h files, PyArray_SBYTE is used instead of BYTE.
#define PyArray_BYTE PyArray_SBYTE
#endif

namespace itk
{

template<class TImage>
PyBuffer<TImage>
::PyBuffer()
{
    this->obj = NULL;
    this->m_Importer = ImporterType::New();
    
    //import_libnumarray();
    //import_libnumeric();
    import_array();
}

template<class TImage>
PyBuffer<TImage>
::~PyBuffer()
{
    if (this->obj)
    {
        Py_DECREF(this->obj);
    }
    this->obj = NULL;
}

    
template<class TImage>
PyObject * 
PyBuffer<TImage>
::GetArrayFromImage( const ImageType * image )
{
  if( !image )
    {
    itkExceptionMacro("Input image is null");
    }
  
  PixelType * buffer = const_cast < PixelType * > ( image->GetBufferPointer() );
 
  char * data = (char *)( buffer );
  
  int dimensions[ ImageDimension ];
  
  SizeType size = image->GetBufferedRegion().GetSize();
  
  for(unsigned int d=0; d < ImageDimension; d++ )
    {
    dimensions[ImageDimension - d - 1] = size[d];
    }

  int item_type = GetPyType();  // TODO find a way of doing this through pixel traits
  // figure out an appropriate type

  this->obj = PyArray_FromDimsAndData( ImageDimension, dimensions, item_type, data );

  return this->obj;
}



template<class TImage>
const typename PyBuffer<TImage>::ImageType * 
PyBuffer<TImage>
::GetImageFromArray( PyObject *obj )
{
    if (obj != this->obj)
    {
        if (this->obj)
        {
            // get rid of our reference
            Py_DECREF(this->obj);
        }

        // store the new object
        this->obj = obj;

        if (this->obj)
        {
            // take out reference (so that the calling code doesn't
            // have to keep a binding to the callable around)
            Py_INCREF(this->obj);
        }
    }
    

    int element_type = GetPyType();  ///PyArray_DOUBLE;  // change this with pixel traits.

    PyArrayObject * parray = 
          (PyArrayObject *) PyArray_ContiguousFromObject( 
                                                    this->obj, 
                                                    element_type,
                                                    ImageDimension,
                                                    ImageDimension  );

    if( parray == NULL )
      {
      itkExceptionMacro("Contiguous array couldn't be created from input python object");
      }

    const unsigned int imageDimension = parray->nd;
    
    SizeType size;

    unsigned int numberOfPixels = 1;

    for( unsigned int d=0; d<imageDimension; d++ )
      {
      size[imageDimension - d - 1]         = parray->dimensions[d];
      numberOfPixels *= parray->dimensions[d];
      }

    IndexType start;
    start.Fill( 0 );

    RegionType region;
    region.SetIndex( start );
    region.SetSize( size );

    PointType origin;
    origin.Fill( 0.0 );

    SpacingType spacing;
    spacing.Fill( 1.0 );

    this->m_Importer->SetRegion( region );
    this->m_Importer->SetOrigin( origin );
    this->m_Importer->SetSpacing( spacing );

    const bool importImageFilterWillOwnTheBuffer = false;
    
    PixelType * data = (PixelType *)parray->data;
    
    this->m_Importer->SetImportPointer( 
                        data,
                        numberOfPixels,
                        importImageFilterWillOwnTheBuffer );

    this->m_Importer->Update();
    
    return this->m_Importer->GetOutput();
}

template<class TImage>
typename PyBuffer<TImage>::PyArrayType
PyBuffer<TImage>
::GetPyType(void)
{
  PyArrayType item_type;
  typedef typename PixelTraits< PixelType >::ValueType    ScalarType;
  if(typeid(ScalarType) == typeid(double))
    {
    item_type = PyArray_DOUBLE;
    }
  else if(typeid(ScalarType) == typeid(float))
    {
    item_type = PyArray_FLOAT;
    }
  else if(typeid(ScalarType) == typeid(long))
    {
    item_type = PyArray_LONG;
    }
  else if(typeid(ScalarType) == typeid(unsigned long))
    {
#ifdef NDARRAY_VERSION
    item_type = PyArray_ULONG;
#else
    itkExceptionMacro(<<"Type currently not supported");
#endif
    }
  else if(typeid(ScalarType) == typeid(int))
    {
    item_type = PyArray_INT;
    }
  else if(typeid(ScalarType) == typeid(unsigned int))
    {
    item_type = PyArray_UINT;
    }
  else if(typeid(ScalarType) == typeid(short))
    {
    item_type = PyArray_SHORT;
    }
  else if(typeid(ScalarType) == typeid(unsigned short))
    {
    item_type = PyArray_USHORT;
    }
  else if(typeid(ScalarType) == typeid(signed char))
    {
    item_type = PyArray_BYTE;
    }
  else if(typeid(ScalarType) == typeid(unsigned char))
    {
    item_type = PyArray_UBYTE;
    }
  else
    {
    item_type = PyArray_NOTYPE;
    itkExceptionMacro(<<"Type currently not supported");
    }
  return item_type;
}

} // namespace itk

#endif

