# Set the output encoding to UTF-8
$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Color definition
$RED = "`e[31m"
$GREEN = "`e[32m"
$YELLOW = "`e[33m"
$BLUE = "`e[34m"
$NC = "`e[0m"

# Configuration file path
$STORAGE_FILE = "$env:APPDATA\Cursor\User\globalStorage\storage.json"
$BACKUP_DIR = "$env:APPDATA\Cursor\User\globalStorage\backups"

# PowerShell native method to generate random strings
function Generate-RandomString {
param([int]$Length)
$chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
$result = ""
for ($i = 0; $i -lt $Length; $i++) {
$result += $chars[(Get-Random -Maximum $chars.Length)]
}
return $result
}

# Modify the Cursor kernel JS file to bypass device identification (ported from the macOS version)
function Modify-CursorJSFiles {
Write-Host ""
Write-Host "$BLUE🔧 [Kernel modification]$NC Start modifying the Cursor kernel JS file to bypass device identification..."
Write-Host ""

# Windows version Cursor application path
$cursorAppPath = "${env:LOCALAPPDATA}\Programs\Cursor"
if (-not (Test-Path $cursorAppPath)) {
# Try other possible installation paths
$alternatePaths = @(
"${env:ProgramFiles}\Cursor",
"${env:ProgramFiles(x86)}\Cursor",
"${env:USERPROFILE}\AppData\Local\Programs\Cursor"
)

foreach ($path in $alternatePaths) {
if (Test-Path $path) {
$cursorAppPath = $path
break
}
}

if (-not (Test-Path $cursorAppPath)) {
Write-Host "$RED❌ [Error]$NC Cursor application installation path not found"
Write-Host "$YELLOW💡 [Prompt]$NC Please confirm that Cursor has been installed correctly"
return $false
}
}

Write-Host "$GREEN✅ [Discover]$NC Found Cursor installation path: $cursorAppPath"

# Generate a new device identifier
$newUuid = [System.Guid]::NewGuid().ToString().ToLower()
$machineId = "auth0|user_$(Generate-RandomString -Length 32)"
$deviceId = [System.Guid]::NewGuid().ToString().ToLower()
$macMachineId = Generate-RandomString -Length 64

Write-Host "$GREEN🔑 [Generate]$NC A new device identifier has been generated"

# Target JS file list (Windows path)
$jsFiles = @(
"$cursorAppPath\resources\app\out\vs\workbench\api\node\extensionHostProcess.js",
"$cursorAppPath\resources\app\out\main.js",
"$cursorAppPath\resources\app\out\vs\code\node\cliProcessMain.js"
)

$modifiedCount = 0
$needModification = $false

# Check if modification is needed
Write-Host "$BLUE🔍 [Check]$NC Check JS file modification status..."
foreach ($file in $jsFiles) {
if (-not (Test-Path $file)) {
Write-Host "$YELLOW⚠️ [WARNING]$NC file does not exist: $(Split-Path $file -Leaf)"
continue
}

$content = Get-Content $file -Raw -ErrorAction SilentlyContinue
if ($content -and $content -notmatch "return crypto\.randomUUID\(\)") {
Write-Host "$BLUE📝 [Required]$NC file needs to be modified: $(Split-Path $file -Leaf)"
$needModification = $true
break
} else {
Write-Host "$GREEN✅ [Modified]$NC File modified: $(Split-Path $file -Leaf)"
}
}

if (-not $needModification) {
Write-Host "$GREEN✅ [Skip]$NC All JS files have been modified, no need to repeat the operation"
return $true
}

# Close the Cursor process
Write-Host "$BLUE🔄 [Close]$NC Close Cursor process for file modification..."
Stop-AllCursorProcesses -MaxRetries 3 -WaitSeconds 3 | Out-Null

# Create a backup
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupPath = "$env:TEMP\Cursor_JS_Backup_$timestamp"

Write-Host "$BLUE💾 [Backup]$NC Create Cursor JS file backup..."
try {
New-Item -ItemType Directory -Path $backupPath -Force | Out-Null
foreach ($file in $jsFiles) {
if (Test-Path $file) {
$fileName = Split-Path $file -Leaf
Copy-Item $file "$backupPath\$fileName" -Force
}
}
Write-Host "$GREEN✅ [Backup]$NC Backup created successfully: $backupPath"
} catch {
Write-Host "$RED❌ [ERROR]$NC Failed to create backup: $($_.Exception.Message)"
return $false
}

# Modify JS file
Write-Host "$BLUE🔧 [Modify]$NC Start modifying JS file..."

foreach ($file in $jsFiles) {
if (-not (Test-Path $file)) {
Write-Host "$YELLOW⚠️ [SKIP]$NC File does not exist: $(Split-Path $file -Leaf)"
continue
}

Write-Host "$BLUE📝 [Processing]$NC Processing: $(Split-Path $file -Leaf)"

try {
$content = Get-Content $file -Raw -Encoding UTF8

# Check if it has been modified
if ($content -match "return crypto\.randomUUID\(\)" -or $content -match "// Cursor ID modification tool injection") {
Write-Host "$GREEN✅ [SKIP]$NC The file has been modified"
$modifiedCount++
continue
}

# ES module compatible JavaScript injection code
$timestampVar = [DateTimeOffset]::Now.ToUnixTimeSeconds()
$injectCode = @"
// Cursor ID modification tool injection - $(Get-Date) - ES module compatible version
import crypto from 'crypto';

// Save the original function reference
const originalRandomUUID_${timestampVar} = crypto.randomUUID;

// Override crypto.randomUUID method
crypto.randomUUID = function() {
return '${newUuid}';
};

// Cover all possible system ID acquisition functions - ES module compatible version
globalThis.getMachineId = function() { return '${machineId}'; };
globalThis.getDeviceId = function() { return '${deviceId}'; };
globalThis.macMachineId = '${macMachineId}';

// Ensure access in different environments
if (typeof window !== 'undefined') {
window.getMachineId = globalThis.getMachineId;
window.getDeviceId = globalThis.getDeviceId;
window.macMachineId = globalThis.macMachineId;
}

// Ensure that the module is executed at the top level
console.log('Cursor device identifier has been successfully hijacked - ES module version Jianbingguozi (86) Follow the official account [Jianbingguozi roll AI] to exchange more Cursor skills and AI knowledge (scripts are free, follow the official account and join the group to get more skills and big guys)');

"@

# Method 1: Find IOPlatformUUID related functions
if ($content -match "IOPlatformUUID") {
Write-Host "$BLUE🔍 [discovery]$NC found IOPlatformUUID keyword"

# Modify for different function modes
if ($content -match "function a\$") {
$content = $content -replace "function a\$\(t\)\{switch", "function a`$(t){return crypto.randomUUID(); switch"
Write-Host "$GREEN✅ [Success]$NC modified a`$function successfully"
$modifiedCount++
continue
}

# Common injection methods
$content = $injectCode + $content
Write-Host "$GREEN✅ [Success]$NC general injection method modified successfully"
$modifiedCount++
}
# Method 2: Find other device ID related functions
elseif ($content -match "function t\$\(\)" -or $content -match "async function y5") {
Write-Host "$BLUE🔍 [Discovery]$NC Found device ID related functions"

# Modify the MAC address acquisition function
if ($content -match "function t\$\(\)") {
$content = $content -replace "function t\$\(\)\{", "function t`$(){return `"00:00:00:00:00:00`";"
Write-Host "$GREEN✅ [Success]$NC Modify MAC address acquisition function"
}

# Modify the device ID acquisition function
if ($content -match "async function y5") {
$content = $content -replace "async function y5\(t\)\{", "async function y5(t){return crypto.randomUUID();"
Write-Host "$GREEN✅ [Success]$NC Modify device ID acquisition function"
}

$modifiedCount++
}
else {
Write-Host "$YELLOW⚠️ [WARNING] $NC No known device ID function pattern found, using generic injection"
$content = $injectCode + $content
$modifiedCount++
}

# Write the modified content
Set-Content -Path $file -Value $content -Encoding UTF8 -NoNewline
Write-Host "$GREEN✅ [Completed]$NC File modification completed: $(Split-Path $file -Leaf)"

} catch {
Write-Host "$RED❌ [ERROR]$NC Failed to modify file: $($_.Exception.Message)"
# Try to restore from backup
$fileName = Split-Path $file -Leaf
$backupFile = "$backupPath\$fileName"
if (Test-Path $backupFile) {
Copy-Item $backupFile $file -Force
Write-Host "$YELLOW🔄 [Restore]$NC has restored the file from backup"
}
}
}

if ($modifiedCount -gt 0) {
Write-Host ""
Write-Host "$GREEN🎉 [Completed]$NC Successfully modified $modifiedCount JS files"
Write-Host "$BLUE💾 [Backup]$NC Original file backup location: $backupPath"
Write-Host "$BLUE💡 [Description]$NC JavaScript injection function has been enabled to bypass device identification"
return $true
} else {
Write-Host "$RED❌ [FAILURE]$NC No files were modified successfully"
return $false
}
}


# 🚀 Added Cursor to prevent Pro from deleting folders
function Remove-CursorTrialFolders {
Write-Host ""
Write-Host "$GREEN🎯 [Core Function]$NC is executing Cursor to prevent the trial Pro from deleting folders..."
Write-Host "$BLUE📋 [Description]$NC This function will delete the specified Cursor related folders to reset the trial status"
Write-Host ""

# Define the folder path to be deleted
$foldersToDelete = @()

# Windows Administrator User Path
$adminPaths = @(
"C:\Users\Administrator\.cursor",
"C:\Users\Administrator\AppData\Roaming\Cursor"
)

# Current user path
$currentUserPaths = @(
"$env:USERPROFILE\.cursor",
"$env:APPDATA\Cursor"
)

# Merge all paths
$foldersToDelete += $adminPaths
$foldersToDelete += $currentUserPaths

Write-Host "$BLUE📂 [Detection]$NC will check the following folders:"
foreach ($folder in $foldersToDelete) {
Write-Host " 📁 $folder"
}
Write-Host ""

$deletedCount = 0
$skippedCount = 0
$errorCount = 0

# Delete the specified folder
foreach ($folder in $foldersToDelete) {
Write-Host "$BLUE🔍 [check]$NC Check folder: $folder"

if (Test-Path $folder) {
try {
Write-Host "$YELLOW⚠️ [Warning]$NC Found folder exists, deleting..."
Remove-Item -Path $folder -Recurse -Force -ErrorAction Stop
Write-Host "$GREEN✅ [Success]$NC Deleted folder: $folder"
$deletedCount++
}
catch {
Write-Host "$RED❌ [ERROR]$NC Failed to delete folder: $folder"
Write-Host "$RED💥 [Details]$NC Error message: $($_.Exception.Message)"
$errorCount++
}
} else {
Write-Host "$YELLOW⏭️ [SKIP]$NC Folder does not exist: $folder"
$skippedCount++
}
Write-Host ""
}

# Display operation statistics
Write-Host "$GREEN📊 [Statistics]$NC Operation completion statistics:"
Write-Host "✅ Successfully deleted: $deletedCount folders"
Write-Host "⏭️ Skipped: $skippedCount folders"
Write-Host "❌ Delete failed: $errorCount folders"
Write-Host ""

if ($deletedCount -gt 0) {
Write-Host "$GREEN🎉 [Completed]$NC Cursor Anti-lost Trial Pro folder deletion completed!"

# 🔧 Pre-create necessary directory structures to avoid permission issues
Write-Host "$BLUE🔧 [FIX]$NC Pre-create necessary directory structure to avoid permission issues..."

$cursorAppData = "$env:APPDATA\Cursor"
$cursorLocalAppData = "$env:LOCALAPPDATA\cursor"
$cursorUserProfile = "$env:USERPROFILE\.cursor"

# Create the main directory
try {
if (-not (Test-Path $cursorAppData)) {
New-Item -ItemType Directory -Path $cursorAppData -Force | Out-Null
}
if (-not (Test-Path $cursorUserProfile)) {
New-Item -ItemType Directory -Path $cursorUserProfile -Force | Out-Null
}
Write-Host "$GREEN✅ [Completed]$NC Directory structure pre-creation completed"
} catch {
Write-Host "$YELLOW⚠️ [WARNING] $NC Problem pre-creating directory: $($_.Exception.Message)"
}
} else {
Write-Host "$YELLOW🤔 [Prompt]$NC The folder to be deleted was not found, it may have been cleaned up"
}
Write-Host ""
}

# 🔄 Restart Cursor and wait for the configuration file to be generated
function Restart-CursorAndWait {
Write-Host ""
Write-Host "$GREEN🔄 [Restart]$NC Restarting Cursor to regenerate configuration files..."

if (-not $global:CursorProcessInfo) {
Write-Host "$RED❌ [Error]$NC Cursor process information not found, unable to restart"
return $false
}

$cursorPath = $global:CursorProcessInfo.Path

#Fix: Make sure the path is a string
if ($cursorPath -is [array]) {
$cursorPath = $cursorPath[0]
}

# Verify that the path is not empty
if ([string]::IsNullOrEmpty($cursorPath)) {
Write-Host "$RED❌ [Error]$NC Cursor path is empty"
return $false
}

Write-Host "$BLUE📍 [path]$NC Using path: $cursorPath"

if (-not (Test-Path $cursorPath)) {
Write-Host "$RED❌ [ERROR]$NC Cursor executable does not exist: $cursorPath"

# Try using an alternate path
        $backupPaths = @(
            "$env:LOCALAPPDATA\Programs\cursor\Cursor.exe",
            "$env:PROGRAMFILES\Cursor\Cursor.exe",
            "$env:PROGRAMFILES(X86)\Cursor\Cursor.exe"
        )

        $foundPath = $null
        foreach ($backupPath in $backupPaths) {
            if (Test-Path $backupPath) {
                $foundPath = $backupPath
                Write-Host "$GREEN💡 [发现]$NC 使用备用路径: $foundPath"
                break
            }
        }

        if (-not $foundPath) {
Write-Host "$RED❌ [ERROR]$NC Unable to find valid Cursor executable"
return $false
}

$cursorPath = $foundPath
}

try {
Write-Host "$GREEN🚀 [Start]$NC Starting Cursor..."
$process = Start-Process -FilePath $cursorPath -PassThru -WindowStyle Hidden

Write-Host "$YELLOW⏳ [Wait]$NC Wait 20 seconds for Cursor to fully start and generate configuration files..."
Start-Sleep -Seconds 20

# Check if the configuration file is generated
$configPath = "$env:APPDATA\Cursor\User\globalStorage\storage.json"
$maxWait = 45
$waited = 0

while (-not (Test-Path $configPath) -and $waited -lt $maxWait) {
Write-Host "$YELLOW⏳ [wait]$NC Waiting for configuration file to be generated... ($waited/$maxWait seconds)"
Start-Sleep -Seconds 1
$waited++
}

if (Test-Path $configPath) {
Write-Host "$GREEN✅ [Success]$NC configuration file generated: $configPath"

# Extra wait to ensure the file is fully written
Write-Host "$YELLOW⏳ [Wait]$NC Wait 5 seconds to make sure the configuration file is fully written..."
Start-Sleep -Seconds 5
} else {
Write-Host "$YELLOW⚠️ [WARNING] $NC configuration file was not generated within the expected time"
Write-Host "$BLUE💡 [Tip]$NC You may need to manually start Cursor once to generate the configuration file"
}

# Force close Cursor
Write-Host "$YELLOW🔄 [Close]$NC Closing Cursor for configuration changes..."
if ($process -and -not $process.HasExited) {
$process.Kill()
$process.WaitForExit(5000)
}

# Make sure all Cursor processes are closed
Get-Process -Name "Cursor" -ErrorAction SilentlyContinue | Stop-Process -Force
Get-Process -Name "cursor" -ErrorAction SilentlyContinue | Stop-Process -Force

Write-Host "$GREEN✅ [Completed]$NC Cursor restart process completed"
return $true

} catch {
Write-Host "$RED❌ [Error] $NC Failed to restart Cursor: $($_.Exception.Message)"
Write-Host "$BLUE💡 [debug]$NC Error details: $($_.Exception.GetType().FullName)"
return $false
}
}

# 🔒 Force close all Cursor processes (enhanced version)
function Stop-AllCursorProcesses {
param(
[int]$MaxRetries = 3,
[int]$WaitSeconds = 5
)

Write-Host "$BLUE🔒 [Process Check]$NC is checking and closing all Cursor related processes..."

# Define all possible Cursor process names
$cursorProcessNames = @(
        "Cursor",
        "cursor",
        "Cursor Helper",
        "Cursor Helper (GPU)",
        "Cursor Helper (Plugin)",
        "Cursor Helper (Renderer)",
        "CursorUpdater"
    )

    for ($retry = 1; $retry -le $MaxRetries; $retry++) {
        Write-Host "$BLUE🔍 [检查]$NC 第 $retry/$MaxRetries 次进程检查..."

        $foundProcesses = @()
        foreach ($processName in $cursorProcessNames) {
            $processes = Get-Process -Name $processName -ErrorAction SilentlyContinue
            if ($processes) {
$foundProcesses += $processes
Write-Host "$YELLOW⚠️ [discovered] $NC process: $processName (PID: $($processes.Id -join ', '))"
}
}

if ($foundProcesses.Count -eq 0) {
Write-Host "$GREEN✅ [Success]$NC All Cursor processes have been closed"
return $true
}

Write-Host "$YELLOW🔄 [Close]$NC is closing $($foundProcesses.Count) Cursor processes..."

# Try graceful shutdown first
foreach ($process in $foundProcesses) {
try {
$process.CloseMainWindow() | Out-Null
Write-Host "$BLUE • Graceful Shutdown: $($process.ProcessName) (PID: $($process.Id))$NC"
} catch {
Write-Host "$YELLOW • Graceful shutdown failed: $($process.ProcessName)$NC"
}
}

Start-Sleep -Seconds 3

# Forcefully terminate the running process
foreach ($processName in $cursorProcessNames) {
$processes = Get-Process -Name $processName -ErrorAction SilentlyContinue
if ($processes) {
foreach ($process in $processes) {
try {
Stop-Process -Id $process.Id -Force
Write-Host "$RED • Forced Termination: $($process.ProcessName) (PID: $($process.Id))$NC"
} catch {
Write-Host "$RED • Force termination failed: $($process.ProcessName)$NC"
}
}
}
}

if ($retry -lt $MaxRetries) {
Write-Host "$YELLOW⏳ [Wait]$NC Wait for $WaitSeconds seconds before rechecking..."
Start-Sleep -Seconds $WaitSeconds
}
}

Write-Host "$RED❌ [Failed] $NC Cursor process still running after $MaxRetries attempts"
return $false
}

# 🔐 Check file permissions and lock status
function Test-FileAccessibility {
param(
[string]$FilePath
)

Write-Host "$BLUE🔐 [Permission check]$NC Check file access permissions: $(Split-Path $FilePath -Leaf)"

if (-not (Test-Path $FilePath)) {
Write-Host "$RED❌ [ERROR]$NC file does not exist"
return $false
}

# Check if the file is locked
try {
$fileStream = [System.IO.File]::Open($FilePath, 'Open', 'ReadWrite', 'None')
$fileStream.Close()
Write-Host "$GREEN✅ [permission]$NC file can be read and written, no lock"
return $true
} catch [System.IO.IOException] {
Write-Host "$RED❌ [LOCK]$NC File is locked by another process: $($_.Exception.Message)"
return $false
} catch [System.UnauthorizedAccessException] {
Write-Host "$YELLOW⚠️ [Permissions]$NC File permissions are limited, try to modify permissions..."

# Try to modify file permissions
try {
$file = Get-Item $FilePath
if ($file.IsReadOnly) {
$file.IsReadOnly = $false
Write-Host "$GREEN✅ [Fix] $NC has removed the read-only attribute"
}

# Test again
$fileStream = [System.IO.File]::Open($FilePath, 'Open', 'ReadWrite', 'None')
$fileStream.Close()
Write-Host "$GREEN✅ [Permission]$NC Permission repair successful"
return $true
} catch {
Write-Host "$RED❌ [permissions]$NC Unable to repair permissions: $($_.Exception.Message)"
return $false
}
} catch {
Write-Host "$RED❌ [ERROR]$NC Unknown error: $($_.Exception.Message)"
return $false
}
}

# 🧹 Cursor initialization cleanup function (ported from the old version)
function Invoke-CursorInitialization {
Write-Host ""
Write-Host "$GREEN🧹 [Initialization]$NC Performing Cursor initialization cleanup..."
$BASE_PATH = "$env:APPDATA\Cursor\User"

$filesToDelete = @(
(Join-Path -Path $BASE_PATH -ChildPath "globalStorage\state.vscdb"),
(Join-Path -Path $BASE_PATH -ChildPath "globalStorage\state.vscdb.backup")
)

$folderToCleanContents = Join-Path -Path $BASE_PATH -ChildPath "History"
$folderToDeleteCompletely = Join-Path -Path $BASE_PATH -ChildPath "workspaceStorage"

Write-Host "$BLUE🔍 [debug]$NC base path: $BASE_PATH"

# Delete the specified file
foreach ($file in $filesToDelete) {
Write-Host "$BLUE🔍 [check]$NC Check file: $file"
if (Test-Path $file) {
try {
Remove-Item -Path $file -Force -ErrorAction Stop
Write-Host "$GREEN✅ [Success]$NC Deleted file: $file"
}
catch {
Write-Host "$RED❌ [ERROR] $NC Failed to delete file $file: $($_.Exception.Message)"
}
} else {
Write-Host "$YELLOW⚠️ [SKIP]$NC File does not exist, skip deleting: $file"
}
}

# Clear the contents of the specified folder
Write-Host "$BLUE🔍 [Check]$NC Check the folder to be emptied: $folderToCleanContents"
if (Test-Path $folderToCleanContents) {
try {
Get-ChildItem -Path $folderToCleanContents -Recurse | Remove-Item -Force -Recurse -ErrorAction Stop
Write-Host "$GREEN✅ [Success]$NC Folder contents cleared: $folderToCleanContents"
}
catch {
Write-Host "$RED❌ [ERROR]$NC Failed to clean folder $folderToCleanContents: $($_.Exception.Message)"
}
} else {
Write-Host "$YELLOW⚠️ [SKIP]$NC Folder does not exist, skip clearing: $folderToCleanContents"
}

# Completely delete the specified folder
Write-Host "$BLUE🔍 [Check]$NC Check folder to be deleted: $folderToDeleteCompletely"
if (Test-Path $folderToDeleteCompletely) {
try {
Remove-Item -Path $folderToDeleteCompletely -Recurse -Force -ErrorAction Stop
Write-Host "$GREEN✅ [Success]$NC Deleted folder: $folderToDeleteCompletely"
}
catch {
Write-Host "$RED❌ [ERROR]$NC Failed to delete folder $folderToDeleteCompletely: $($_.Exception.Message)"
}
} else {
Write-Host "$YELLOW⚠️ [SKIP]$NC Folder does not exist, skip deletion: $folderToDeleteCompletely"
}

Write-Host "$GREEN✅ [Completed]$NC Cursor initialization cleanup completed"
Write-Host ""
}

# 🔧 Modify the system registry MachineGuid (ported from the old version)
function Update-MachineGuid {
try {
Write-Host "$BLUE🔧 [Registry]$NC is modifying the system registry MachineGuid..."

# Check if the registry path exists, if not create it
$registryPath = "HKLM:\SOFTWARE\Microsoft\Cryptography"
if (-not (Test-Path $registryPath)) {
Write-Host "$YELLOW⚠️ [WARNING]$NC Registry path does not exist: $registryPath, creating..."
New-Item -Path $registryPath -Force | Out-Null
Write-Host "$GREEN✅ [INFO]$NC registry path created successfully"
}

# Get the current MachineGuid. If it does not exist, use an empty string as the default value.
$originalGuid = ""
try {
$currentGuid = Get-ItemProperty -Path $registryPath -Name MachineGuid -ErrorAction SilentlyContinue
if ($currentGuid) {
$originalGuid = $currentGuid.MachineGuid
Write-Host "$GREEN✅ [INFO]$NC Current registry value:"
Write-Host "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Cryptography"
Write-Host "MachineGuid REG_SZ $originalGuid"
} else {
Write-Host "$YELLOW⚠️ [WARNING]$NC MachineGuid value does not exist, creating a new value"
}
} catch {
Write-Host "$YELLOW⚠️ [Warning] $NC Failed to read registry: $($_.Exception.Message)"
Write-Host "$YELLOW⚠️ [WARNING]$NC will attempt to create a new MachineGuid value"
}

# Create backup file (only if original value exists)
$backupFile = $null
if ($originalGuid) {
$backupFile = "$BACKUP_DIR\MachineGuid_$(Get-Date -Format 'yyyyMMdd_HHmmss').reg"
Write-Host "$BLUE💾 [Backup]$NC Backing up the registry..."
$backupResult = Start-Process "reg.exe" -ArgumentList "export", "`"HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Cryptography`"", "`"$backupFile`"" -NoNewWindow -Wait -PassThru

if ($backupResult.ExitCode -eq 0) {
Write-Host "$GREEN✅ [Backup]$NC registry key has been backed up to: $backupFile"
} else {
Write-Host "$YELLOW⚠️ [WARNING]$NC backup creation failed, continuing..."
$backupFile = $null
}
}

# Generate a new GUID
$newGuid = [System.Guid]::NewGuid().ToString()
Write-Host "$BLUE🔄 [Generate] $NC New MachineGuid: $newGuid"

# Update or create registry values
Set-ItemProperty -Path $registryPath -Name MachineGuid -Value $newGuid -Force -ErrorAction Stop

# Verify Update
$verifyGuid = (Get-ItemProperty -Path $registryPath -Name MachineGuid -ErrorAction Stop).MachineGuid
if ($verifyGuid -ne $newGuid) {
throw "Registry verification failed: updated value ($verifyGuid) does not match expected value ($newGuid)"
}

Write-Host "$GREEN✅ [Success]$NC Registry update successful:"
Write-Host "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Cryptography"
Write-Host "MachineGuid REG_SZ $newGuid"
return $true
}
catch {
Write-Host "$RED❌ [ERROR]$NC Registry operation failed: $($_.Exception.Message)"

# Try to restore the backup (if it exists)
if ($backupFile -and (Test-Path $backupFile)) {
Write-Host "$YELLOW🔄 [Restore]$NC Restoring from backup..."
$restoreResult = Start-Process "reg.exe" -ArgumentList "import", "`"$backupFile`"" -NoNewWindow -Wait -PassThru

if ($restoreResult.ExitCode -eq 0) {
Write-Host "$GREEN✅ [Recovery successful]$NC The original registry value has been restored"
} else {
Write-Host "$RED❌ [Error] $NC restore failed, please manually import the backup file: $backupFile"
}
} else {
Write-Host "$YELLOW⚠️ [Warning]$NC The backup file was not found or the backup creation failed, and cannot be automatically restored"
}

return $false
}
}

# Check configuration files and environment
function Test-CursorEnvironment {
param(
[string]$Mode = "FULL"
)

Write-Host ""
Write-Host "$BLUE🔍 [Environment Check]$NC Checking Cursor environment..."

$configPath = "$env:APPDATA\Cursor\User\globalStorage\storage.json"
$cursorAppData = "$env:APPDATA\Cursor"
$issues = @()

# Check the configuration file
if (-not (Test-Path $configPath)) {
$issues += "Configuration file does not exist: $configPath"
} else {
try {
$content = Get-Content $configPath -Raw -Encoding UTF8 -ErrorAction Stop
$config = $content | ConvertFrom-Json -ErrorAction Stop
Write-Host "$GREEN✅ [Check] $NC configuration file format is correct"
} catch {
$issues += "Configuration file format error: $($_.Exception.Message)"
}
}

# Check the Cursor directory structure
if (-not (Test-Path $cursorAppData)) {
$issues += "Cursor application data directory does not exist: $cursorAppData"
}

# Check Cursor installation
$cursorPaths = @(
"$env:LOCALAPPDATA\Programs\cursor\Cursor.exe",
"$env:PROGRAMFILES\Cursor\Cursor.exe",
"$env:PROGRAMFILES(X86)\Cursor\Cursor.exe"
)

$cursorFound = $false
foreach ($path in $cursorPaths) {
if (Test-Path $path) {
Write-Host "$GREEN✅ [check]$NC Found Cursor installation: $path"
$cursorFound = $true
break
}
}

if (-not $cursorFound) {
$issues += "Cursor installation not found, please confirm that Cursor is installed correctly"
}

# Return the inspection result
if ($issues.Count -eq 0) {
Write-Host "$GREEN✅ [Environmental Check]$NC All checks passed"
return @{ Success = $true; Issues = @() }
} else {
Write-Host "$RED❌ [Environment Check]$NC found $($issues.Count) issues:"
foreach ($issue in $issues) {
Write-Host "$RED • ${issue}$NC"
}
return @{ Success = $false; Issues = $issues }
}
}

# 🛠️ Modify machine code configuration (enhanced version)
function Modify-MachineCodeConfig {
param(
[string]$Mode = "FULL"
)

Write-Host ""
Write-Host "$GREEN🛠️ [Configuration]$NC Modifying machine code configuration..."

$configPath = "$env:APPDATA\Cursor\User\globalStorage\storage.json"

# Enhanced configuration file checking
if (-not (Test-Path $configPath)) {
Write-Host "$RED❌ [ERROR]$NC config file does not exist: $configPath"
Write-Host ""
Write-Host "$YELLOW💡 [Solution]$NC Please try the following steps:"
Write-Host "$BLUE 1️⃣ Manually start the Cursor application $NC"
Write-Host "$BLUE 2️⃣ Waiting for Cursor to fully load (about 30 seconds) $NC"
Write-Host "$BLUE 3️⃣ Close Cursor application $NC"
Write-Host "$BLUE 4️⃣ Rerun this script $NC"
Write-Host ""
Write-Host "$YELLOW⚠️ [alternative]$NC If the problem persists:"
Write-Host "$BLUE • Select the script's 'Reset environment + modify machine code' option $NC"
Write-Host "$BLUE • This option will automatically generate the configuration file $NC"
Write-Host ""

# Provide user choices
$userChoice = Read-Host "Do you want to try to start Cursor to generate a configuration file now? (y/n)"
if ($userChoice -match "^(y|yes)$") {
Write-Host "$BLUE🚀 [Try]$NC Trying to start Cursor..."
return Start-CursorToGenerateConfig
}

return $false
}

# Make sure the process is completely shut down even in machine code-only mode
if ($Mode -eq "MODIFY_ONLY") {
Write-Host "$BLUE🔒 [Safety Check]$NC Even in modify-only mode, you need to ensure that the Cursor process is completely closed"
if (-not (Stop-AllCursorProcesses -MaxRetries 3 -WaitSeconds 3)) {
Write-Host "$RED❌ [Error]$NC Unable to close all Cursor processes, modification may fail"
$userChoice = Read-Host "Do you want to force the continuation? (y/n)"
if ($userChoice -notmatch "^(y|yes)$") {
return $false
}
}
}

# Check file permissions and lock status
if (-not (Test-FileAccessibility -FilePath $configPath)) {
Write-Host "$RED❌ [ERROR]$NC Unable to access configuration file, may be locked or have insufficient permissions"
return $false
}

# Verify the configuration file format and display the structure
try {
Write-Host "$BLUE🔍 [Verification]$NC Check configuration file format..."
$originalContent = Get-Content $configPath -Raw -Encoding UTF8 -ErrorAction Stop
$config = $originalContent | ConvertFrom-Json -ErrorAction Stop
Write-Host "$GREEN✅ [Verification]$NC configuration file format is correct"

# Display the relevant properties in the current configuration file
Write-Host "$BLUE📋 [Current Configuration]$NC Check existing telemetry properties:"
        $telemetryProperties = @('telemetry.machineId', 'telemetry.macMachineId', 'telemetry.devDeviceId', 'telemetry.sqmId')
        foreach ($prop in $telemetryProperties) {
            if ($config.PSObject.Properties[$prop]) {
                $value = $config.$prop
                $displayValue = if ($value.Length -gt 20) { "$($value.Substring(0,20))..." } else { $value }
                Write-Host "$GREEN  ✓ ${prop}$NC = $displayValue"
            } else {
                Write-Host "$YELLOW  - ${prop}$NC (不存在，将创建)"
            }
        }
        Write-Host ""
    } catch {
Write-Host "$RED❌ [ERROR] $NC configuration file format error: $($_.Exception.Message)"
Write-Host "$YELLOW💡 [Suggestion]$NC The configuration file may be damaged. It is recommended to select the 'Reset environment + modify machine code' option"
return $false
}

# Implement atomic file operations and retry mechanism
$maxRetries = 3
$retryCount = 0

while ($retryCount -lt $maxRetries) {
$retryCount++
Write-Host ""
Write-Host "$BLUE🔄 [attempt]$NC modification attempt of $retryCount/$maxRetries..."

try {
# Display operation progress
Write-Host "$BLUE⏳ [Progress]$NC 1/6 - Generating new device identifier..."

# Generate a new ID
$MAC_MACHINE_ID = [System.Guid]::NewGuid().ToString()
$UUID = [System.Guid]::NewGuid().ToString()
$prefixBytes = [System.Text.Encoding]::UTF8.GetBytes("auth0|user_")
$prefixHex = -join ($prefixBytes | ForEach-Object { '{0:x2}' -f $_ })
$randomBytes = New-Object byte[] 32
$rng = [System.Security.Cryptography.RNGCryptoServiceProvider]::new()
$rng.GetBytes($randomBytes)
$randomPart = [System.BitConverter]::ToString($randomBytes) -replace '-',''
$rng.Dispose()
$MACHINE_ID = "${prefixHex}${randomPart}"
$SQM_ID = "{$([System.Guid]::NewGuid().ToString().ToUpper())}"

Write-Host "$GREEN✅ [Progress]$NC 1/6 - Device identifier generation completed"

Write-Host "$BLUE⏳ [PROGRESS]$NC 2/6 - Creating backup directory..."

# Back up the original value (enhanced version)
$backupDir = "$env:APPDATA\Cursor\User\globalStorage\backups"
if (-not (Test-Path $backupDir)) {
New-Item -ItemType Directory -Path $backupDir -Force -ErrorAction Stop | Out-Null
}

$backupName = "storage.json.backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')_retry$retryCount"
$backupPath = "$backupDir\$backupName"

Write-Host "$BLUE⏳ [Progress]$NC 3/6 - Backing up original configuration..."
Copy-Item $configPath $backupPath -ErrorAction Stop

# Verify that the backup was successful
if (Test-Path $backupPath) {
$backupSize = (Get-Item $backupPath).Length
$originalSize = (Get-Item $configPath).Length
if ($backupSize -eq $originalSize) {
Write-Host "$GREEN✅ [Progress]$NC 3/6 - Configuration backup successful: $backupName"
} else {
Write-Host "$YELLOW⚠️ [WARNING] $NC backup file size mismatch, but continue"
}
} else {
throw "Backup file creation failed"
}

Write-Host "$BLUE⏳ [Progress]$NC 4/6 - Reading raw configuration into memory..."

# Atomic operation: read the original content into memory
$originalContent = Get-Content $configPath -Raw -Encoding UTF8 -ErrorAction Stop
$config = $originalContent | ConvertFrom-Json -ErrorAction Stop

Write-Host "$BLUE⏳ [PROGRESS]$NC 5/6 - Updating configuration in memory..."

# Update configuration values (safe way, make sure the property exists)
$propertiesToUpdate = @{
'telemetry.machineId' = $MACHINE_ID
'telemetry.macMachineId' = $MAC_MACHINE_ID
'telemetry.devDeviceId' = $UUID
'telemetry.sqmId' = $SQM_ID
}

foreach ($property in $propertiesToUpdate.GetEnumerator()) {
$key = $property.Key
$value = $property.Value

# Safe way to use Add-Member or direct assignment
if ($config.PSObject.Properties[$key]) {
# If the attribute exists, update it directly
$config.$key = $value
Write-Host "$BLUE ✓ Update property: ${key}$NC"
} else {
# The attribute does not exist, add a new attribute
$config | Add-Member -MemberType NoteProperty -Name $key -Value $value -Force
Write-Host "$BLUE + Add Attribute: ${key}$NC"
}
}

Write-Host "$BLUE⏳ [PROGRESS]$NC 6/6 - Atomically writing new configuration file..."

# Atomic operation: delete the original file and write a new file
$tempPath = "$configPath.tmp"
$updatedJson = $config | ConvertTo-Json -Depth 10

# Write to temporary file
[System.IO.File]::WriteAllText($tempPath, $updatedJson, [System.Text.Encoding]::UTF8)

# Verify temporary file
$tempContent = Get-Content $tempPath -Raw -Encoding UTF8
$tempConfig = $tempContent | ConvertFrom-Json

# Verify that all properties are written correctly
$tempVerificationPassed = $true
foreach ($property in $propertiesToUpdate.GetEnumerator()) {
$key = $property.Key
$expectedValue = $property.Value
$actualValue = $tempConfig.$key

if ($actualValue -ne $expectedValue) {
$tempVerificationPassed = $false
Write-Host "$RED ✗ Temporary file verification failed: ${key}$NC"
break
}
}

if (-not $tempVerificationPassed) {
Remove-Item $tempPath -Force -ErrorAction SilentlyContinue
throw "Temporary file verification failed"
}

# Atomic replacement: delete the original file and rename the temporary file
Remove-Item $configPath -Force
Move-Item $tempPath $configPath

# Set the file to read-only (optional)
$file = Get-Item $configPath
$file.IsReadOnly = $false # Keep it writable for subsequent modification

# Final verification of modification results
Write-Host "$BLUE🔍 [Final Verification]$NC Verify new configuration file..."

            $verifyContent = Get-Content $configPath -Raw -Encoding UTF8
            $verifyConfig = $verifyContent | ConvertFrom-Json

            $verificationPassed = $true
            $verificationResults = @()

            # 安全验证每个属性
            foreach ($property in $propertiesToUpdate.GetEnumerator()) {
                $key = $property.Key
                $expectedValue = $property.Value
                $actualValue = $verifyConfig.$key

                if ($actualValue -eq $expectedValue) {
                    $verificationResults += "✓ ${key}: 验证通过"
                } else {
$verificationResults += "✗ ${key}: verification failed (expected: ${expectedValue}, actual: ${actualValue})"
$verificationPassed = $false
}
}

# Display verification results
Write-Host "$BLUE📋 [verification details]$NC"
foreach ($result in $verificationResults) {
Write-Host " $result"
}

if ($verificationPassed) {
Write-Host "$GREEN✅ [Success]$NC modification succeeded after $retryCount attempts!"
Write-Host ""
Write-Host "$GREEN🎉 [Complete]$NC Machine code configuration modification completed!"
Write-Host "$BLUE📋 [Details]$NC has updated the following identifiers:"
Write-Host " 🔹 machineId: $MACHINE_ID"
Write-Host " 🔹 macMachineId: $MAC_MACHINE_ID"
Write-Host "🔹 devDeviceId: $UUID"
Write-Host "🔹 sqmId: $SQM_ID"
Write-Host ""
Write-Host "$GREEN💾 [Backup]$NC The original configuration has been backed up to: $backupName"

# 🔒 Add configuration file protection mechanism
Write-Host "$BLUE🔒 [Protection]$NC Setting up configuration file protection..."
try {
$configFile = Get-Item $configPath
$configFile.IsReadOnly = $true
Write-Host "$GREEN✅ [Protection]$NC The configuration file has been set to read-only to prevent the Cursor from overwriting and modifying it"
Write-Host "$BLUE💡 [prompt]$NC file path: $configPath"
} catch {
Write-Host "$YELLOW⚠️ [Protection]$NC Failed to set read-only attribute: $($_.Exception.Message)"
Write-Host "$BLUE💡 [Suggestion]$NC You can manually right-click the file → Properties → Check 'Read-only'"
}
Write-Host "$BLUE 🔒 [Security]$NC It is recommended to restart Cursor to ensure the configuration takes effect"
return $true
} else {
Write-Host "$RED❌ [FAILURE]$NC Authentication failed after $retryCount attempts"
if ($retryCount -lt $maxRetries) {
Write-Host "$BLUE🔄 [Restore]$NC Restore backup, ready to retry..."
Copy-Item $backupPath $configPath -Force
Start-Sleep -Seconds 2
continue # Continue to the next retry
} else {
Write-Host "$RED❌ [Final Failure]$NC All retries failed, restore original configuration"
Copy-Item $backupPath $configPath -Force
return $false
}
}

} catch {
Write-Host "$RED❌ [Exception]$NC Exception occurred on $retryCount attempt: $($_.Exception.Message)"
Write-Host "$BLUE💡 [debug info]$NC Error type: $($_.Exception.GetType().FullName)"

# Clean up temporary files
if (Test-Path "$configPath.tmp") {
Remove-Item "$configPath.tmp" -Force -ErrorAction SilentlyContinue
}

if ($retryCount -lt $maxRetries) {
Write-Host "$BLUE🔄 [Restore]$NC Restore backup, ready to retry..."
if (Test-Path $backupPath) {
Copy-Item $backupPath $configPath -Force
}
Start-Sleep -Seconds 3
continue # Continue to the next retry
} else {
Write-Host "$RED❌ [Final Failure]$NC All retries failed"
# Try to restore the backup
if (Test-Path $backupPath) {
Write-Host "$BLUE🔄 [Restore]$NC Restoring backup configuration..."
try {
Copy-Item $backupPath $configPath -Force
Write-Host "$GREEN✅ [Restore]$NC has restored the original configuration"
} catch {
Write-Host "$RED❌ [ERROR]$NC Failed to restore backup: $($_.Exception.Message)"
}
}
return $false
}
}
}

# If you reach here, it means all retries have failed
Write-Host "$RED❌ [Final Failure]$NC Unable to complete modification after $maxRetries attempts"
return $false

}

# Start Cursor to generate configuration files
function Start-CursorToGenerateConfig {
Write-Host "$BLUE🚀 [Startup]$NC is trying to start Cursor to generate configuration file..."

# Find the Cursor executable file
$cursorPaths = @(
"$env:LOCALAPPDATA\Programs\cursor\Cursor.exe",
"$env:PROGRAMFILES\Cursor\Cursor.exe",
"$env:PROGRAMFILES(X86)\Cursor\Cursor.exe"
)

$cursorPath = $null
foreach ($path in $cursorPaths) {
if (Test-Path $path) {
$cursorPath = $path
break
}
}

if (-not $cursorPath) {
Write-Host "$RED❌ [Error]$NC Cursor installation not found, please confirm that Cursor is correctly installed"
return $false
}

try {
Write-Host "$BLUE📍 [path]$NC Use Cursor path: $cursorPath"

# Start Cursor
$process = Start-Process -FilePath $cursorPath -PassThru -WindowStyle Normal
Write-Host "$GREEN🚀 [Start]$NC Cursor has started, PID: $($process.Id)"

Write-Host "$YELLOW⏳ [Wait]$NC Please wait for the Cursor to load completely (about 30 seconds)..."
Write-Host "$BLUE💡 [Tip]$NC You can manually close the Cursor after it is fully loaded"

# Wait for the configuration file to be generated
$configPath = "$env:APPDATA\Cursor\User\globalStorage\storage.json"
$maxWait = 60
$waited = 0

while (-not (Test-Path $configPath) -and $waited -lt $maxWait) {
Start-Sleep -Seconds 2
$waited += 2
if ($waited % 10 -eq 0) {
Write-Host "$YELLOW⏳ [wait]$NC Waiting for configuration file to be generated... ($waited/$maxWait seconds)"
}
}

if (Test-Path $configPath) {
Write-Host "$GREEN✅ [Success]$NC configuration file has been generated!"
Write-Host "$BLUE💡 [Tip]$NC You can now close the Cursor and rerun the script"
return $true
} else {
Write-Host "$YELLOW⚠️ [Timeout]$NC configuration file was not generated within the expected time"
Write-Host "$BLUE💡 [Suggestion]$NC Please manually operate the Cursor (such as creating a new file) to trigger configuration generation"
return $false
}

} catch {
Write-Host "$RED❌ [Error] $NC Failed to start Cursor: $($_.Exception.Message)"
return $false
}
}

# Check administrator privileges
function Test-Administrator {
$user = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($user)
return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Test-Administrator)) {
Write-Host "$RED[error]$NC Please run this script as an administrator"
Write-Host "Right-click the script and select 'Run as Administrator'"
Read-Host "Press Enter to exit"
exit 1
}

# Display Logo
Clear-Host
Write-Host @"

██████╗██╗ ██╗██████╗ ███████╗ ██████╗ ██████╗
██╔════╝██║ ██║██╔══██╗██╔════╝██╔═══██╗██╔══██╗
██║ ██║ ██║██████╔╝██████╗██║ ██║██████╔╝
██║ ██║ ██║██╔══██╗╚════██║██║ ██║██╔══██╗
╚██████╗╚██████╔╝██║ ██║███████║╚██████╔╝██║ ██║
╚═════╝ ╚═════╝ ╚═╝ ╚═╝╚══════╝ ╚═╝ ╚═╝ ╚═╝

"@
Write-Host "$BLUE================================$NC"
Write-Host "$GREEN🚀 Cursor Anti-drop Trial Pro Deletion Tool $NC"
Write-Host "$YELLOW📱 Follow the public account [Jianbing Guozijuan AI] $NC"
Write-Host "$YELLOW🤝 Let's exchange more Cursor skills and AI knowledge (scripts are free, follow the public account and join the group for more skills and big guys) $NC"
Write-Host "$YELLOW💡 [Important Tips] This tool is free. If it is helpful to you, please follow the public account [Jianbing Guozijuan AI] $NC"
Write-Host ""
Write-Host "$YELLOW💰 [Small Advertisement] Selling CursorPro Education Number with one year warranty and three months warranty. If you need it, please contact me (86), WeChat: JavaRookie666 $NC"
Write-Host "$BLUE================================$NC"

# 🎯 User selection menu
Write-Host ""
Write-Host "$GREEN🎯 [select mode]$NC Please select the operation you want to perform:"
Write-Host ""
Write-Host "$BLUE 1️⃣ only modify machine code $NC"
Write-Host "$YELLOW • Execute machine code modification function $NC"
Write-Host "$YELLOW • Execute injection cracked JS code into the core file $NC"
Write-Host "$YELLOW • Skip folder deletion/environment reset step $NC"
Write-Host "$YELLOW • Keep existing Cursor configuration and data $NC"
Write-Host ""
Write-Host "$BLUE 2️⃣ Reset environment + modify machine code $NC"
Write-Host "$RED • Perform a complete environment reset (delete Cursor folder) $NC"
Write-Host "$RED • ⚠️ Configuration will be lost, please remember to back up $NC"
Write-Host "$YELLOW • Modify $NC according to machine code"
Write-Host "$YELLOW • Execute injection cracked JS code into the core file $NC"
Write-Host "$YELLOW • This is equivalent to the current full script behavior of $NC"
Write-Host ""

# Get user selection
do {
$userChoice = Read-Host "Please enter your choice (1 or 2)"
if ($userChoice -eq "1") {
Write-Host "$GREEN✅ [Select]$NC You selected: Modify machine code only"
$executeMode = "MODIFY_ONLY"
break
} elseif ($userChoice -eq "2") {
Write-Host "$GREEN✅ [Select]$NC You selected: Reset environment + modify machine code"
Write-Host "$RED⚠️ [Important Warning]$NC This operation will delete all Cursor configuration files!"
$confirmReset = Read-Host "Are you sure you want to perform a full reset? (Type yes to confirm, press any other key to cancel)"
if ($confirmReset -eq "yes") {
$executeMode = "RESET_AND_MODIFY"
break
} else {
Write-Host "$YELLOW👋 [Cancel]$NC User canceled the reset operation"
continue
}
} else {
Write-Host "$RED❌ [ERROR]$NC Invalid selection, please enter 1 or 2"
}
} while ($true)

Write-Host ""

# 📋 Display execution flow description according to selection
if ($executeMode -eq "MODIFY_ONLY") {
Write-Host "$GREEN📋 [Execution flow]$NC Only modify the machine code mode will be executed as follows:"
Write-Host "$BLUE 1️⃣ Detect Cursor configuration file $NC"
Write-Host "$BLUE 2️⃣ Back up the existing configuration file $NC"
Write-Host "$BLUE 3️⃣ Modify machine code configuration $NC"
Write-Host "$BLUE 4️⃣ Display operation completion information $NC"
Write-Host ""
Write-Host "$YELLOW⚠️ [Note]$NC"
Write-Host "$YELLOW • Will not delete any folders or reset the environment $NC"
Write-Host "$YELLOW • Keep all existing configuration and data $NC"
Write-Host "$YELLOW • The original configuration file will be automatically backed up $NC"
} else {
Write-Host "$GREEN📋 [Execution process]$NC Reset environment + modify machine code mode will be executed as follows:"
Write-Host "$BLUE 1️⃣ Detect and close Cursor process $NC"
Write-Host "$BLUE 2️⃣ Save Cursor program path information $NC"
Write-Host "$BLUE 3️⃣ Delete the specified Cursor trial related folder $NC"
Write-Host "$BLUE 📁 C:\Users\Administrator\.cursor$NC"
Write-Host "$BLUE 📁 C:\Users\Administrator\AppData\Roaming\Cursor$NC"
Write-Host "$BLUE 📁 C:\Users\%USERNAME%\.cursor$NC"
Write-Host "$BLUE 📁 C:\Users\%USERNAME%\AppData\Roaming\Cursor$NC"
Write-Host "$BLUE 3.5️⃣ Pre-create necessary directory structure to avoid permission issues$NC"
Write-Host "$BLUE 4️⃣ Restart Cursor to generate a new configuration file $NC"
Write-Host "$BLUE 5️⃣ Waiting for configuration file generation to complete (up to 45 seconds) $NC"
Write-Host "$BLUE 6️⃣ Close Cursor process $NC"
Write-Host "$BLUE 7️⃣ Modify the newly generated machine code configuration file $NC"
Write-Host "$BLUE 8️⃣ Display operation completion statistics $NC"
Write-Host ""
Write-Host "$YELLOW⚠️ [Note]$NC"
Write-Host "$YELLOW • Do not manually operate Cursor$NC during script execution"
Write-Host "$YELLOW • It is recommended to close all Cursor windows before executing $NC"
Write-Host "$YELLOW • After execution, you need to restart Cursor$NC"
Write-Host "$YELLOW • The original configuration file will be automatically backed up to the backups folder $NC"
}
Write-Host ""

# 🤔 User Confirmation
Write-Host "$GREEN🤔 [Confirm]$NC Please confirm that you understand the above execution process"
$confirmation = Read-Host "Do you want to continue? (Enter y or yes to continue, any other key to exit)"
if ($confirmation -notmatch "^(y|yes)$") {
Write-Host "$YELLOW👋 [Exit]$NC User canceled execution, script exited"
Read-Host "Press Enter to exit"
exit 0
}
Write-Host "$GREEN✅ [Confirm]$NC User confirms to continue execution"
Write-Host ""

# Get and display the Cursor version
function Get-CursorVersion {
try {
# Main detection path
$packagePath = "$env:LOCALAPPDATA\\Programs\\cursor\\resources\\app\\package.json"
        
if (Test-Path $packagePath) {
$packageJson = Get-Content $packagePath -Raw | ConvertFrom-Json
if ($packageJson.version) {
Write-Host "$GREEN[info]$NC Currently installed Cursor version: v$($packageJson.version)"
return $packageJson.version
}
}

# Alternate path detection
$altPath = "$env:LOCALAPPDATA\\cursor\\resources\\app\\package.json"
if (Test-Path $altPath) {
$packageJson = Get-Content $altPath -Raw | ConvertFrom-Json
if ($packageJson.version) {
Write-Host "$GREEN[info]$NC Currently installed Cursor version: v$($packageJson.version)"
return $packageJson.version
}
}

Write-Host "$YELLOW[WARNING]$NC Unable to detect Cursor version"
Write-Host "$YELLOW[prompt]$NC Please make sure Cursor is installed correctly"
return $null
}
catch {
Write-Host "$RED[ERROR]$NC Failed to get Cursor version: $_"
return $null
}
}

# Get and display version information
$cursorVersion = Get-CursorVersion
Write-Host ""

Write-Host "$YELLOW💡 [Important Tip]$NC latest 1.0.x version already supports"

Write-Host ""

# 🔍 Check and close the Cursor process
Write-Host "$GREEN🔍 [check]$NC Checking Cursor process..."

function Get-ProcessDetails {
param($processName)
Write-Host "$BLUE🔍 [debug]$NC Getting $processName process details:"
Get-WmiObject Win32_Process -Filter "name='$processName'" |
Select-Object ProcessId, ExecutablePath, CommandLine |
Format-List
}

# Define the maximum number of retries and waiting time
$MAX_RETRIES = 5
$WAIT_TIME = 1

# 🔄 Process process shutdown and save process information
function Close-CursorProcessAndSaveInfo {
param($processName)

$global:CursorProcessInfo = $null

$processes = Get-Process -Name $processName -ErrorAction SilentlyContinue
if ($processes) {
Write-Host "$YELLOW⚠️ [Warning] $NC found $processName running"

# 💾 Save process information for subsequent restarts - Fix: Ensure a single process path is obtained
$firstProcess = if ($processes -is [array]) { $processes[0] } else { $processes }
$processPath = $firstProcess.Path

# Make sure the path is a string and not an array
if ($processPath -is [array]) {
$processPath = $processPath[0]
}

$global:CursorProcessInfo = @{
ProcessName = $firstProcess.ProcessName
Path = $processPath
StartTime = $firstProcess.StartTime
}
Write-Host "$GREEN💾 [Save]$NC Saved process information: $($global:CursorProcessInfo.Path)"

Get-ProcessDetails $processName

Write-Host "$YELLOW🔄 [action]$NC Trying to shut down $processName..."
Stop-Process -Name $processName -Force

$retryCount = 0
while ($retryCount -lt $MAX_RETRIES) {
$process = Get-Process -Name $processName -ErrorAction SilentlyContinue
if (-not $process) { break }

$retryCount++
if ($retryCount -ge $MAX_RETRIES) {
Write-Host "$RED❌ [ERROR] $NC failed to shut down $processName after $MAX_RETRIES attempts"
Get-ProcessDetails $processName
Write-Host "$RED💥 [Error]$NC Please manually close the process and try again"
Read-Host "Press Enter to exit"
exit 1
}
Write-Host "$YELLOW⏳ [Wait]$NC Waiting for process to close, trying $retryCount/$MAX_RETRIES..."
Start-Sleep -Seconds $WAIT_TIME
}
Write-Host "$GREEN✅ [Success]$NC $processName successfully closed"
} else {
Write-Host "$BLUE💡 [prompt]$NC did not find the $processName process running"
# Try to find the installation path of Cursor
$cursorPaths = @(
"$env:LOCALAPPDATA\Programs\cursor\Cursor.exe",
"$env:PROGRAMFILES\Cursor\Cursor.exe",
"$env:PROGRAMFILES(X86)\Cursor\Cursor.exe"
)

foreach ($path in $cursorPaths) {
if (Test-Path $path) {
$global:CursorProcessInfo = @{
ProcessName = "Cursor"
Path = $path
StartTime = $null
}
Write-Host "$GREEN💾 [discovery]$NC found Cursor installation path: $path"
break
}
}

if (-not $global:CursorProcessInfo) {
Write-Host "$YELLOW⚠️ [Warning]$NC Cursor installation path not found, default path will be used"
$global:CursorProcessInfo = @{
ProcessName = "Cursor"
Path = "$env:LOCALAPPDATA\Programs\cursor\Cursor.exe"
StartTime = $null
}
}
}
}

# ️ Make sure the backup directory exists
if (-not (Test-Path $BACKUP_DIR)) {
try {
New-Item -ItemType Directory -Path $BACKUP_DIR -Force | Out-Null
Write-Host "$GREEN✅ [backup directory]$NC The backup directory was created successfully: $BACKUP_DIR"
} catch {
Write-Host "$YELLOW⚠️ [WARNING] Failed to create $NC backup directory: $($_.Exception.Message)"
}
}

# 🚀 Execute corresponding functions according to user selection
if ($executeMode -eq "MODIFY_ONLY") {
Write-Host "$GREEN🚀 [Start]$NC Start executing functions that only modify machine code..."

# Perform an environment check first
$envCheck = Test-CursorEnvironment -Mode "MODIFY_ONLY"
if (-not $envCheck.Success) {
Write-Host ""
Write-Host "$RED❌ [Environment Check Failed]$NC Unable to continue execution, the following problems were found:"
foreach ($issue in $envCheck.Issues) {
Write-Host "$RED • ${issue}$NC"
}
Write-Host ""
Write-Host "$YELLOW💡 [Suggestion]$NC Please select the following operation:"
Write-Host "$BLUE 1️⃣ Select the 'Reset environment + modify machine code' option (recommended) $NC"
Write-Host "$BLUE 2️⃣ Manually start Cursor once, then rerun the script $NC"
Write-Host "$BLUE 3️⃣ Check if Cursor is installed correctly $NC"
Write-Host ""
Read-Host "Press Enter to exit"
exit 1
}

# Perform machine code modification
$configSuccess = Modify-MachineCodeConfig -Mode "MODIFY_ONLY"

if ($configSuccess) {
Write-Host ""
Write-Host "$GREEN🎉 [configuration file]$NC Machine code configuration file modification completed!"

# Add registry modification
Write-Host "$BLUE🔧 [Registry]$NC Modifying the system registry..."
$registrySuccess = Update-MachineGuid

# 🔧 New: JavaScript injection function (device identification bypass enhancement)
Write-Host ""
Write-Host "$BLUE🔧 [Device Identification Bypass]$NC is executing JavaScript injection function..."
Write-Host "$BLUE💡 [Description]$NC This function will directly modify the Cursor kernel JS file to achieve a deeper device identification bypass"
$jsSuccess = Modify-CursorJSFiles

if ($registrySuccess) {
Write-Host "$GREEN✅ [Registry]$NC System registry modified successfully"

if ($jsSuccess) {
Write-Host "$GREEN✅ [JavaScript injection]$NC JavaScript injection function executed successfully"
Write-Host ""
Write-Host "$GREEN🎉 [Completed]$NC All machine code modifications completed (enhanced version)!"
Write-Host "$BLUE📋 [Details]$NC has completed the following modifications:"
Write-Host "$GREEN ✓ Cursor configuration file (storage.json)$NC"
Write-Host "$GREEN ✓ System Registry (MachineGuid) $NC"
Write-Host "$GREEN ✓ JavaScript kernel injection (device identification bypass) $NC"
} else {
Write-Host "$YELLOW⚠️ [JavaScript injection] $NC JavaScript injection function failed to execute, but other functions succeeded"
Write-Host ""
Write-Host "$GREEN🎉 [Completed]$NC All machine code modifications completed!"
Write-Host "$BLUE📋 [Details]$NC has completed the following modifications:"
Write-Host "$GREEN ✓ Cursor configuration file (storage.json) $NC"
Write-Host "$GREEN ✓ System Registry (MachineGuid) $NC"
Write-Host "$YELLOW ⚠ JavaScript kernel injection (partial failure) $NC"
}

# 🔒 Add configuration file protection mechanism
Write-Host "$BLUE🔒 [Protection]$NC Setting up configuration file protection..."
try {
$configPath = "$env:APPDATA\Cursor\User\globalStorage\storage.json"
$configFile = Get-Item $configPath
$configFile.IsReadOnly = $true
Write-Host "$GREEN✅ [Protection]$NC The configuration file has been set to read-only to prevent the Cursor from overwriting and modifying it"
Write-Host "$BLUE💡 [prompt]$NC file path: $configPath"
} catch {
Write-Host "$YELLOW⚠️ [Protection]$NC Failed to set read-only attribute: $($_.Exception.Message)"
Write-Host "$BLUE💡 [Suggestion]$NC You can manually right-click the file → Properties → Check 'Read-only'"
}
} else {
Write-Host "$YELLOW⚠️ [Registry]$NC Registry modification failed, but configuration file modification succeeded"

if ($jsSuccess) {
Write-Host "$GREEN✅ [JavaScript injection]$NC JavaScript injection function executed successfully"
Write-Host ""
Write-Host "$YELLOW🎉 [Partially completed]$NC Configuration file and JavaScript injection completed, registry modification failed"
Write-Host "$BLUE💡 [Suggestion]$NC may require administrator privileges to modify the registry"
Write-Host "$BLUE📋 [Details]$NC has completed the following modifications:"
Write-Host "$GREEN ✓ Cursor configuration file (storage.json)$NC"
Write-Host "$YELLOW ⚠ System Registry (MachineGuid) - Failed $NC"
Write-Host "$GREEN ✓ JavaScript kernel injection (device identification bypass) $NC"
} else {
Write-Host "$YELLOW⚠️ [JavaScript injection] $NC JavaScript injection function execution failed"
Write-Host ""
Write-Host "$YELLOW🎉 [Partially completed]$NC Configuration file modification completed, registry and JavaScript injection failed"
Write-Host "$BLUE💡 [Suggestion]$NC may require administrator privileges to modify the registry"
}

# 🔒 Protect configuration files even if registry modification fails
Write-Host "$BLUE🔒 [Protection]$NC Setting up configuration file protection..."
try {
$configPath = "$env:APPDATA\Cursor\User\globalStorage\storage.json"
$configFile = Get-Item $configPath
$configFile.IsReadOnly = $true
Write-Host "$GREEN✅ [Protection]$NC The configuration file has been set to read-only to prevent the Cursor from overwriting and modifying it"
Write-Host "$BLUE💡 [prompt]$NC file path: $configPath"
} catch {
Write-Host "$YELLOW⚠️ [Protection]$NC Failed to set read-only attribute: $($_.Exception.Message)"
Write-Host "$BLUE💡 [Suggestion]$NC You can manually right-click the file → Properties → Check 'Read-only'"
}
}

Write-Host "$BLUE💡 [Prompt]$NC can now start Cursor using the new machine code configuration"
} else {
Write-Host ""
Write-Host "$RED❌ [Failed]$NC Machine code modification failed!"
Write-Host "$YELLOW💡 [Suggestion]$NC Please try the 'Reset environment + modify machine code' option"
}
} else {
# Complete reset environment + modify machine code process
Write-Host "$GREEN🚀 [Start]$NC Start to execute the reset environment + modify the machine code function..."

# 🚀 Close all Cursor processes and save information
Close-CursorProcessAndSaveInfo "Cursor"
if (-not $global:CursorProcessInfo) {
Close-CursorProcessAndSaveInfo "cursor"
}

# 🚨 Important Warnings
Write-Host ""
Write-Host "$RED🚨 [IMPORTANT WARNING]$NC =============================================="
Write-Host "$YELLOW⚠️ [Risk Control Reminder] $NC Cursor risk control mechanism is very strict!"
Write-Host "$YELLOW⚠️ [Must delete]$NC The specified folder must be completely deleted without any residual settings"
Write-Host "$YELLOW⚠️ [Prevent trial loss]$NC Only thorough cleaning can effectively prevent the trial Pro status from being lost"
Write-Host "$RED🚨 [IMPORTANT WARNING]$NC =============================================="
Write-Host ""

# 🎯 Execute Cursor to prevent the trial Pro from deleting folders
Write-Host "$GREEN🚀 [Start]$NC Start executing core functions..."
Remove-CursorTrialFolders



# 🔄 Restart Cursor to regenerate the configuration file
Restart-CursorAndWait

# 🛠️ Modify machine code configuration
$configSuccess = Modify-MachineCodeConfig
    
# 🧹 Execute Cursor initialization cleanup
Invoke-CursorInitialization

if ($configSuccess) {
Write-Host ""
Write-Host "$GREEN🎉 [configuration file]$NC Machine code configuration file modification completed!"

# Add registry modification
Write-Host "$BLUE🔧 [Registry]$NC Modifying the system registry..."
$registrySuccess = Update-MachineGuid

# 🔧 New: JavaScript injection function (device identification bypass enhancement)
Write-Host ""
Write-Host "$BLUE🔧 [Device Identification Bypass]$NC is executing JavaScript injection function..."
Write-Host "$BLUE💡 [Description]$NC This function will directly modify the Cursor kernel JS file to achieve a deeper device identification bypass"
$jsSuccess = Modify-CursorJSFiles

if ($registrySuccess) {
Write-Host "$GREEN✅ [Registry]$NC System registry modified successfully"

if ($jsSuccess) {
Write-Host "$GREEN✅ [JavaScript injection]$NC JavaScript injection function executed successfully"
Write-Host ""
Write-Host "$GREEN🎉 [Complete]$NC All operations completed (enhanced version)!"
Write-Host "$BLUE📋 [Details]$NC has completed the following operations:"
Write-Host "$GREEN ✓ Delete Cursor trial related folders $NC"
Write-Host "$GREEN ✓ Cursor Initialize Cleanup $NC"
Write-Host "$GREEN ✓ Regenerate configuration file $NC"
Write-Host "$GREEN ✓ Modify machine code configuration $NC"
Write-Host "$GREEN ✓ Modify the system registry $NC"
Write-Host "$GREEN ✓ JavaScript kernel injection (device identification bypass) $NC"
} else {
Write-Host "$YELLOW⚠️ [JavaScript injection] $NC JavaScript injection function failed to execute, but other functions succeeded"
Write-Host ""
Write-Host "$GREEN🎉 [Done]$NC All operations completed!"
Write-Host "$BLUE📋 [Details]$NC has completed the following operations:"
Write-Host "$GREEN ✓ Delete Cursor trial related folders $NC"
Write-Host "$GREEN ✓ Cursor Initialize Cleanup $NC"
Write-Host "$GREEN ✓ Regenerate configuration file $NC"
Write-Host "$GREEN ✓ Modify machine code configuration $NC"
Write-Host "$GREEN ✓ Modify the system registry $NC"
Write-Host "$YELLOW ⚠ JavaScript kernel injection (partial failure) $NC"
}

# 🔒 Add configuration file protection mechanism
Write-Host "$BLUE🔒 [Protection]$NC Setting up configuration file protection..."
try {
$configPath = "$env:APPDATA\Cursor\User\globalStorage\storage.json"
$configFile = Get-Item $configPath
$configFile.IsReadOnly = $true
Write-Host "$GREEN✅ [Protection]$NC The configuration file has been set to read-only to prevent the Cursor from overwriting and modifying it"
Write-Host "$BLUE💡 [prompt]$NC file path: $configPath"
} catch {
Write-Host "$YELLOW⚠️ [Protection]$NC Failed to set read-only attribute: $($_.Exception.Message)"
Write-Host "$BLUE💡 [Suggestion]$NC You can manually right-click the file → Properties → Check 'Read-only'"
}
} else {
Write-Host "$YELLOW⚠️ [Registry]$NC Registry modification failed, but other operations succeeded"

if ($jsSuccess) {
Write-Host "$GREEN✅ [JavaScript injection]$NC JavaScript injection function executed successfully"
Write-Host ""
Write-Host "$YELLOW🎉 [Partially completed]$NC Most operations completed, registry modification failed"
Write-Host "$BLUE💡 [Suggestion]$NC may require administrator privileges to modify the registry"
Write-Host "$BLUE📋 [Details]$NC has completed the following operations:"
Write-Host "$GREEN ✓ Delete Cursor trial related folders $NC"
Write-Host "$GREEN ✓ Cursor Initialize Cleanup $NC"
Write-Host "$GREEN ✓ Regenerate configuration file $NC"
Write-Host "$GREEN ✓ Modify machine code configuration $NC"
Write-Host "$YELLOW ⚠ Modify system registry - Failed $NC"
Write-Host "$GREEN ✓ JavaScript kernel injection (device identification bypass) $NC"
} else {
Write-Host "$YELLOW⚠️ [JavaScript injection] $NC JavaScript injection function execution failed"
Write-Host ""
Write-Host "$YELLOW🎉 [Partially completed]$NC Most operations completed, registry and JavaScript injection failed"
Write-Host "$BLUE💡 [Suggestion]$NC may require administrator privileges to modify the registry"
}

# 🔒 Protect configuration files even if registry modification fails
Write-Host "$BLUE🔒 [Protection]$NC Setting up configuration file protection..."
try {
$configPath = "$env:APPDATA\Cursor\User\globalStorage\storage.json"
$configFile = Get-Item $configPath
$configFile.IsReadOnly = $true
Write-Host "$GREEN✅ [Protection]$NC The configuration file has been set to read-only to prevent the Cursor from overwriting and modifying it"
Write-Host "$BLUE💡 [prompt]$NC file path: $configPath"
} catch {
Write-Host "$YELLOW⚠️ [Protection]$NC Failed to set read-only attribute: $($_.Exception.Message)"
Write-Host "$BLUE💡 [Suggestion]$NC You can manually right-click the file → Properties → Check 'Read-only'"
}
}
} else {
Write-Host ""
Write-Host "$RED❌ [Failed]$NC Machine code configuration modification failed!"
Write-Host "$YELLOW💡 [Suggestion]$NC Please check the error message and try again"
}
}


# 📱 Display public account information
Write-Host ""
Write-Host "$GREEN================================$NC"
Write-Host "$YELLOW📱 Follow the public account [Jianbing Guozijuan AI] to exchange more Cursor skills and AI knowledge (scripts are free, follow the public account and join the group to get more skills and big guys) $NC"
Write-Host "$GREEN================================$NC"
Write-Host ""

# 🎉 Script execution completed
Write-Host "$GREEN🎉 [Script completed]$NC Thank you for using Cursor machine code modification tool!"
Write-Host "$BLUE💡 [Tip]$NC If you have any questions, please refer to the official account or re-run the script"
Write-Host ""
Read-Host "Press Enter to exit"
exit 0

