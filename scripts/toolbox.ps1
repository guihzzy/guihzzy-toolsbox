# =============================================================================
# WYZ TOOLBOX - Windows Custom Optimization & App Installer
# Inspirado no Ghost Toolbox com suporte nativo ao WinGet e PowerShell
# =============================================================================

# Definir Codificacao UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$Host.UI.RawUI.WindowTitle = "Administrador: WYZ TOOLBOX v1.0.0 [EDICAO PERSONALIZADA]"

# Carregar modulos auxiliares
# Suporte a execucao via iex/pipe (PSCommandPath) e local (MyInvocation)
$scriptDir = if ($PSScriptRoot -and $PSScriptRoot -ne '') {
    $PSScriptRoot
} elseif ($MyInvocation.MyCommand.Path -and $MyInvocation.MyCommand.Path -ne '') {
    Split-Path -Parent $MyInvocation.MyCommand.Path
} elseif ($PSCommandPath -and $PSCommandPath -ne '') {
    Split-Path -Parent $PSCommandPath
} else {
    # Ultimo recurso: pasta atual
    Get-Location
}
$rootDir    = Split-Path -Parent $scriptDir
$configPath = Join-Path $rootDir "config\apps.json"

. (Join-Path $scriptDir "installer.ps1")
. (Join-Path $scriptDir "tweaks.ps1")

# Carregar configuracao JSON
function Get-ToolboxConfig {
    if (Test-Path $configPath) {
        try {
            $raw = Get-Content -Path $configPath -Raw -Encoding UTF8
            $parsed = $raw | ConvertFrom-Json
            # Validar que tem a estrutura minima esperada
            if ($parsed.columns -and $parsed.columns.Count -ge 2) {
                return $parsed
            }
        } catch {}
    }
    # Fallback embutido - garante que o menu sempre funciona mesmo sem o JSON
    Write-Warning "Usando configuracao padrao interna (apps.json nao encontrado ou invalido)."
    return @'
{
  "appName": "WYZ TOOLBOX",
  "version": "1.0.0",
  "columns": [
    {
      "title": "DEV TOOLS & RUNTIMES",
      "items": [
        { "id": "1",  "name": "Git",            "sub": "Version Control",    "packageId": "Git.Git" },
        { "id": "2",  "name": "Node.js LTS",    "sub": "JS Runtime",         "packageId": "OpenJS.NodeJS.LTS" },
        { "id": "3",  "name": "pnpm",           "sub": "Fast Package Mgr",   "packageId": "pnpm.pnpm" },
        { "id": "4",  "name": "Antigravity IDE","sub": "Agentic IDE",        "packageId": "Google.AntigravityIDE" },
        { "id": "5",  "name": "Antigravity 2.0","sub": "Google AI Center",   "packageId": "Google.Antigravity" },
        { "id": "6",  "name": "VS Code",        "sub": "Visual Studio Code", "packageId": "Microsoft.VisualStudioCode" },
        { "id": "7",  "name": "Python 3.12",    "sub": "64-bit Runtime",     "packageId": "Python.Python.3.12" },
        { "id": "8",  "name": "Visual C++ AIO", "sub": "Runtimes 2005-2022", "packageId": "abbodi1406.vcredist" }
      ]
    },
    {
      "title": "BROWSERS & APPS",
      "items": [
        { "id": "10", "name": "Brave Browser",  "sub": "Privacy Browser",    "packageId": "Brave.Brave" },
        { "id": "11", "name": "Discord",         "sub": "Versao Estavel",     "packageId": "Discord.Discord" },
        { "id": "12", "name": "Discord PTB",     "sub": "Public Test Build",  "packageId": "Discord.Discord.PTB" },
        { "id": "13", "name": "Discord Canary",  "sub": "Alpha Experimental", "packageId": "Discord.Discord.Canary" },
        { "id": "14", "name": "Discord Dev",     "sub": "Development Build",  "packageId": "Discord.Discord.Development" },
        { "id": "15", "name": "Spotify",         "sub": "Musicas e Podcasts", "packageId": "Spotify.Spotify" },
        { "id": "16", "name": "Logitech G HUB",  "sub": "Perifericos e Mouse","packageId": "Logitech.GHUB" },
        { "id": "17", "name": "Google Chrome",   "sub": "Navegador Web",      "packageId": "Google.Chrome" },
        { "id": "18", "name": "7-Zip",           "sub": "Compactador 64-bit", "packageId": "7zip.7zip" }
      ]
    }
  ],
  "combos": [
    { "id": "20", "name": "Discord Full Pack",  "sub": "Stable, PTB, Canary, Dev",         "packageIds": ["Discord.Discord","Discord.Discord.PTB","Discord.Discord.Canary","Discord.Discord.Development"] },
    { "id": "21", "name": "Web Dev Pack",       "sub": "Git, Node LTS, pnpm, VSCode",      "packageIds": ["Git.Git","OpenJS.NodeJS.LTS","pnpm.pnpm","Microsoft.VisualStudioCode"] },
    { "id": "22", "name": "Antigravity Suite",  "sub": "IDE + 2.0 Command Center",         "packageIds": ["Google.AntigravityIDE","Google.Antigravity"] },
    { "id": "23", "name": "Gamer & Audio Pack", "sub": "Logitech, Discord, Spotify",       "packageIds": ["Logitech.GHUB","Discord.Discord","Spotify.Spotify"] },
    { "id": "24", "name": "Pacote Essencial",   "sub": "Brave, 7-Zip, Visual C++",         "packageIds": ["Brave.Brave","7zip.7zip","abbodi1406.vcredist"] },
    { "id": "25", "name": "Pack do Guih",       "sub": "Todos os apps favoritos do Guih",  "packageIds": ["Brave.Brave","Discord.Discord","Discord.Discord.PTB","Discord.Discord.Canary","Discord.Discord.Development","Logitech.GHUB","OpenJS.NodeJS.LTS","pnpm.pnpm","Git.Git","Google.AntigravityIDE","Google.Antigravity","Spotify.Spotify"] },
    { "id": "99", "name": "TODOS OS APPS",      "sub": "Instalar Lista Completa",          "packageIds": "ALL" }
  ],
  "tweaks": [
    { "id": "30", "name": "Flush DNS & Winsock",      "sub": "Redefinir conexao e cache",            "action": "flush_dns" },
    { "id": "31", "name": "Limpar Temp & Cache",       "sub": "Temp, Prefetch e Logs",               "action": "clear_temp" },
    { "id": "32", "name": "Desempenho Maximo",         "sub": "Plano Ultimate Performance",          "action": "ultimate_performance" },
    { "id": "33", "name": "Reiniciar Explorer",        "sub": "Recarrega barra de tarefas",          "action": "restart_explorer" },
    { "id": "34", "name": "Atualizar WinGet",          "sub": "Sincronizar repositorios",            "action": "winget_update" },
    { "id": "35", "name": "Otimizar Mouse & Teclado",  "sub": "Velocidade 6, Aceleracao OFF",        "action": "optimize_input" }
  ]
}
'@ | ConvertFrom-Json
}


# Obter Informacoes do Sistema Operacional
$osInfo = Get-CimInstance Win32_OperatingSystem -ErrorAction SilentlyContinue
$user   = [Environment]::UserName
$pcName = [Environment]::MachineName
$arch   = if ([Environment]::Is64BitOperatingSystem) { "64-bit" } else { "32-bit" }
$osName = if ($osInfo) { $osInfo.Caption -replace "Microsoft ", "" } else { "Windows 11 Pro" }
$build  = if ($osInfo) { $osInfo.BuildNumber } else { "26100" }

# Detectar Timezone
try {
    $tz = (Get-TimeZone).DisplayName
    if ($tz -match "\(UTC([+-]\d{2}:\d{2})\)") {
        $tzStr = "UTC$($matches[1]) | $((Get-TimeZone).StandardName)"
    } else {
        $tzStr = (Get-TimeZone).Id
    }
} catch {
    $tzStr = "UTC-03:00 | Brasilia"
}

# Detectar WinGet
$wingetVer = try {
    $out = & winget --version 2>$null
    if ($out) { "$($c.Green)$($out.Trim())$($c.Reset)" } else { "$($c.Red)AUSENTE$($c.Reset)" }
} catch {
    "$($c.Red)AUSENTE$($c.Reset)"
}

# Funcao de formatacao de item de menu (padronizacao de largura)
function Format-MenuItem {
    param(
        [string]$Number,
        [string]$Title,
        [string]$Sub = "",
        [int]$ColWidth = 53
    )

    $numPadded = $Number.PadLeft(2)
    $cleanPrefix = "[$numPadded] | "
    $cleanBody = $Title
    if ($Sub) { $cleanBody += " ($Sub)" }
    
    $cleanLen = $cleanPrefix.Length + $cleanBody.Length
    $padLen = $ColWidth - $cleanLen
    if ($padLen -lt 0) { 
        # Truncar se ultrapassar a coluna
        $excess = [Math]::Abs($padLen) + 3
        if ($Sub.Length -gt $excess) {
            $Sub = $Sub.Substring(0, $Sub.Length - $excess) + "..."
            $cleanBody = "$Title ($Sub)"
        }
        $cleanLen = $cleanPrefix.Length + $cleanBody.Length
        $padLen = [Math]::Max(0, $ColWidth - $cleanLen)
    }
    $padding = " " * $padLen

    $colored = "$($c.Green)[$($c.Yellow)$numPadded$($c.Green)]$($c.Gray) | $($c.White)$Title"
    if ($Sub) {
        $colored += " $($c.Cyan)($Sub)$($c.Reset)"
    } else {
        $colored += "$($c.Reset)"
    }
    return $colored + $padding
}

# Renderizacao do Menu Principal
function Show-MainMenu {
    Clear-Host
    $cfg = Get-ToolboxConfig

    # Topo Estilo Ghost Spectre Toolbox
    Write-Host "$($c.Magenta)====================================================================================================================$($c.Reset)"
    Write-Host "$($c.Yellow) USER:$($c.Reset) $($c.White)$user$($c.Reset) | $($c.Yellow)COMPUTERNAME:$($c.Reset) $($c.White)$pcName$($c.Reset) | $($c.Yellow)WINGET:$($c.Reset) $wingetVer | $($c.Yellow)ARCH:$($c.Reset) $($c.Green)$arch$($c.Reset) | $($c.Yellow)STATUS:$($c.Reset) $($c.Green)PRONTO$($c.Reset)"
    Write-Host "$($c.Yellow) CURRENT OS:$($c.Reset) $($c.Blue)[$osName]$($c.Reset) $($c.Red)[BUILD $build]$($c.Reset) $($c.Green)[$arch]$($c.Reset) $($c.Magenta)[WYZ CUSTOM EDITION]$($c.Reset)"
    Write-Host "$($c.Yellow) TIME ZONE:$($c.Reset) $($c.Magenta)$tzStr$($c.Reset)"
    Write-Host "$($c.Cyan) WYZ E-COMMERCE TOOLSBOX | CENTRAL DE APLICATIVOS E OTIMIZACOES RAPIDAS$($c.Reset)"
    Write-Host "$($c.Magenta)====================================================================================================================$($c.Reset)"

    # Colunas Superiores: DEV TOOLS vs BROWSERS & APPS
    $col1Title = "DEV TOOLS & RUNTIMES | ESSENTIALS"
    $col2Title = "COMMUNICATION & APPS | BROWSERS"
    
    $c1TitleFmt = "$($c.Cyan)$col1Title$($c.Reset)" + (" " * (59 - $col1Title.Length))
    $c2TitleFmt = "$($c.Cyan)$col2Title$($c.Reset)"
    Write-Host ""
    Write-Host "$c1TitleFmt$c2TitleFmt"
    Write-Host "$($c.Gray)--------------------------------------------------------   --------------------------------------------------------$($c.Reset)"

    $col1Items = $cfg.columns[0].items
    $col2Items = $cfg.columns[1].items
    $maxRows = [Math]::Max($col1Items.Count, $col2Items.Count)

    for ($i = 0; $i -lt $maxRows; $i++) {
        $leftStr = if ($i -lt $col1Items.Count) {
            Format-MenuItem -Number $col1Items[$i].id -Title $col1Items[$i].name -Sub $col1Items[$i].sub -ColWidth 59
        } else {
            " " * 59
        }

        $rightStr = if ($i -lt $col2Items.Count) {
            Format-MenuItem -Number $col2Items[$i].id -Title $col2Items[$i].name -Sub $col2Items[$i].sub -ColWidth 59
        } else {
            ""
        }

        Write-Host "$leftStr$rightStr"
    }

    # Colunas Inferiores: COMBOS vs TWEAKS
    Write-Host ""
    $combosTitle = "QUICK COMBOS | BATCH INSTALL"
    $tweaksTitle = "SYSTEM TWEAKS | CLEANER & UTILS"
    $cbTitleFmt = "$($c.Cyan)$combosTitle$($c.Reset)" + (" " * (59 - $combosTitle.Length))
    $twTitleFmt = "$($c.Cyan)$tweaksTitle$($c.Reset)"
    Write-Host "$cbTitleFmt$twTitleFmt"
    Write-Host "$($c.Gray)--------------------------------------------------------   --------------------------------------------------------$($c.Reset)"

    $comboItems = $cfg.combos
    $tweakItems = $cfg.tweaks
    $maxLowerRows = [Math]::Max($comboItems.Count, $tweakItems.Count)

    for ($i = 0; $i -lt $maxLowerRows; $i++) {
        $leftStr = if ($i -lt $comboItems.Count) {
            Format-MenuItem -Number $comboItems[$i].id -Title $comboItems[$i].name -Sub $comboItems[$i].sub -ColWidth 59
        } else {
            " " * 59
        }

        $rightStr = if ($i -lt $tweakItems.Count) {
            Format-MenuItem -Number $tweakItems[$i].id -Title $tweakItems[$i].name -Sub $tweakItems[$i].sub -ColWidth 59
        } else {
            ""
        }

        Write-Host "$leftStr$rightStr"
    }

    # Opcao de Sair
    $exitStr = Format-MenuItem -Number "00" -Title "Sair do Toolbox" -Sub "Encerrar o script" -ColWidth 59
    $cfgStr  = Format-MenuItem -Number "CF" -Title "Abrir Configuracao (apps.json)" -Sub "Adicionar mais apps" -ColWidth 59
    Write-Host ""
    Write-Host "$exitStr$cfgStr"

    # Rodapé de Instrucoes e Avisos Estilo Ghost Toolbox
    Write-Host ""
    Write-Host "$($c.Red)====================================================================================================================$($c.Reset)"
    Write-Host "$($c.Red) : DICA:$($c.White) Voce pode digitar multiplos numeros separados por espaco ou virgula! Exemplo: $($c.Yellow)1 2 10 11 15 16$($c.Reset)"
    Write-Host "$($c.Red) : DICA:$($c.White) Digite $($c.Yellow)99$($c.White) para instalar todos os programas, ou $($c.Yellow)config$($c.White) para abrir o arquivo de personalizacao.$($c.Reset)"
    Write-Host "$($c.Red) : INFO:$($c.White) Todos os pacotes sao baixados diretamente dos servidores oficiais via WinGet em modo silencioso.$($c.Reset)"
    Write-Host "$($c.Red)====================================================================================================================$($c.Reset)"
}

# Executar se chamado interativamente
if ($MyInvocation.InvocationName -ne '.') {
    while ($true) {
        Show-MainMenu
        $cfg = Get-ToolboxConfig

        Write-Host ""
        Write-Host "$($c.Green)[?]$($c.Yellow) Escolha uma ou mais opcoes (ex: 1 2 10 ou 99) > $($c.White)" -NoNewline
        $inputRaw = Read-Host
        $inputTrim = $inputRaw.Trim()

        if ([string]::IsNullOrWhiteSpace($inputTrim)) {
            continue
        }

        # Sair
        if ($inputTrim -in @("0", "00", "q", "exit", "sair")) {
            Write-Host ""
            Write-Host "$($c.Green) Obrigado por utilizar o WYZ TOOLBOX! Ate mais.$($c.Reset)"
            Start-Sleep -Seconds 1
            break
        }

        # Abrir configurador
        if ($inputTrim -in @("config", "cf", "apps")) {
            Write-Host "$($c.Yellow) Abrindo config\apps.json no Bloco de Notas...$($c.Reset)"
            Start-Process notepad.exe $configPath
            continue
        }

        # Mapear tokens digitados e expandir intervalos (ex: 1-3 ou 11-14)
        $rawTokens = $inputTrim -split '[\s,]+' | Where-Object { $_ -ne "" }
        $tokens = [System.Collections.Generic.List[string]]::new()
        foreach ($tok in $rawTokens) {
            if ($tok -match "^(\d+)-(\d+)$") {
                $start = [int]$matches[1]
                $end   = [int]$matches[2]
                if ($start -le $end) {
                    for ($n = $start; $n -le $end; $n++) {
                        $tokens.Add($n.ToString())
                    }
                }
            } else {
                $tokens.Add($tok)
            }
        }
        $resolvedInstallItems = [System.Collections.Generic.List[PSCustomObject]]::new()
        $resolvedTweaks = [System.Collections.Generic.List[PSCustomObject]]::new()

        # Montar mapa de itens disponiveis
        $appMap = @{}
        foreach ($col in $cfg.columns) {
            foreach ($it in $col.items) {
                $appMap[$it.id] = $it
            }
        }

        $comboMap = @{}
        foreach ($cb in $cfg.combos) {
            $comboMap[$cb.id] = $cb
        }

        $tweakMap = @{}
        foreach ($tw in $cfg.tweaks) {
            $tweakMap[$tw.id] = $tw
        }

        foreach ($token in $tokens) {
            # Verificar se e Combo
            if ($comboMap.ContainsKey($token)) {
                $cb = $comboMap[$token]
                if ($cb.packageIds -eq "ALL") {
                    foreach ($col in $cfg.columns) {
                        foreach ($it in $col.items) {
                            if (-not ($resolvedInstallItems | Where-Object { $_.packageId -eq $it.packageId })) {
                                $resolvedInstallItems.Add($it)
                            }
                        }
                    }
                } else {
                    foreach ($pkgId in $cb.packageIds) {
                        $foundItem = $null
                        foreach ($val in $appMap.Values) {
                            if ($val.packageId -eq $pkgId) {
                                $foundItem = $val
                                break
                            }
                        }
                        if ($foundItem) {
                            if (-not ($resolvedInstallItems | Where-Object { $_.packageId -eq $foundItem.packageId })) {
                                $resolvedInstallItems.Add($foundItem)
                            }
                        } else {
                            $customObj = [PSCustomObject]@{ name = $pkgId; packageId = $pkgId }
                            if (-not ($resolvedInstallItems | Where-Object { $_.packageId -eq $pkgId })) {
                                $resolvedInstallItems.Add($customObj)
                            }
                        }
                    }
                }
            }
            # Verificar se e Tweak
            elseif ($tweakMap.ContainsKey($token)) {
                $tw = $tweakMap[$token]
                if (-not ($resolvedTweaks | Where-Object { $_.id -eq $tw.id })) {
                    $resolvedTweaks.Add($tw)
                }
            }
            # Verificar se e App Individual
            elseif ($appMap.ContainsKey($token)) {
                $it = $appMap[$token]
                if (-not ($resolvedInstallItems | Where-Object { $_.packageId -eq $it.packageId })) {
                    $resolvedInstallItems.Add($it)
                }
            }
            else {
                Write-Host "$($c.Red)[!] Opcao nao reconhecida: $token$($c.Reset)"
            }
        }

        if ($resolvedInstallItems.Count -eq 0 -and $resolvedTweaks.Count -eq 0) {
            Write-Host "$($c.Yellow) Nenhuma opcao valida selecionada.$($c.Reset)"
            Start-Sleep -Seconds 1
            continue
        }

        # Resumo da Fila de Execucao
        Clear-Host
        Write-Host ""
        Write-Host "$($c.Magenta)====================================================================================================================$($c.Reset)"
        Write-Host "$($c.Yellow)[RESUMO DAS ACOES SELECIONADAS]:$($c.Reset)"
        if ($resolvedInstallItems.Count -gt 0) {
            Write-Host "$($c.Cyan) Aplicativos para instalar ($($resolvedInstallItems.Count)):$($c.Reset)"
            foreach ($app in $resolvedInstallItems) {
                Write-Host "  $($c.Green)*$($c.White) $($app.name) $($c.Gray)($($app.packageId))$($c.Reset)"
            }
        }
        if ($resolvedTweaks.Count -gt 0) {
            Write-Host "$($c.Cyan) Otimizacoes / Tweaks para executar ($($resolvedTweaks.Count)):$($c.Reset)"
            foreach ($tw in $resolvedTweaks) {
                Write-Host "  $($c.Yellow)*$($c.White) $($tw.name) $($c.Gray)($($tw.sub))$($c.Reset)"
            }
        }
        Write-Host "$($c.Magenta)====================================================================================================================$($c.Reset)"
        Write-Host ""
        Write-Host "$($c.Green)[?]$($c.White) Deseja iniciar a execucao agora? [S/N] (Padrao: S): $($c.Yellow)" -NoNewline
        $confirm = Read-Host
        if ($confirm.Trim() -match "^(n|nao|no)$") {
            Write-Host "$($c.Yellow) Operacao cancelada pelo usuario.$($c.Reset)"
            Start-Sleep -Seconds 1
            continue
        }

        # Limpar a tela para a execucao
        Clear-Host

        # Executar Instalacoes
        if ($resolvedInstallItems.Count -gt 0) {
            $idx = 1
            $total = $resolvedInstallItems.Count
            foreach ($app in $resolvedInstallItems) {
                Install-ToolboxPackage -Name $app.name -PackageId $app.packageId -CurrentIndex $idx -TotalCount $total
                $idx++
                Start-Sleep -Milliseconds 400
            }
        }

        # Executar Tweaks
        if ($resolvedTweaks.Count -gt 0) {
            Write-Host ""
            Write-Host "$($c.Cyan)[+] Executando Otimizacoes do Sistema...$($c.Reset)"
            foreach ($tw in $resolvedTweaks) {
                Write-Host ""
                Write-Host "$($c.Yellow)--- $($tw.name) ---$($c.Reset)"
                Invoke-ToolboxTweak -Action $tw.action
                Start-Sleep -Milliseconds 400
            }
        }

        Write-Host ""
        Write-Host "$($c.Green)====================================================================================================================$($c.Reset)"
        Write-Host "$($c.Green)[OK] Todas as operacoes selecionadas foram concluidas!$($c.Reset)"
        Write-Host "$($c.Green)====================================================================================================================$($c.Reset)"
        Write-Host "$($c.Gray)Pressione qualquer tecla para retornar ao menu principal...$($c.Reset)"
        $null = [Console]::ReadKey($true)
    }
}
