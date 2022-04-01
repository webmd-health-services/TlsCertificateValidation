
#Requires -Version 5.1
Set-StrictMode -Version 'Latest'


BeforeAll {
    & (Join-Path -Path $PSScriptRoot -ChildPath 'Initialize-Test.ps1' -Resolve)
}

Describe 'Disable-TlsCertificateValidation' {
    It 'should allow requests to websites with invalid TLS certificates' {
        { Invoke-CrossPlatformHttpRequest -Url 'https://wrong.host.badssl.com/' } | 
            Should -Throw $TlsValidationFailedExceptionMessage
        { Invoke-CrossPlatformHttpRequest -Url 'https://untrusted-root.badssl.com/' } | 
            Should -Throw $TlsValidationFailedExceptionMessage
        Disable-TlsCertificateValidation
        { Invoke-CrossPlatformHttpRequest -Url 'https://wrong.host.badssl.com/' } | Should -Not -Throw
        Enable-TlsCertificateValidation
        # PowerShell/.NET cache the result of certificate validation, so hit a different host.`
        { Invoke-CrossPlatformHttpRequest -Url 'https://untrusted-root.badssl.com/' } | 
            Should -Throw $TlsValidationFailedExceptionMessage
    }
}