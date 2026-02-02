# My longtime tried and true
Import-Module posh-git
# No symbols/nerd fonts
$GitPromptSettings.DefaultPromptWriteStatusFirst = $true
$GitPromptSettings.DefaultPromptBeforeSuffix.Text = '`n$([DateTime]::now.ToString("MM-dd HH:mm:ss"))'
$GitPromptSettings.DefaultPromptBeforeSuffix.ForegroundColor = 0x808080
$GitPromptSettings.DefaultPromptSuffix = ' $((Get-History -Count 1).id + 1)$(">" * ($nestedPromptLevel + 1)) '
#
# ---
#
# With symbols/nerd fonts
# $Symbols = @{
#     Branch       = [char]0xE725  # 
#     Directory    = [char]0xF115  # 
#     Clock        = [char]0xF64F  #  
#     CommandId    = [char]0xF489  # 
# }
#
# $GitPromptSettings.DefaultPromptWriteStatusFirst = $true
#
# # $GitPromptSettings.DefaultPromptBeforeSuffix.Text = "`n$($Symbols.Clock) $([DateTime]::now.ToString('MM-dd HH:mm:ss'))"
# $GitPromptSettings.DefaultPromptBeforeSuffix.Text = "`n$([DateTime]::now.ToString('MM-dd HH:mm:ss'))"
# $GitPromptSettings.DefaultPromptBeforeSuffix.ForegroundColor = 0x808080
# $GitPromptSettings.DefaultPromptSuffix = " $($Symbols.CommandId) $((Get-History -Count 1).id + 1)$('>' * ($nestedPromptLevel + 1)) "
#
# $GitPromptSettings.DefaultPromptPath = "$($Symbols.Directory) $PWD"


# function Get-VirtualEnvPrompt {
#     $venvName = $env:VIRTUAL_ENV
#     if ($venvName) {
#         $venvName = $venvName.Split('\')[-1]
#         $venvPrompt = "($venvName) "
#     } else {
#         $venvPrompt = ""
#     }
#     return $venvPrompt
# }

# $venvPrompt = Get-VirtualEnvPrompt

# $GitPromptSettings.DefaultPromptSuffix = "$venvPrompt $((Get-History -Count 1).id + 1)$(">" * ($nestedPromptLevel + 1)) "

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
# $ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
# if (Test-Path($ChocolateyProfile)) {
#   Import-Module "$ChocolateyProfile"
# }

# Azure CLI Config
# Register-ArgumentCompleter -Native -CommandName az -ScriptBlock {
#     param($commandName, $wordToComplete, $cursorPosition)
#     $completion_file = New-TemporaryFile
#     $env:ARGCOMPLETE_USE_TEMPFILES = 1
#     $env:_ARGCOMPLETE_STDOUT_FILENAME = $completion_file
#     $env:COMP_LINE = $wordToComplete
#     $env:COMP_POINT = $cursorPosition
#     $env:_ARGCOMPLETE = 1
#     $env:_ARGCOMPLETE_SUPPRESS_SPACE = 0
#     $env:_ARGCOMPLETE_IFS = "`n"
#     $env:_ARGCOMPLETE_SHELL = 'powershell'
#     az 2>&1 | Out-Null
#     Get-Content $completion_file | Sort-Object | ForEach-Object {
#         [System.Management.Automation.CompletionResult]::new($_, $_, "ParameterValue", $_)
#     }
#     Remove-Item $completion_file, Env:\_ARGCOMPLETE_STDOUT_FILENAME, Env:\ARGCOMPLETE_USE_TEMPFILES, Env:\COMP_LINE, Env:\COMP_POINT, Env:\_ARGCOMPLETE, Env:\_ARGCOMPLETE_SUPPRESS_SPACE, Env:\_ARGCOMPLETE_IFS, Env:\_ARGCOMPLETE_SHELL
# }

function Activate-Venv {
    $relativePath = "dotfiles\scripts\powershell\ActivateVenv.ps1"
    $scriptPath = Join-Path $env:USERPROFILE $relativePath
    & $scriptPath
}

function Download-Files {
    $relativePath = "dotfiles\scripts\powershell\DownloadFiles.ps1"
    $scriptPath = Join-Path $env:USERPROFILE $relativePath
    & $scriptPath
}

function Interactive-Download-Files {
    $relativePath = "dotfiles\scripts\powershell\InteractiveDownloadFiles.ps1"
    $scriptPath = Join-Path $env:USERPROFILE $relativePath
    & $scriptPath
}

# Remove the coloring schemes applied to `ls` result directories, etc
if ($PSVersionTable.PSVersion.Major -ge 7) {
    $PSStyle.OutputRendering = "Plaintext"
    $PSStyle.OutputRendering = [System.Management.Automation.OutputRendering]::PlainText
} else {
    # Write-Host "Running older version of Powershell, certain $PROFILE settings not applied"
}

# https://stackoverflow.com/questions/59989247/how-to-turn-off-syntax-highlighting-in-console-windows-10-2020
# Set-PSReadLineOption -Colors @{None='black';Comment='black';Keyword='black';String='black';Operator='black';Variable='black';Command='black';Parameter='black';Type='black';Number='black';Member='black'}

# Per Bing Chat
# Set-PSReadLineOption -Colors @{
#     'Command'='black';
#     'Comment'='black';
#     'ContinuationPrompt'='black';
#     'Default'='black';
#     'Emphasis'='black';
#     'Error'='black';
#     'Keyword'='black';
#     'Member'='black';
#     'Number'='black';
#     'Operator'='black';
#     'Parameter'='black';
#     'Selection'='black';
#     'String'='black';
#     'Type'='black';
#     'Variable'='black'
# }

# Okay, so quick update on this! Turns out there is a setting in `fd` to disable this.
# `fd --color=never ...`
# Set-Alias -Name fd -Value "fd --color=never"

# Customize `ls` command to show hidden files and pipe the output to less
# Remove-Item Alias:ls -ErrorAction SilentlyContinue

# Updated to reinstate original ls alias, set | less version as lsh
Set-Alias -Name ls -Value Get-ChildItem
function lsh {
    Get-ChildItem -Force @args | less
}

# uv
(& uv generate-shell-completion powershell) | Out-String | Invoke-Expression
(& uvx --generate-shell-completion powershell) | Out-String | Invoke-Expression

# Trying to find a way to have Mason use pnpm rather than npm for node related dependencies...
# Set-Alias npm pnpm

# Starship
# $env:STARSHIP_CONFIG = "$env:USERPROFILE\dotfiles\starship\starship.toml"
# Invoke-Expression (&starship init powershell)
# TransientPrompt Kept showing a weird character symbol, disabling for now...
# Enable-TransientPrompt

# yazi
# Use `y` to have the shell "follow" your path location. `q` to quit with follow, `Q` to quit without follow
function y {
    $tmp = [System.IO.Path]::GetTempFileName()
    yazi $args --cwd-file="$tmp"
    $cwd = Get-Content -Path $tmp
    if (-not [String]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path) {
        Set-Location -LiteralPath $cwd
    }
    Remove-Item -Path $tmp
}
