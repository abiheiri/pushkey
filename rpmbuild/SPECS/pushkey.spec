Name:           pushkey
Version:        1.0.1
Release:        1%{?dist}
Summary:        SSH keys pushing and generating

Group:          "Administration Tools"
License:        GPL v3 
URL:            http://forgottheaddress.blogspot.com 
Source0:        pushkey.gz
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

Packager: Al Biheiri <abiheiri@gmail.com>

%description
Pushkey generates ssh keys and pushes the keys to other servers

%prep
%setup -q


%build


%install
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT/usr/bin/
install -m 755 pushkey $RPM_BUILD_ROOT/usr/bin/

%clean
rm -rf $RPM_BUILD_ROOT


%files
%defattr(-,root,root,-)
%doc
/usr/bin/pushkey


%changelog

