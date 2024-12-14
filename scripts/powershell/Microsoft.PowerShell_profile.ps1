Import-Module posh-git

$GitPromptSettings.DefaultPromptWriteStatusFirst = $true
$GitPromptSettings.DefaultPromptBeforeSuffix.Text = '`n$([DateTime]::now.ToString("MM-dd HH:mm:ss"))'
$GitPromptSettings.DefaultPromptBeforeSuffix.ForegroundColor = 0x808080
$GitPromptSettings.DefaultPromptSuffix = ' $((Get-History -Count 1).id + 1)$(">" * ($nestedPromptLevel + 1)) '

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

Register-ArgumentCompleter -Native -CommandName az -ScriptBlock {
    param($commandName, $wordToComplete, $cursorPosition)
    $completion_file = New-TemporaryFile
    $env:ARGCOMPLETE_USE_TEMPFILES = 1
    $env:_ARGCOMPLETE_STDOUT_FILENAME = $completion_file
    $env:COMP_LINE = $wordToComplete
    $env:COMP_POINT = $cursorPosition
    $env:_ARGCOMPLETE = 1
    $env:_ARGCOMPLETE_SUPPRESS_SPACE = 0
    $env:_ARGCOMPLETE_IFS = "`n"
    $env:_ARGCOMPLETE_SHELL = 'powershell'
    az 2>&1 | Out-Null
    Get-Content $completion_file | Sort-Object | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, "ParameterValue", $_)
    }
    Remove-Item $completion_file, Env:\_ARGCOMPLETE_STDOUT_FILENAME, Env:\ARGCOMPLETE_USE_TEMPFILES, Env:\COMP_LINE, Env:\COMP_POINT, Env:\_ARGCOMPLETE, Env:\_ARGCOMPLETE_SUPPRESS_SPACE, Env:\_ARGCOMPLETE_IFS, Env:\_ARGCOMPLETE_SHELL
}

function Activate-Venv {
    # FIXME: Setup env var? Something that maps the $scriptpath appropriately
    $scriptPath = FIXME to ActivateVent.ps1
    & $scriptPath
}

function Download-Files {
    # FIXME: Setup env var? Something that maps the $scriptpath appropriately
    $scriptPath = FIXME to DownloadFiles.ps1
    & $scriptPath
}

function Interactive-Download-Files {
    # FIXME: Setup env var? Something that maps the $scriptpath appropriately
    $scriptPath = FIXME to InteractiveDownloadFiles.ps1
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
function lsh {
    Get-ChildItem -Force @args | less
}
