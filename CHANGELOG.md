<!--markdownlint-disable MD012 no-multiple-blanks-->

# TlsCertificateValidation Changelog

## 2.0.1

Removing unused internal, private, nested dependencies.

## 2.0.0

> Released 1 Jul 2024

### Changed

TlsCertificateValidation now requires .NET Framework 4.8 (from 4.6.1) when running under Windows PowerShell.

### Fixed

On some systems, anti-virus interferes with the dynamic assembly TlsCertificateValidation attempts to compile and load
with `Add-Type`. The module now ships with a pre-built assembly.


## 1.0.0

> Released 17 Jan 2024

Fixed: importing `TlsCertificateValidation` can sometimes fail with a "type already exists" compilation error.


## 0.1.0

> Released 1 Apr 2024

# Added

* Added function `Set-TlsCertificateValidator` which sets the .NET server certificate validator to a PowerShell
  script block.
* Added function `Clear-TlsCertificateValidator` which removes the current, custom .NET server certificate validator.
* Added function `Test-SkipCertificateCheck` which tests if PowerShell supports the `SkipCertificateCheck` function on
  `Invoke-WebRequest` and `Invoke-RestMethod`.

