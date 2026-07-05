$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$sdk = Join-Path $env:LOCALAPPDATA "Android\Sdk"
$adb = Join-Path $sdk "platform-tools\adb.exe"
$emulator = Join-Path $sdk "emulator\emulator.exe"
$flutter = "C:\src\flutter\bin\flutter.bat"
$javaHome = "C:\Program Files\Android\Android Studio\jbr"
$androidApk = Join-Path $root "android\app\build\outputs\apk\debug\app-debug.apk"
$flutterApk = Join-Path $root "flutter\build\app\outputs\flutter-apk\app-debug.apk"

$env:JAVA_HOME = $javaHome
$env:ANDROID_HOME = $sdk
$env:PATH = "$(Join-Path $javaHome 'bin');$(Split-Path $adb);C:\src\flutter\bin;$env:PATH"

function Ensure-File([string]$path, [string]$message) {
    if (-not (Test-Path $path)) {
        throw "$message`nNo se encontró: $path"
    }
}

Ensure-File $adb "No está instalado Android Platform Tools."
Ensure-File $emulator "No está instalado Android Emulator."

if (-not (Test-Path $androidApk)) {
    Write-Host "Compilando EcoMarket..." -ForegroundColor Cyan
    Push-Location (Join-Path $root "android")
    try { & ".\gradlew.bat" assembleDebug } finally { Pop-Location }
    if ($LASTEXITCODE -ne 0) { throw "Falló la compilación de EcoMarket." }
}

if (-not (Test-Path $flutterApk)) {
    Ensure-File $flutter "Flutter no está instalado en C:\src\flutter."
    Write-Host "Compilando Ritmo..." -ForegroundColor Cyan
    Push-Location (Join-Path $root "flutter")
    try { & $flutter build apk --debug } finally { Pop-Location }
    if ($LASTEXITCODE -ne 0) { throw "Falló la compilación de Ritmo." }
}

$device = (& $adb devices) -match "emulator-\d+\s+device"
if (-not $device) {
    Write-Host "Abriendo el Pixel virtual..." -ForegroundColor Cyan
    Start-Process -FilePath $emulator -ArgumentList @(
        "-avd", "INSOD_Pixel_7", "-no-snapshot-load"
    )

    $ready = $false
    for ($attempt = 0; $attempt -lt 36; $attempt++) {
        Start-Sleep -Seconds 5
        $serial = (& $adb devices) | Select-String "emulator-\d+\s+device"
        if ($serial) {
            $boot = (& $adb shell getprop sys.boot_completed 2>$null).Trim()
            if ($boot -eq "1") {
                $ready = $true
                break
            }
        }
        Write-Host "." -NoNewline
    }
    Write-Host
    if (-not $ready) {
        throw "El emulador no arrancó. Activa SVM Mode/AMD-V en la BIOS y vuelve a ejecutar este archivo."
    }
}

Write-Host "Instalando EcoMarket..." -ForegroundColor Cyan
& $adb install -r $androidApk
if ($LASTEXITCODE -ne 0) { throw "No se pudo instalar EcoMarket." }

Write-Host "Instalando Ritmo..." -ForegroundColor Cyan
& $adb install -r $flutterApk
if ($LASTEXITCODE -ne 0) { throw "No se pudo instalar Ritmo." }

& $adb shell am force-stop com.agmgneila.ecomarket
& $adb shell am start -n com.agmgneila.ecomarket/.MainActivity

Write-Host
Write-Host "LISTO: EcoMarket está abierto y Ritmo está instalado en el menú del Pixel." -ForegroundColor Green
Write-Host "EcoMarket: admin@ecomarket.es / admin"
Write-Host "Para abrir Ritmo, desliza hacia arriba en el Pixel y pulsa su icono."
