$discordDir = "C:\Users\VincentL\AppData\Local\Discord\"
$appFolders = Get-ChildItem -Path $discordDir -Directory -Filter "app-*"
if ($appFolders) {
    # Find the latest folder based on creation time
    $latestFolder = $appFolders | Sort-Object -Property CreationTime -Descending | Select-Object -First 1
    $currentExe = Join-Path $latestFolder.FullName "discord.exe"
    
    # Set GPU preference for the current discord.exe
    if (Test-Path $currentExe) {
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\DirectX\UserGpuPreferences" -Name $currentExe -Value "GpuPreference=1;"
    }
    
    # Remove old discord.exe entries from the registry
    $oldFolders = $appFolders | Where-Object { $_.FullName -ne $latestFolder.FullName }
    $oldExes = $oldFolders | ForEach-Object { Join-Path $_.FullName "discord.exe" }
    foreach ($oldExe in $oldExes) {
        if (Test-Path $oldExe) {
            Remove-ItemProperty -Path "HKCU:\Software\Microsoft\DirectX\UserGpuPreferences" -Name $oldExe -ErrorAction SilentlyContinue
        }
    }
}