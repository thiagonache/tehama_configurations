if(Test-Path $PSScriptRoot/modules/Vela-Utils.psm1) {
  Import-Module $PSScriptRoot/modules/Vela-Utils.psm1 -Force
} else {
  Remove-Item $HOME\AppData\Local\Temp\Vela-Utils.psm1 -ErrorAction SilentlyContinue
  (New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/pythian/vela_configurations/master/modules/Vela-Utils.psm1', "$HOME\AppData\Local\Temp\Vela-Utils.psm1")
  Import-Module $HOME\AppData\Local\Temp\Vela-Utils.psm1 -Force
}

# Searchable list of apps available by running 'choco search <packagename>'
$apps = @(
  "7zip",
  "jdk8",
  "git",
  "vim",
  "conemu",
  "python",
  "notepadplusplus",
  "sublimetext3",
  "mysql.workbench",
  "cygwin",
  "winscp",
  "cyberduck",
  "grepwin",
  "jq",
  "wget",
  "curl",
  "googlechrome",
  "virtualbox",  # Only supports 32-bit guests on workspaces
  "vagrant",
  "slack"
)

# Searchable list of Python packages available by running 'pip3 search <packagename>'
$pip_packages = @(
  "awscli"
)

# Searchable list of windows features available by running 'Get-WindowsFeature'
$windows_features = @(
  "Telnet-Client"
)

$remote_files = @{
  # Wox is an Alfred equivalent launcher for Windows: Option + Spacebar
  "https://github.com/Wox-launcher/Wox/releases/download/v1.3.424/Wox-1.3.424.exe" = "C:\ProgramData\chocolatey\bin\Wox.exe"
}

# Searchable list of Cygwin packages available at https://cygwin.com/cgi-bin2/package-grep.cgi
# or via cli in Cygwin by 'apt-cyg searchall <packagename>'
$cygwin_packages = @(
  "tmux",
  "python2",
  "python-pip",
  "openssl",
  "openssh", # Required for ansible ssh
  "openssl-devel",  # Required for ansible
  "python-crypto",  # Required for ansible
  "python-openssl", # Required for ansible
  "python-yaml",    # Required for ansible
  "python-jinja2",   # Required for ansible
  "libffi-devel",   # Required for ansible
  "gcc-g++",   # Required for ansible
  "inetutils"   # Required for ansible
)

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
  "C:\Program Files (x86)\Microsoft VS Code\bin",
  "C:\tools\cygwin\opt\ansible\bin"
)

Set-VelaWorkspaceConfiguration `
  -Apps $apps `
  -WindowsFeatures $windows_features `
  -RemoteFiles $remote_files `
  -PipPackages $pip_packages `
  -CygwinPackages $cygwin_packages `
  -GitRepos $git_repos `
  -Paths $paths

# Copy ansible libs into cygwin python lib folder
if (-Not (Test-Path C:\tools\cygwin\lib\python2.7\ansible)) {
  Copy-Item C:\tools\cygwin\opt\ansible\lib\* C:\tools\cygwin\lib\python2.7 -Recurse
}

#Start Wox
if (-Not (get-process 'Wox' -ea SilentlyContinue)) {
  Wox.exe
}

Write-Host "`nPress option + space to start an Alfred-like launcher."
