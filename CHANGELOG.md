
# 0.1.0

# Added

* Added function `Set-TlsCertificateValidator` which sets the .NET server certificate validator to a PowerShell
  script block.
* Added function `Clear-TlsCertificateValidator` which removes the current, custom .NET server certificate validator.
* Added function `Test-SkipCertificateCheck` which tests if PowerShell supports the `SkipCertificateCheck` function on
  `Invoke-WebRequest` and `Invoke-RestMethod`.

