
#Requires -Version 5.1
Set-StrictMode -Version 'Latest'

if( -not (Test-Path -Path 'variable:IsMacOS') )
{
    [Diagnostics.CodeAnalysis.SuppressMessage('PSAvoidAssignmentToAutomaticVariable', '')]
    $IsMacOS = $false
}

BeforeAll {
    & (Join-Path -Path $PSScriptRoot -ChildPath 'Initialize-Test.ps1' -Resolve)

    function Init
    {
    }
}

Describe 'Set-TlsCertificateValidator' {
    BeforeEach {
        $Global:Error.Clear()
    }

    AfterEach {
        Clear-TlsCertificateValidator
        [Net.ServicePointManager]::ServerCertificateValidationCallback | Should -BeNullOrEmpty
    }

    It 'should pass objects to script block' {
        Init
        {
            Set-TlsCertificateValidator -ScriptBlock {
                param(
                    [Net.HttpWebRequest] $Request,

                    [Security.Cryptography.X509Certificates.X509Certificate2] $Certificate,

                    [Security.Cryptography.X509Certificates.X509Chain] $Chain,

                    [Net.Security.SslPolicyErrors] $PolicyErrors
                )

                if( $Request -eq $null )
                {
                    throw "Sender parameter is null."
                }

                if( $Certificate -eq $null )
                {
                    throw "Certificate parameter is null."
                }

                if( $Chain -eq $null )
                {
                    throw "Chain parameter is null."
                }

                if( $PolicyErrors -eq $null )
                {
                    throw "PolicyErrors parameter is null."
                }

                return $PolicyErrors -eq [Net.Security.SslPolicyErrors]::None
            }
            Invoke-CrossPlatformHttpRequest -Url 'https://www.google.com/'
        } | Should -Not -Throw
    }

    It 'should handle script block returning true values <_>' -TestCases @($true, 1) -Skip:$IsMacOS {
        $result = $_
        {
            Set-TlsCertificateValidator { return $result }
            Invoke-CrossPlatformHttpRequest -Url 'https://self-signed.badssl.com'
        } | Should -Not -Throw
    }

    
    It 'should handle script block returning false values <_>' -TestCases @($false, 0) {
        $result = $_
        {
            Set-TlsCertificateValidator { return $result }
            Invoke-CrossPlatformHttpRequest -Url 'https://expired.badssl.com/'
        } | Should -Throw $TlsValidationFailedExceptionMessage
    }

}