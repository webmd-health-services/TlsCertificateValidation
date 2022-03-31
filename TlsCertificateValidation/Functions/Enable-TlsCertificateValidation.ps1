
function Enable-TlsCertificateValidation
{
    <#
    .SYNOPSIS
    Turns on TLS server certificate validation in the current PowerShell session.

    .DESCRIPTION
    The `Enable-TlsCertificateValidation` function enables TLS server certificate validation for the current
    PowerShell session by clearing the `[Net.ServicePointManager]::ServerCertificateValidationCallback`. All https web
    requests made after calling `Enable-TlsCertificateValidation` will reject all invalid TLS certificates.

    To disable server certificate validation, use the `Disable-TlsCertificateValidation` function.

    .EXAMPLE
    Enable-TlsCertificateValidation

    Demonstrates how to turn on TLS server certificate validation.
    #>
    [CmdletBinding()]
    param(
        [switch] $Force
    )

    Set-StrictMode -Version 'Latest'

    Clear-TlsCertificateValidator
}
