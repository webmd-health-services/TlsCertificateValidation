
function Test-SkipCertificateCheck
{
    <#
    .SYNOPSIS
    Tests if PowerShell supports the `SkipCertificateCheck` parameter on `Invoke-WebRequest` and `Invoke-RestMethod`.

    .DESCRIPTION
    The `Test-SkipCertificateCheck` function tests if the `Invoke-WebRequest` and `Invoke-RestMethod` have the
    `SkipCertificateCheck` switch. The purpose of this function is for use in cross-platform or cross-edition scripts
    when they need to ignore invalid TLS certificates. If this function returns `$true`, code should use the
    `SkipCertificateCheck` switch on `Invoke-WebRequest` and `Invoke-RestMethod`. If `$false`, scripts should use the
    `Disable-TlsCertificateValidation` and `Enable-TlsCertificateValidation` functions. This logic is shown in the
    following sample code:

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

    .EXAMPLE
    Test-SkipCertificateCheck
    #>
    [CmdletBinding()]
    param(
    )

    Set-StrictMode -Version 'Latest'

    return $null -ne (Get-Command -Name 'Invoke-WebRequest' -ParameterName 'SkipCertificateCheck' -ErrorAction Ignore)
}
