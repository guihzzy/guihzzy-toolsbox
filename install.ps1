# Wyz Toolbox - Instalador Web

$ErrorActionPreference = "Stop"
$e = [char]27

Write-Host "$e[96m=================================================$e[0m"
Write-Host "$e[93m Baixando e Iniciando o WYZ TOOLBOX...$e[0m"
Write-Host "$e[96m=================================================$e[0m"

# URL do repositorio no GitHub
$repoName = "guihzzy-toolsbox"
$repoUrl = "https://github.com/guihzzy/$repoName/archive/refs/heads/main.zip"

$tempZip = "$env:TEMP\WyzToolbox_Download.zip"
$extractDir = "$env:TEMP\WyzToolbox_Extracted"

try {
    # Tentar baixar do GitHub
    Invoke-WebRequest -Uri $repoUrl -OutFile $tempZip -UseBasicParsing
    
    # Limpar diretorio antigo se existir
    if (Test-Path $extractDir) {
        Remove-Item -Path $extractDir -Recurse -Force -ErrorAction SilentlyContinue
    }
    
    # Extrair arquivos
    Expand-Archive -Path $tempZip -DestinationPath $extractDir -Force
    
    # Executar o batch file principal
    $batPath = "$extractDir\$repoName-main\WyzToolbox.bat"
    
    if (Test-Path $batPath) {
        Write-Host "$e[92m[OK] Toolbox baixado com sucesso! Iniciando...$e[0m"
        Start-Process cmd.exe -ArgumentList "/c `"$batPath`""
    } else {
        Write-Host "$e[91m[ERRO] Arquivo WyzToolbox.bat nao encontrado no ZIP baixado.$e[0m"
    }
} catch {
    Write-Host "$e[91m[ERRO] Falha ao baixar ou extrair o Toolbox: $_$e[0m"
    Write-Host "$e[93mDICA: Verifique se o repositorio e publico e se o link em install.ps1 esta correto.$e[0m"
}
