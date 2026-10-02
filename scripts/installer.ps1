# Wyz Toolbox - Application Installer Engine

$ESC = [char]27
$c = @{
    Reset   = "$ESC[0m"
    Bold    = "$ESC[1m"
    Red     = "$ESC[91m"
    Green   = "$ESC[92m"
    Yellow  = "$ESC[93m"
    Blue    = "$ESC[94m"
    Magenta = "$ESC[95m"
    Cyan    = "$ESC[96m"
    White   = "$ESC[97m"
    Gray    = "$ESC[90m"
}

function Install-ToolboxPackage {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [string]$PackageId,

        [Parameter(Mandatory = $false)]
        [int]$CurrentIndex = 1,

        [Parameter(Mandatory = $false)]
        [int]$TotalCount = 1
    )

    Write-Host ""
    Write-Host "$($c.Magenta)+-------------------------------------------------------------------------------------------+$($c.Reset)"
    Write-Host "$($c.Magenta)|$($c.Reset) $($c.Cyan)[$CurrentIndex/$TotalCount]$($c.Reset) $($c.Yellow)INSTALANDO:$($c.Reset) $($c.White)$Name$($c.Reset) $($c.Gray)(ID: $PackageId)$($c.Reset)"
    Write-Host "$($c.Magenta)+-------------------------------------------------------------------------------------------+$($c.Reset)"

    # Preparar comando silencioso do WinGet
    $wingetArgs = @(
        "install",
        "--id", $PackageId,
        "--exact",
        "--silent",
        "--source", "winget",
        "--accept-package-agreements",
        "--accept-source-agreements",
        "--disable-interactivity"
    )

    Write-Host "$($c.Gray)Executando: winget $($wingetArgs -join ' ')...$($c.Reset)"
    
    $process = Start-Process -FilePath "winget" -ArgumentList $wingetArgs -NoNewWindow -Wait -PassThru
    $exitCode = $process.ExitCode

    switch ($exitCode) {
        0 {
            Write-Host "$($c.Green)[OK - SUCESSO]$($c.Reset) $Name foi instalado / atualizado com sucesso!"
            return $true
        }
        -1978335189 { # 0x8A15002B: Package already installed and no update available
            Write-Host "$($c.Yellow)[OK - JA INSTALADO]$($c.Reset) $Name ja esta instalado e na versao mais recente."
            return $true
        }
        -1978335215 { # 0x8A150011: Upgrade available or reboot required
            Write-Host "$($c.Green)[OK - SUCESSO]$($c.Reset) $Name processado (reinicio pode ser necessario)."
            return $true
        }
        default {
            Write-Host "$($c.Yellow)[AVISO]$($c.Reset) Modo silencioso retornou codigo: $exitCode. Tentando modo interativo..."
            
            $retryArgs = @(
                "install",
                "--id", $PackageId,
                "--exact",
                "--source", "winget",
                "--accept-package-agreements",
                "--accept-source-agreements"
            )
            $retryProc = Start-Process -FilePath "winget" -ArgumentList $retryArgs -NoNewWindow -Wait -PassThru
            if ($retryProc.ExitCode -eq 0 -or $retryProc.ExitCode -eq -1978335189) {
                Write-Host "$($c.Green)[OK - SUCESSO]$($c.Reset) $Name instalado com sucesso!"
                return $true
            } else {
                Write-Host "$($c.Red)[ERRO]$($c.Reset) Nao foi possivel instalar $Name automaticamente."
                Write-Host "$($c.Gray)Dica: Voce pode rodar manualmente: winget install --id $PackageId$($c.Reset)"
                return $false
            }
        }
    }
}
