# Copyright WebMD Health Services
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License

#Requires -Version 5.1
Set-StrictMode -Version 'Latest'

# Functions should use $moduleRoot as the relative root from which to find
# things. A published module has its function appended to this file, while a
# module in development has its functions in the Functions directory.
$moduleRoot = $PSScriptRoot

Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath 'Modules\Carbon.Core' -Resolve) `
              -Function @('Test-CType')

if (-not (Test-CType -Name 'TlsCertificateValidation.ServerCertificateCallbackShim'))
{
    Add-Type -Path (Join-Path -Path $moduleRoot -ChildPath 'ServerCertificateCallbackShim.cs')
}

$functionsPath = Join-Path -Path $moduleRoot -ChildPath 'Functions\*.ps1'
if( (Test-Path -Path $functionsPath) )
{
    foreach( $functionPath in (Get-Item $functionsPath) )
    {
        . $functionPath.FullName
    }
}
