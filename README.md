<!--markdownlint-disable MD012 no-multiple-blanks-->

# TlsCertificateValidation PowerShell Module

## Overview

The "TlsCertificateValidation" PowerShell module allows you to manage how Windows PowerShell's `Invoke-WebRequest` and
`Invoke-RestMethod` cmdlet validate TLS server certificates. With it, you can:

* Completely disable TLS server certificate validation, with its `Disable-TlsCertificateValidation` function.
* Write your own server certificate validation in PowerShell with its `Set-TlsCertificateValidator` function.
* Check if PowerShell supports the `SkipCertificateCheck` switch on `Invoke-WebRequest` and `Invoke-RestMethod` with its
  `Test-SkipCertificateChec` function.


## System Requirements

* Windows PowerShell 5.1 and .NET 4.8
* PowerShell 6+ [1]

## A Note About PowerShell 6 Support

This module uses the global `[Net.ServicePointManager]::ServerCertificateValidationCallback` callback to wire up custom
validation. In PowerShell 6+, the `Invoke-WebRequest` and `Invoke-RestMethod` functions don't use this global callback,
and instead have a `SkipCertificateCheck` switch to disable server certificate validation. This module will not work
on PowerShell 6+ when trying to bypass server certificate checks that fail under `Invoke-WebRequest` and
`Invoke-RestMethod`. This module should work with other .NET classes that use the
`[Net.ServicePointManager]::ServerCertificateValidationCallback` callback.


## Installing

To install globally:

```powershell
Install-Module -Name 'TlsCertificateValidation'
Import-Module -Name 'TlsCertificateValidation'
```

To install privately:

```powershell
Save-Module -Name 'TlsCertificateValidation' -Path '.'
Import-Module -Name '.\TlsCertificateValidation'
```

## Usage

```powershell
$iwrArgs = @{}
if( (Test-SkipCertificateCheck) )
{
    $iwrArgs['SkipCertificateCheck'] = $true
}
else
{
    Disable-TlsCertificateValidation
}

try
{
    Invoke-WebRequest -Uri 'https://expired.badssl.com/' @iwrArgs
}
finally
{
    if( -not (Test-SkipCertificateCheck) )
    {
        Enable-TlsCertificateValidation
    }
}
```


## Commands

### Disable-TlsCertificateValidation

Disables all TLS server certificate validation by accepting all certificates.

```powershell
Disable-TlsCertificateValidation
```

### Enable-TlsCertificateValidation

Re-enables PowerShell's default server certificate validation behavior.

```powershell
Enable-TlsCertificateValidation
```

### Set-TlsCertificateValidator

Use your own code to validate TLS server certificates:

```powershell
Set-TlsCertificateValidator -ScriptBlock {
    param(
        [Object] $Sender,

        [Security.Cryptography.X509Certificates.X509Certificate2] $Certificate,

        [Security.Cryptography.X509Certificates.X509Chain] $Chain,

        [Net.Security.SslPolicyErrors] $PolicyErrors
    )

    # Callback always gets called, even if there are no errors, so make sure you add this if you don't care about valid
    # certificates.
    if( $PolicyErrors -eq [Net.Security.SslPolicyErrors]::None )
    {
        return $true
    }

    if( $Certificate.Issuer -eq $Certificate.Subject )
    {
        return $true
    }

    return $false
}
```

The above example demonstrates a server certificate validation script block that accepts self-signed certificates.

### Clear-TlsCertificateValidator

Removes your custom validator. Call this function once you've finished making requests, otherwise your validator will
continue to be used in the current PowerShell session.

```powershell
Clear-TlsCertificateValidator
```

### Test-SkipCertificateCheck

Use this function if you want to support multiple versions of PowerShell and some of those versions don't have the
`SkipCertificateCheck` functionality. Returns `$true` if PowerShell's `Invoke-WebRequest` and `Invoke-RestMethod`
cmdlets have the `SkipCertificateCheck` switch. Return `$false` otherwise.

```powershell
$iwrArgs = @{}
if( (Test-SkipCertificateCheck) )
{
    $iwrArgs['SkipCertificateCheck'] = $true
}
else
{
    Disable-TlsCertificateValidation
}

try
{
    Invoke-WebRequest -Uri 'https://expired.badssl.com/' @iwrArgs
}
finally
{
    if( -not (Test-SkipCertificateCheck) )
    {
        Enable-TlsCertificateValidation
    }
}
```
