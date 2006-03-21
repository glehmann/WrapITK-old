
%define itkver 2.4

Summary:	Extended language support for ITK
Name:		wrapitk
Version:	0.1
Release:	%mkrel 0.20060320.1
License:	BSDish
Group:		Sciences/Other
URL:		http://voxel.jouy.inra.fr/darcs/contrib-itk/WrapITK
Source0:	http://voxel.jouy.inra.fr/darcs/contrib-itk/WrapITK/WrapITK.tar.bz2
Patch0:		wrapitk-reconstruction.patch.bz2
BuildRequires:	cmake >= 2.2
BuildRequires:	cableswig >= %{itkver}
BuildRequires:  python-numarray-devel
BuildRequires:  vtk-devel
BuildRequires:  python-devel
BuildRequires:  tetex
BuildRequires:  tetex-latex
BuildRequires:  tetex-dvips
BuildRequires:  ghostscript
BuildRequires:  ImageMagick
BuildRequires:	vtk-devel >= 5.0
BuildRequires:	python-vtk >= 5.0
BuildRequires:	doxygen
BuildRoot:	%{_tmppath}/%{name}-%{version}-%{release}-buildroot

%description
ITK is an open-source software system to support the Visible Human Project. 
Currently under active development, ITK employs leading-edge segmentation 
and registration algorithms in two, three, and more dimensions.

The Insight Toolkit was developed by six principal organizations, three 
commercial (Kitware, GE Corporate R&D, and Insightful) and three academic 
(UNC Chapel Hill, University of Utah, and University of Pennsylvania). 
Additional team members include Harvard Brigham & Women's Hospital, 
University of Pittsburgh, and Columbia University. The funding for the 
project is from the National Library of Medicine at the National Institutes 
of Health. NLM in turn was supported by member institutions of NIH (see 
sponsors). 

%package  devel
Summary:	ITK header files for building C++ code
Group:		Development/C++
Requires:	cmake >= 2.2
Requires:	cableswig >= %{itkver}
Requires:	itk-devel >= %{itkver}

%description devel
ITK is an open-source software system to support the Visible Human Project. 
Currently under active development, ITK employs leading-edge segmentation 
and registration algorithms in two, three, and more dimensions.

The Insight Toolkit was developed by six principal organizations, three 
commercial (Kitware, GE Corporate R&D, and Insightful) and three academic 
(UNC Chapel Hill, University of Utah, and University of Pennsylvania). 
Additional team members include Harvard Brigham & Women's Hospital, 
University of Pittsburgh, and Columbia University. The funding for the 
project is from the National Library of Medicine at the National Institutes 
of Health. NLM in turn was supported by member institutions of NIH (see 
sponsors). 

%package -n python-itk
Summary:	Python bindings for ITK
Group:		Development/Python
Requires:	python
Requires:	itk >= %{itker}
Requires(pre):	itk >= %{itker}
Obsoletes:	itk-python
Provides:	itk-python

%description -n python-itk
ITK is an open-source software system to support the Visible Human Project. 
Currently under active development, ITK employs leading-edge segmentation 
and registration algorithms in two, three, and more dimensions.

The Insight Toolkit was developed by six principal organizations, three 
commercial (Kitware, GE Corporate R&D, and Insightful) and three academic 
(UNC Chapel Hill, University of Utah, and University of Pennsylvania). 
Additional team members include Harvard Brigham & Women's Hospital, 
University of Pittsburgh, and Columbia University. The funding for the 
project is from the National Library of Medicine at the National Institutes 
of Health. NLM in turn was supported by member institutions of NIH (see 
sponsors). 


%package -n python-itk-numarray
Summary:	Convert itk buffers to numarray objects
Group:		Development/Python
Requires:	python
Requires:	python-numarray
Requires:	python-itk = %{version}

%description -n python-itk-numarray
Convert itk buffers to numarray objects


%package -n python-itkvtk
Summary:	Convert itk buffers to vtk ones
Group:		Development/Python
Requires:	python
Requires:	python-itk = %{version}


%description -n python-itkvtk
Convert itk buffers to vtk ones


%package -n itkvtk-devel
Summary:	Convert itk buffers to vtk ones
Group:		Development/C++
Requires:	itk-devel


%description -n itkvtk-devel
Convert itk buffers to vtk ones


%prep

%setup -q -n WrapITK

%patch0 -p0

%build

mkdir build
(
cd build

cmake -DCMAKE_INSTALL_PREFIX:PATH=%{_libdir}/InsightToolkit/WrapITK \
      -DCMAKE_BUILD_TYPE:STRING=Release \
      -DCMAKE_SKIP_RPATH:BOOL=ON \
      -DCableSwig_DIR:PATH=%{_prefix}/lib/CableSwig \
      -DWRAP_ITK_PYTHON:BOOL=ON \
      -DWRAP_unsigned_char:BOOL=ON \
      -DDOXYGEN_MAN_PATH:PATH=%{_mandir} \
      ..

make
)

export LD_LIBRARY_PATH=`pwd`/build/bin:$LD_LIBRARY_PATH
export PYTHONPATH=`pwd`/build/Python:`pwd`/Python:$PYTHONPATH

# build the article
(
cd article
make
)

# build the doc
(
cd build/Python
mkdir -p doc
python make_doxygen_config.py doc
doxygen doxygen.config
)

# build the external projects
(
cd ExternalProjects/PyBuffer/
mkdir build
(
cd build

cmake -DCMAKE_INSTALL_PREFIX:PATH=%{_prefix} \
      -DCMAKE_BUILD_TYPE:STRING=Release \
      -DCMAKE_SKIP_RPATH:BOOL=ON \
      -DCableSwig_DIR:PATH=%{_prefix}/lib/CableSwig \
      -DWrapITK_DIR:PATH=`pwd`/../../../build \
      ..

make
)
)

(
cd ExternalProjects/ItkVtkGlue/
mkdir build
(
cd build

cmake -DCMAKE_INSTALL_PREFIX:PATH=%{_prefix} \
      -DCMAKE_BUILD_TYPE:STRING=Release \
      -DCMAKE_SKIP_RPATH:BOOL=ON \
      -DCableSwig_DIR:PATH=%{_prefix}/lib/CableSwig \
      -DWrapITK_DIR:PATH=`pwd`/../../../build \
      -DBUILD_WRAPPERS:BOOL=ON \
      ..

make
)
)



%install
[ "$RPM_BUILD_ROOT" != "/" ] && rm -rf $RPM_BUILD_ROOT

(
cd build
make install DESTDIR=$RPM_BUILD_ROOT
)

# workaround not found library
mkdir -p $RPM_BUILD_ROOT/%{_sysconfdir}/ld.so.conf.d/
echo %{_libdir}/InsightToolkit/WrapITK/Python-SWIG >> $RPM_BUILD_ROOT/%{_sysconfdir}/ld.so.conf.d/python-itk.conf

# install doc
mkdir -p $RPM_BUILD_ROOT/%{_mandir}
cp -r build/Python/doc/man3 $RPM_BUILD_ROOT/%{_mandir}
rm -f $RPM_BUILD_ROOT/%{_mandir}/man3/todo.3
rm -f $RPM_BUILD_ROOT/%{_mandir}/man3/itkBSplineDecompositionImageFilter.3
rm -f $RPM_BUILD_ROOT/%{_mandir}/man3/deprecated.3
rm -f $RPM_BUILD_ROOT/%{_mandir}/man3/BSplineUpsampleImageFilterBase.3


export LD_LIBRARY_PATH=`pwd`/build/bin:$LD_LIBRARY_PATH
export PYTHONPATH=`pwd`/build/Python:`pwd`/Python:$PYTHONPATH


# install the external projects
(
cd ExternalProjects/PyBuffer/build
make install DESTDIR=$RPM_BUILD_ROOT
)

(
cd ExternalProjects/ItkVtkGlue/build
make install DESTDIR=$RPM_BUILD_ROOT
)

%check
# TODO: run tests with ctest

export PYTHONPATH=`pwd`/build/Python:`pwd`/Python:$PYTHONPATH
export LD_LIBRARY_PATH=`pwd`/build/bin:$LD_LIBRARY_PATH

python Python/Tests/typemaps.py
python Python/Tests/template.py
python Python/Tests/itk-functions.py images/cthead1.png out.png
python Python/Tests/module2module.py images/cthead1.png

# tests the simple pipeline with differents iamge types
python Python/Tests/simple_pipeline.py "unsigned char" 2 images/cthead1.png out.png
python Python/Tests/simple_pipeline.py "unsigned short" 2 images/cthead1.png out.png
python Python/Tests/simple_pipeline.py "float" 2 images/cthead1.png out.img

python Python/Tests/simple_pipeline.py "unsigned char" 3 images/cthead1.png out.png
python Python/Tests/simple_pipeline.py "unsigned short" 3 images/cthead1.png out.png
python Python/Tests/simple_pipeline.py "float" 3 images/cthead1.png out.img

%clean
rm -rf $RPM_BUILD_ROOT


%post -n python-itk -p /sbin/ldconfig

%postun -n python-itk -p /sbin/ldconfig


%files -n python-itk
%defattr(0644,root,root,0755)
%{_libdir}/InsightToolkit/WrapITK/Python*
%{_libdir}/python%{pyver}/site-packages/WrapITK.pth
%{_sysconfdir}/ld.so.conf.d/python-itk.conf
%{_mandir}/man*/*
# exclude numarray files
%exclude %{_libdir}/InsightToolkit/WrapITK/ClassIndex/BufferConversion.mdx
%exclude %{_libdir}/InsightToolkit/WrapITK/ClassIndex/wrap_BufferConversionPython.idx
%exclude %{_libdir}/InsightToolkit/WrapITK/ClassIndex/wrap_itkPyBuffer.idx
%exclude %{_libdir}/InsightToolkit/WrapITK/Python/BufferConversion.py
%exclude %{_libdir}/InsightToolkit/WrapITK/Python-SWIG/BufferConversionPython.py
%exclude %{_libdir}/InsightToolkit/WrapITK/Python-SWIG/itkPyBuffer.py
%exclude %{_libdir}/InsightToolkit/WrapITK/Python/Configuration/BufferConversionConfig.py
%exclude %{_libdir}/InsightToolkit/WrapITK/SWIG/BufferConversion.swg
%exclude %{_libdir}/InsightToolkit/WrapITK/Python-SWIG/_BufferConversionPython.so
# exclude itkvtk files
%exclude %{_libdir}/InsightToolkit/WrapITK/ClassIndex/ItkVtkGlue.mdx
%exclude %{_libdir}/InsightToolkit/WrapITK/ClassIndex/wrap_ItkVtkGluePython.idx
%exclude %{_libdir}/InsightToolkit/WrapITK/ClassIndex/wrap_itkImageToVTKImageFilter.idx
%exclude %{_libdir}/InsightToolkit/WrapITK/ClassIndex/wrap_itkVTKImageToImageFilter.idx
%exclude %{_libdir}/InsightToolkit/WrapITK/Python/ItkVtkGlue.py
%exclude %{_libdir}/InsightToolkit/WrapITK/Python-SWIG/ItkVtkGluePython.py
%exclude %{_libdir}/InsightToolkit/WrapITK/Python-SWIG/itkImageToVTKImageFilter.py
%exclude %{_libdir}/InsightToolkit/WrapITK/Python-SWIG/itkVTKImageToImageFilter.py
%exclude %{_libdir}/InsightToolkit/WrapITK/Python/Configuration/ItkVtkGlueConfig.py
%exclude %{_libdir}/InsightToolkit/WrapITK/SWIG/ItkVtkGlue.swg
%exclude %{_libdir}/InsightToolkit/WrapITK/Python-SWIG/_ItkVtkGluePython.so

%doc article/*.pdf


%files -n python-itk-numarray
%defattr(0644,root,root,0755)
%{_libdir}/InsightToolkit/WrapITK/ClassIndex/BufferConversion.mdx
%{_libdir}/InsightToolkit/WrapITK/ClassIndex/wrap_BufferConversionPython.idx
%{_libdir}/InsightToolkit/WrapITK/ClassIndex/wrap_itkPyBuffer.idx
%{_libdir}/InsightToolkit/WrapITK/Python/BufferConversion.py
%{_libdir}/InsightToolkit/WrapITK/Python-SWIG/BufferConversionPython.py
%{_libdir}/InsightToolkit/WrapITK/Python-SWIG/itkPyBuffer.py
%{_libdir}/InsightToolkit/WrapITK/Python/Configuration/BufferConversionConfig.py
%{_libdir}/InsightToolkit/WrapITK/SWIG/BufferConversion.swg
%{_libdir}/InsightToolkit/WrapITK/Python-SWIG/_BufferConversionPython.so


%files -n python-itkvtk
%defattr(0644,root,root,0755)
%{_libdir}/InsightToolkit/WrapITK/ClassIndex/ItkVtkGlue.mdx
%{_libdir}/InsightToolkit/WrapITK/ClassIndex/wrap_ItkVtkGluePython.idx
%{_libdir}/InsightToolkit/WrapITK/ClassIndex/wrap_itkImageToVTKImageFilter.idx
%{_libdir}/InsightToolkit/WrapITK/ClassIndex/wrap_itkVTKImageToImageFilter.idx
%{_libdir}/InsightToolkit/WrapITK/Python/ItkVtkGlue.py
%{_libdir}/InsightToolkit/WrapITK/Python/itkvtk.py
%{_libdir}/InsightToolkit/WrapITK/Python-SWIG/ItkVtkGluePython.py
%{_libdir}/InsightToolkit/WrapITK/Python-SWIG/itkImageToVTKImageFilter.py
%{_libdir}/InsightToolkit/WrapITK/Python-SWIG/itkVTKImageToImageFilter.py
%{_libdir}/InsightToolkit/WrapITK/Python/Configuration/ItkVtkGlueConfig.py
%{_libdir}/InsightToolkit/WrapITK/SWIG/ItkVtkGlue.swg
%{_libdir}/InsightToolkit/WrapITK/Python-SWIG/_ItkVtkGluePython.so


%files devel
%defattr(0644,root,root,0755)
%{_libdir}/InsightToolkit/WrapITK/ClassIndex
%{_libdir}/InsightToolkit/WrapITK/Configuration
%{_libdir}/InsightToolkit/WrapITK/SWIG
%{_libdir}/InsightToolkit/WrapITK/WrapITKConfig.cmake
%{_datadir}/CMake/Modules/FindWrapITK.cmake

%files -n itkvtk-devel
%defattr(0644,root,root,0755)
%{_includedir}/InsightToolkit/BasicFilters/*


