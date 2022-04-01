
function Clear-TlsCertificateValidator
{
    <#
    .SYNOPSIS
    Removes the current server certificate validation callback function.

    .DESCRIPTION
    The `Clear-TlsCertificateValidator` function removes the current server certificate validaton function. .NET allows
    you to set a custom callback function that it will call when validating TLS certificates. This function sets that
    callback function to `$null` (i.e. sets the `[Net.ServicePointManager]::ServerCertificateValidationCallback` 
    property to `$null`).

    .EXAMPLE
    Clear-TlsCertificateValidator

    Demonstrates how to remove the current custom server certificate validator.
    #>
    [CmdletBinding()]
    param(
    )

    Set-StrictMode -Version 'Latest'

    [Net.ServicePointManager]::ServerCertificateValidationCallback = $null
}

