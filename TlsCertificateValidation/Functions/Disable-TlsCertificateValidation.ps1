
function Disable-TlsCertificateValidation
{
    <#
    .SYNOPSIS
    Turns off TLS server certificate validation in the current PowerShell session.

    .DESCRIPTION
    The `Disable-TlsCertificateValidation` function disables TLS server certificate validation for the current
    PowerShell session by setting the `[Net.ServicePointManager]::ServerCertificateValidationCallback` to a function
    that accepts all certificates. All https web requests made after calling `Disable-TlsCertificateValidation` will
    accept all invalid TLS certificates.

    To re-enable server certificate validation, use the `Enable-TlsCertificateValidation` function.

    .EXAMPLE
    Disable-TlsCertificateValidation

    Demonstrates how to turn off TLS server certificate validation.
    #>
    [CmdletBinding()]
    param(
        [switch] $Force
    )

    Set-StrictMode -Version 'Latest'

    Set-TlsCertificateValidator -ScriptBlock { return $true }
}
