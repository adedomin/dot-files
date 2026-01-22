Set-PSReadlineKeyHandler -Key Tab -Function Complete
Set-PSReadlineKeyHandler -Key Shift+Tab -Function TabCompletePrevious
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

Set-PSReadlineOption `
  -BellStyle None `
  -EditMode Emacs `
  -ContinuationPrompt '' `
  -Colors @{
    Operator = 'Green'
    Parameter = 'Green'
  }

$PSDefaultParameterValues['Out-File:Encoding'] = 'UTF8NoBOM'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Set-Alias which Get-Command

Function Convert-WindowsTrustToPem {
  Get-ChildItem Cert:\LocalMachine\Root, Cert:\LocalMachine\CA | % { $_.ExportCertificatePem() }
}

Function ConvertTo-User {
  Param(
    [Parameter(Mandatory=$true)]
    [String]$SID
  )
  $_sid = New-Object System.Security.Principal.SecurityIdentifier -ArgumentList $SID
  $_sid.Translate([System.Security.Principal.NTAccount])
}

Function ConvertTo-SID {
  Param(
    [Parameter(Mandatory=$true)]
    [String]$User
  )
  $_user = New-Object System.Security.Principal.NTAccount -ArgumentList $User
  $_user.Translate([System.Security.Principal.SecurityIdentifier])
}

$null = New-PSDrive -PSProvider Registry -Name HKCR -Root "HKCU:\Software\Classes"
