%define name itkvtk
%define version 0.1
%define release 1

Summary: Connect ITK and VTK pipelines
Name: %{name}
Version: %{version}
Release: %{release}
Source0: http://voxel.jouy.inra.fr/darcs/itkvtk/%{name}-%{version}.tar.bz2
License: BSDish
Group:   Sciences/Other
Url:     http://voxel.jouy.inra.fr/darcs/itkvtk/
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-buildroot
BuildRequires: python-devel vtk-devel cmake gcc itk-devel
%description
Connect ITK and VTK pipelines



%package -n python-%name
Summary: Connect ITK and VTK pipelines in python
Group:   Development/Python

%description -n python-%name
Connect ITK and VTK pipelines in python



%package devel
Summary: Connect ITK and VTK pipelines
Group:   Development/C++
Requires: vtk-devel itk-devel

%description devel
This package contains the headers to connect ITK and VTK
pipelines in c++


%prep
%setup -q
cmake -DWRAP_PYTHON:BOOL=ON \
    -DCMAKE_SKIP_RPATH:BOOL=ON \
    -DCMAKE_INSTALL_PREFIX:PATH=%{_prefix} \
    .

%build

%install
rm -rf $RPM_BUILD_ROOT
%makeinstall_std

%clean
rm -rf $RPM_BUILD_ROOT

%files -n python-%name
%defattr(-,root,root)
%{_libdir}/InsightToolkit/*.so
%{_libdir}/InsightToolkit/*.py
%{_libdir}/InsightToolkit/python/*.py
%doc Wrapping/Python/Tests

%files devel
%defattr(-,root,root)
%{_includedir}/InsightToolkit/BasicFilters/*
