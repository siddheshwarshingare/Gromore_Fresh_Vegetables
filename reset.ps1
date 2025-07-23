# Set output encoding to UTF-8
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

Write-Host "$GREEN✅ [Found]$NC Find the Cursor installation path: $cursorAppPath"

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
Write-Host "$BLUE🔍 [Check] $NC Check JS file modification status..."
foreach ($file in $jsFiles) {
if (-not (Test-Path $file)) {
Write-Host "$YELLOW⚠️ [Warning] $NC file does not exist: $(Split-Path $file -Leaf)"
continue
}

$content = Get-Content $file -Raw -ErrorAction SilentlyContinue
if ($content -and $content -notmatch "return crypto\.randomUUID\(\)") {
Write-Host "$BLUE📝 [Need] $NC file needs to be modified: $(Split-Path $file -Leaf)"
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

# Close Cursor process
Write-Host "$BLUE🔄 [Close]$NC Close Cursor process for file modification..."
Stop-AllCursorProcesses -MaxRetries 3 -WaitSeconds 3 | Out-Null

# Create a backup
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupPath = "$env:TEMP\Cursor_JS_Backup_$timestamp"

Write-Host "$BLUE💾 [Backup] $NC Create Cursor JS file backup..."
try {
New-Item -ItemType Directory -Path $backupPath -Force | Out-Null
foreach ($file in $jsFiles) {
if (Test-Path $file) {
$fileName = Split-Path $file -Leaf
Copy-Item $file "$backupPath\$fileName" -Force
}
}
Write-Host "$GREEN✅ [Backup] $NC Backup created successfully: $backupPath"
} catch {
Write-Host "$RED❌ [Error] $NC Failed to create backup: $($_.Exception.Message)"
return $false
}

# Modify JS file
Write-Host "$BLUE🔧 [Modify] $NC Start modifying JS file..."

foreach ($file in $jsFiles) {
if (-not (Test-Path $file)) {
Write-Host "$YELLOW⚠️ [Skip]$NC file does not exist: $(Split-Path $file -Leaf)"
continue
}

Write-Host "$BLUE📝 [Processing]$NC Processing: $(Split-Path $file -Leaf)"

try {
$content = Get-Content $file -Raw -Encoding UTF8

# Check if it has been modified
if ($content -match "return crypto\.randomUUID\(\)" -or $content -match "// Cursor ID modification tool injection") {
Write-Host "$GREEN✅ [Skip]$NC file has been modified"
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

// Override the crypto.randomUUID method
crypto.randomUUID = function() {
return '${newUuid}';
};

// Cover all possible system ID acquisition functions - ES module compatible version
globalThis.getMachineId = function() { return '${machineId}'; };
globalThis.getDeviceId = function() { return '${deviceId}'; };
globalThis.macMachineId = '${macMachineId}';

// Ensure access in different environments