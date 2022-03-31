
$skipCertCheckSupported = $null -ne (Get-Command -Name 'Invoke-WebRequest' -ParameterName 'SkipCertificateCheck' -ErrorAction Ignore)

function Invoke-CrossPlatformHttpRequest
{
    param(
        [Parameter(Mandatory)]
        [Uri] $Url
    )

    if( $skipCertCheckSupported )
    {
        Write-Debug 'Making request with [Net.WebRequest]::Create.'
        return [Net.WebRequest]::Create($Url).GetResponse()
    }

    Write-Debug 'Making request with Invoke-WebRequest.'
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri $Url
}

[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
$TlsValidationFailedExceptionMessage = 'The underlying connection was closed: Could not establish trust relationship ' +
                                       'for the SSL/TLS secure channel.'
if( $skipCertCheckSupported )
{
    $TlsValidationFailedExceptionMessage = 'Exception calling "GetResponse" with "0" argument(s): "The SSL ' +
                                           'connection could not be established, see inner exception."'
    if( $IsWindows -and $PSVersionTable['PSVersion'].Major -eq 6 -and $PSVersionTable['PSVersion'].Minor -eq 2 )
    {
        $TlsValidationFailedExceptionMessage = 'Exception calling "GetResponse" with "0" argument(s): "The SSL ' +
                                               'connection could not be established, see inner exception. The remote ' +
                                               'certificate is invalid according to the validation procedure."'
    }
}

Export-ModuleMember -Function 'Invoke-CrossPlatformHttpRequest' -Variable 'TlsValidationFailedExceptionMessage'