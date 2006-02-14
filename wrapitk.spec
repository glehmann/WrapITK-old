
%define itkver 2.4

Summary:	Extended language support for ITK
Name:		wrapitk
Version:	0.1
Release:	%mkrel 0.13022006.1
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
Requires:	python-numarray
Requires:	itk >= %{itker}
Requires(pre):	itk >= %{itker}
Obsoletes:	itk-pyhon
Provides:	itk-pyhon

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

%prep

%setup -q -n WrapITK

%patch0 -p0

%build

mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX:PATH=%{_prefix} \
      -DCMAKE_BUILD_TYPE:STRING=Release \
      -DCMAKE_SKIP_RPATH:BOOL=ON \
      -DCableSwig_DIR:PATH=%{_prefix}/lib/CableSwig \
      -DWRAP_ITK_PYTHON:BOOL=ON \
      -DWRAP_unsigned_char:BOOL=ON \
      -DWRAP_ITK_INSTALL_LOCATION:PATH=/%{_lib}/InsightToolkit/WrapITK \
      ..

%make
%make


%install
[ "$RPM_BUILD_ROOT" != "/" ] && rm -rf $RPM_BUILD_ROOT
cd build
make install DESTDIR=$RPM_BUILD_ROOT


%files -n python-itk
%defattr(0644,root,root,0755)
%{_libdir}/InsightToolkit/WrapITK/Python*
%{_libdir}/InsightToolkit/WrapITK/lib/*Python*
%{_libdir}/python%{pyver}/site-packages/WrapITK.pth


%files devel
%defattr(0644,root,root,0755)
%{_libdir}/InsightToolkit/WrapITK/ClassIndex
%{_libdir}/InsightToolkit/WrapITK/Configuration
%{_libdir}/InsightToolkit/WrapITK/SWIG
%{_libdir}/InsightToolkit/WrapITK/WrapITKConfig.cmake
%{_datadir}/CMake/Modules/FindWrapITK.cmake


