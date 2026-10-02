# Wyz Toolbox - System Tweaks & Maintenance Module

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

function Invoke-ToolboxTweak {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Action
    )

    switch ($Action) {
        "flush_dns" {
            Write-Host "$($c.Yellow)[+] Limpando cache de DNS e redefinindo Winsock...$($c.Reset)"
            try {
                Clear-DnsClientCache -ErrorAction SilentlyContinue
                ipconfig /flushdns | Out-Null
                netsh winsock reset | Out-Null
                Write-Host "$($c.Green)[OK] Cache de DNS limpo e pilha de rede redefinida com sucesso!$($c.Reset)"
            } catch {
                Write-Host "$($c.Red)[ERRO] Falha ao redefinir rede: $_$($c.Reset)"
            }
        }

        "clear_temp" {
            Write-Host "$($c.Yellow)[+] Removendo arquivos temporarios e caches do sistema...$($c.Reset)"
            $tempPaths = @(
                "$env:TEMP",
                "C:\Windows\Temp",
                "C:\Windows\Prefetch"
            )

            $deletedCount = 0
            foreach ($path in $tempPaths) {
                if (Test-Path $path) {
                    Get-ChildItem -Path $path -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
                        try {
                            Remove-Item $_.FullName -Recurse -Force -ErrorAction Stop
                            $deletedCount++
                        } catch {
                            # Arquivos em uso pelo Windows sao ignorados normalmente
                        }
                    }
                }
            }

            # Limpar cache de pacotes temporarios do winget se existir
            $wingetCache = "$env:LOCALAPPDATA\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState"
            if (Test-Path $wingetCache) {
                Get-ChildItem -Path $wingetCache -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
            }

            Write-Host "$($c.Green)[OK] Limpeza concluida! $deletedCount itens temporarios limpos.$($c.Reset)"
        }

        "ultimate_performance" {
            Write-Host "$($c.Yellow)[+] Habilitando Plano de Energia 'Desempenho Maximo' (Ultimate Performance)...$($c.Reset)"
            try {
                $guid = "e9a42b02-d5df-448d-aa00-03f14749eb61"
                $output = powercfg -duplicatescheme $guid 2>&1
                if ($output -match "([0-9a-fA-F\-]{36})") {
                    $newGuid = $matches[1]
                    powercfg -setactive $newGuid | Out-Null
                    Write-Host "$($c.Green)[OK] Plano 'Ultimate Performance' ($newGuid) ativado com sucesso!$($c.Reset)"
                } else {
                    powercfg -setactive $guid 2>&1 | Out-Null
                    Write-Host "$($c.Green)[OK] Plano 'Ultimate Performance' configurado!$($c.Reset)"
                }
            } catch {
                Write-Host "$($c.Red)[ERRO] Nao foi possivel ativar o plano: $_$($c.Reset)"
            }
        }

        "restart_explorer" {
            Write-Host "$($c.Yellow)[+] Reiniciando Windows Explorer...$($c.Reset)"
            try {
                Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
                Start-Sleep -Milliseconds 800
                Start-Process explorer.exe
                Write-Host "$($c.Green)[OK] Windows Explorer reiniciado com sucesso!$($c.Reset)"
            } catch {
                Write-Host "$($c.Red)[ERRO] Falha ao reiniciar Explorer: $_$($c.Reset)"
            }
        }

        "winget_update" {
            Write-Host "$($c.Yellow)[+] Sincronizando e atualizando fontes oficiais do WinGet...$($c.Reset)"
            try {
                winget source update
                Write-Host "$($c.Green)[OK] Fontes do WinGet atualizadas com sucesso!$($c.Reset)"
            } catch {
                Write-Host "$($c.Red)[ERRO] Falha ao atualizar fontes: $_$($c.Reset)"
            }
        }

        "optimize_input" {
            Write-Host "$($c.Yellow)[+] Otimizando Mouse e Teclado (Velocidade e Precisao)...$($c.Reset)"
            try {
                # MOUSE: Velocidade 6/11 (10) e desativar "Aprimorar precisao do ponteiro" (MouseSpeed=0)
                Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseSensitivity" -Value "10"
                Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseSpeed" -Value "0"
                Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseThreshold1" -Value "0"
                Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseThreshold2" -Value "0"

                # TECLADO: Intervalo de repeticao Curto (0) e Taxa Rapida (31)
                Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "KeyboardDelay" -Value "0"
                Set-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name "KeyboardSpeed" -Value "31"

                # Chamar API do Windows para aplicar as alteracoes imediatamente
                $code = @'
                using System;
                using System.Runtime.InteropServices;
                public class WinAPI {
                    [DllImport("user32.dll", SetLastError = true)]
                    public static extern bool SystemParametersInfo(uint uiAction, uint uiParam, uint pvParam, uint fWinIni);
                    [DllImport("user32.dll", SetLastError = true)]
                    public static extern bool SystemParametersInfo(uint uiAction, uint uiParam, int[] pvParam, uint fWinIni);
                }
'@
                Add-Type -TypeDefinition $code -ErrorAction SilentlyContinue
                
                # 113=SPI_SETMOUSESPEED, 4=SPI_SETMOUSE, 23=SPI_SETKEYBOARDDELAY, 11=SPI_SETKEYBOARDSPEED, 3=SPIF_UPDATEINIFILE+SPIF_SENDCHANGE
                [WinAPI]::SystemParametersInfo(113, 0, 10, 3) | Out-Null
                [WinAPI]::SystemParametersInfo(4, 0, [int[]]@(0,0,0), 3) | Out-Null
                [WinAPI]::SystemParametersInfo(23, 0, 0, 3) | Out-Null
                [WinAPI]::SystemParametersInfo(11, 31, 0, 3) | Out-Null

                Write-Host "$($c.Green)[OK] Mouse (Vel. 6, Aceleracao OFF) e Teclado (Atraso Curto, Taxa Rapida) configurados!$($c.Reset)"
            } catch {
                Write-Host "$($c.Red)[ERRO] Falha ao configurar entrada: $_$($c.Reset)"
            }
        }

        default {
            Write-Host "$($c.Red)[!] Acao desconhecida: $Action$($c.Reset)"
        }
    }
}
