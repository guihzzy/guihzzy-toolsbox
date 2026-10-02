# Wyz Toolbox

O **Wyz Toolbox** é uma central interativa de instalação automatizada e otimização para Windows projetada para poupar tempo na formatação, inspirada no clássico Ghost Spectre Toolbox.

## Objetivo e Funcionamento

Quando você precisar formatar o PC ou instalar vários aplicativos:
- O Toolbox baixa e instala os programas selecionados de forma 100% silenciosa usando o motor nativo do **WinGet**.
- Se você escolher vários programas (ex: `1 2 10 25`), ele cria uma fila e instala um por vez sem exibir pop-ups irritantes de "Avançar" (Batch Install).
- O plugin pode instalar aplicativos isolados, grupos em sequência (como do `11-14`) ou atalhos de "Combos" (vários apps atrelados a um único número).
- O sistema eleva as próprias permissões automaticamente (UAC) e previne travamentos durante as execuções.
- Você pode editar e adicionar seus próprios aplicativos e configurações diretamente no arquivo `apps.json`, e a interface vai se moldar automaticamente sem mexer no código.

## Como usar?

1. Abra o **PowerShell** no seu Windows.
2. Cole o comando abaixo e pressione Enter:
   ```powershell
   irm https://api.wyzbots.com.br/tools/guihzzy | iex
   ```
3. Digite o número correspondente ao aplicativo ou pacote desejado na tela e pressione Enter.
4. *(Opcional)* Se você quiser usar sem internet via script web, basta baixar a pasta inteira, extrair e dar um duplo clique no arquivo **`WyzToolbox.bat`**.

## Regras de Segurança e Validação

Antes de realizar as ações no PC, o motor valida rigorosamente:
1. A versão do WinGet instalada no sistema para garantir a compatibilidade.
2. A confirmação de que os aplicativos vêm de fontes originais da Microsoft (forçando `--source winget`).
3. Você aceita automaticamente os termos (agreements) e eleva para modo `--silent` bloqueando qualquer interação extra.
4. Se a janela for fechada acidentalmente ou o código falhar, o script lida com os erros pra não deixar logs sujos ou telas travadas.

## Configurações / Tweaks Inclusos

- **Otimizar Mouse & Teclado:** Configuração vital para FPS. Desativa completamente a aceleração "Aprimorar Precisão do Ponteiro", crava a velocidade do mouse em 6/11 e ajusta a taxa de repetição do teclado para a mais rápida através da API nativa do Windows, aplicando na mesma hora sem necessidade de reiniciar.
- **Limpar Temp & Cache:** Exclui lixos sistêmicos dos diretórios Temp, %Temp%, Prefetch e Logs do sistema.
- **Flush DNS & Winsock:** Restaura padrões de internet e resolve problemas de rota/ping com um redefinição de sockets.
- **Desempenho Máximo:** Traz à tona e ativa o plano de energia oculto do Windows para evitar o modo "Equilibrado".
- **Atualizar WinGet:** Sincroniza a biblioteca de pacotes e repositórios forçando o update.

---

<p align="center">Feito com ❤️ por <b>Guih</b></p>
