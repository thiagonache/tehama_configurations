if(Test-Path $PSScriptRoot/modules/Vela-Utils.psm1) {
  Import-Module $PSScriptRoot/modules/Vela-Utils.psm1 -Force
} else {
  Remove-Item $HOME\AppData\Local\Temp\Vela-Utils.psm1 -ErrorAction SilentlyContinue
  (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/pythian/vela_configurations/master/modules/Vela-Utils.psm1', "$HOME\AppData\Local\Temp\Vela-Utils.psm1")
  Import-Module $HOME\AppData\Local\Temp\Vela-Utils.psm1 -Force
}

# Searchable list of apps available by running 'choco search <packagename>'
$apps = @(
  "putty",
  "git",
  "python",
  "visualstudiocode",
  "terraform",
  "postman",
  "grepwin",
  "jq",
  "wget",
  "curl",
  "webstorm",
  "googlechrome"
)

# Searchable list of Python packages available by running 'pip3 search <packagename>'
$pip_packages = @(
  "awscli",
  "ipython"
)

# Searchable list of windows features available by running 'Get-WindowsFeature'
# or via cli by 'lsget-windowsfeature'.
$windows_features = @(
  "Telnet-Client"
) 

$remote_files = @{
  "https://downloads.dcos.io/binaries/cli/windows/x86-64/dcos-1.9/dcos.exe" = "C:\ProgramData\chocolatey\bin\dcos.exe";
  # Wox is an Alfred equivalent launcher for Windows: Option + Spacebar
  "https://github.com/Wox-launcher/Wox/releases/download/v1.3.424/Wox-1.3.424.exe" = "C:\ProgramData\chocolatey\bin\Wox.exe"
}

# Ansible client doesn't work on windows outside of cygwin today.
$git_repos = @{
  "https://github.com/ansible/ansible" = "C:\tools\cygwin\opt\ansible"
}

$paths = @(
  "C:\Python36\Scripts\",
  "C:\Python36\",
  "C:\ProgramData\chocolatey\bin",
  "C:\Program Files\Git\cmd",
  "C:\Program Files\Git\usr\bin",
  "C:\Program Files\nodejs\",
  "C:\Program Files (x86)\vim\vim80",
  "C:\Program Files (x86)\Yarn\bin",
  "D:\Users\$($env:UserName)\AppData\Local\Yarn\bin",
  "C:\Program Files (x86)\Microsoft VS Code\bin",
  "C:\tools\cygwin\opt\ansible\bin"
)

Set-VelaWorkspaceConfiguration `
  -Apps $apps `
  -WindowsFeatures $windows_features `
  -RemoteFiles $remote_files `
  -PipPackages $pip_packages `
  -GitRepos $git_repos `
  -Paths $paths

#Start Wox
if (-Not (get-process 'Wox' -ea SilentlyContinue)) {
  Wox.exe
}

Write-Host "`nPress option + space to start an Alfred-like launcher."
