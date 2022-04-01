
function Set-TlsCertificateValidator
{
    <#
    .SYNOPSIS
    Sets the .NET custom server certificate validation callback function to use a PowerShell script block.

    .DESCRIPTION
    The `Set-TlsCertificateValidator` allows you use a PowerShell script block to add custom validation when .NET is
    valiating a server's TLS certificate. Pass the script block to the `ScriptBlock` parameter. Your script block *must*
    return `$true` if the certificate is valid and should be trusted, or `$false` or nothing if the certificate is
    invalid and should not be trusted.

    The script block is passed four *optional* parameters, in this order:
    
    * `[Object] $Sender`: contains state information for the validation.
    * `[Security.Cryptography.X509Certificates.X509Certificate2] $Certificate`: the certificate to validate.
    * `[Security.Cryptography.X509Certificates.X509Chain] $Chain`: the certificate chain of the certificate.
    * `[Net.Security.SslPolicyErrors] $PolicyErrors`: a flags enum for the certificate's policy errors (if any).

    Your validator will continue to be used in the current PowerShell session until you call the
    `Clear-TlsCertificateValidator` function to remove it.

    .EXAMPLE
    Set-TlsCertificateValidator { $true }

    Demonstrates how to use this function to trust all TLS certificates.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)]
        [scriptblock] $ScriptBlock
    )

    Set-StrictMode -Version 'Latest'

    [TlsCertificateValidation.ServerCertificateCallbackShim]::RegisterScriptBlockValidator($ScriptBlock)
}
