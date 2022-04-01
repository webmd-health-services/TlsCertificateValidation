
#Requires -Version 5.1
Set-StrictMode -Version 'Latest'

BeforeAll {
    & (Join-Path -Path $PSScriptRoot -ChildPath 'Initialize-Test.ps1' -Resolve)
}

Describe 'Test-SkipCertificateCheck' {
    It 'should return correct value for current version of PowerShell' {
        if( $PSVersionTable['PSVersion'].Major -ge 6 )
        {
            Test-SkipCertificateCheck | Should -BeTrue
        }
        else
        {
            Test-SkipCertificateCheck | Should -BeFalse
        }
    }
}