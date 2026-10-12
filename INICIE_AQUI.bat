@echo off
chcp 65001 > nul
color 0A
cls

echo.
echo ╔════════════════════════════════════════════════════════════╗
echo ║                                                            ║
echo ║   🤖  BOT TELEGRAM COM CLAUDE API - DEPLOY AUTOMÁTICO  🤖  ║
echo ║                                                            ║
echo ╚════════════════════════════════════════════════════════════╝
echo.

REM Verificar se Git está instalado
git --version > nul 2>&1
if errorlevel 1 (
    echo ❌ ERRO: Git não está instalado!
    echo.
    echo Por favor, instale o Git em: https://git-scm.com/download/win
    echo.
    pause
    exit /b 1
)

echo ✅ Git encontrado!
echo.

REM Verificar se está em um repositório Git
if not exist ".git" (
    echo ❌ ERRO: Você não está em um repositório Git!
    echo.
    echo Este arquivo deve estar dentro de um repositório Git.
    echo.
    pause
    exit /b 1
)

echo ✅ Repositório Git encontrado!
echo.

REM Mostrar status atual
echo ═══════════════════════════════════════════════════════════
echo 📊 STATUS ATUAL DO REPOSITÓRIO:
echo ═══════════════════════════════════════════════════════════
git status
echo.

REM Fazer add
echo ═══════════════════════════════════════════════════════════
echo 📝 ADICIONANDO ARQUIVOS...
echo ═══════════════════════════════════════════════════════════
git add .
echo ✅ Arquivos adicionados!
echo.

REM Fazer commit
echo ═══════════════════════════════════════════════════════════
echo 💾 CRIANDO COMMIT...
echo ═══════════════════════════════════════════════════════════
git commit -m "Bot Telegram com Claude API - Deploy Automático"
if errorlevel 1 (
    echo ⚠️  Nenhuma alteração para commitar ou erro no commit
    echo.
) else (
    echo ✅ Commit criado com sucesso!
    echo.
)

REM Fazer push
echo ═══════════════════════════════════════════════════════════
echo 🚀 ENVIANDO PARA GITHUB (PUSH)...
echo ═══════════════════════════════════════════════════════════
git push origin main
if errorlevel 1 (
    echo ❌ ERRO ao fazer push!
    echo Verifique se:
    echo   1. Você tem conexão com a internet
    echo   2. O repositório está configurado corretamente
    echo   3. Você tem permissão para fazer push
    echo.
    pause
    exit /b 1
) else (
    echo ✅ Push realizado com sucesso!
    echo.
)

REM Sucesso!
echo ═══════════════════════════════════════════════════════════
echo ✅ TUDO PRONTO! BOT ENVIADO PARA O RENDER!
echo ═══════════════════════════════════════════════════════════
echo.
echo 📊 Próximos passos:
echo   1. O Render vai detectar a mudança automaticamente
echo   2. Vai fazer build dos arquivos (2-3 minutos)
echo   3. Seu bot estará 24/7 ativo no Render
echo.
echo 🎉 SUCESSO! Seu bot está deployado!
echo.
pause
