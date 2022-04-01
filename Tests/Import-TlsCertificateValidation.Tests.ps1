
#Requires -Version 5.1
Set-StrictMode -Version 'Latest'

BeforeAll {
    & (Join-Path -Path $PSScriptRoot -ChildPath 'Initialize-Test.ps1' -Resolve)

    function GivenModuleLoaded
    {
        Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath '..\TlsCertificateValidation\TlsCertificateValidation.psd1' -Resolve)
        Get-Module -Name 'TlsCertificateValidation' | Add-Member -MemberType NoteProperty -Name 'NotReloaded' -Value $true
    }

    function GivenModuleNotLoaded
    {
        Remove-Module -Name 'TlsCertificateValidation' -Force -ErrorAction Ignore
    }

    function Init
    {

    }

    function ThenModuleLoaded
    {
        $module = Get-Module -Name 'TlsCertificateValidation'
        $module | Should -Not -BeNullOrEmpty
        $module | Get-Member -Name 'NotReloaded' | Should -BeNullOrEmpty
    }

    function WhenImporting
    {
        $script:importedAt = Get-Date
        Start-Sleep -Milliseconds 1
        & (Join-Path -Path $PSScriptRoot -ChildPath '..\TlsCertificateValidation\Import-TlsCertificateValidation.ps1' -Resolve)
    }
}

Describe 'Import-TlsCertificateValidation' {
    It 'should import the module when module not laoded' {
        Init
        GivenModuleNotLoaded
        WhenImporting
        ThenModuleLoaded
    }

    It 'should re-import the module when module already loaded' {
        Init
        GivenModuleLoaded
        WhenImporting
        ThenModuleLoaded
    }
}
