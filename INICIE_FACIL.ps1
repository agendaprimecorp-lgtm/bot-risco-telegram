# Script PowerShell para Deploy Automático do Bot
# Clique duplo e deixa rodar!

Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

Write-Host "`n" -ForegroundColor Black
Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║                                                            ║" -ForegroundColor Cyan
Write-Host "║   🤖  BOT TELEGRAM - DEPLOY AUTOMÁTICO (SUPER FÁCIL)  🤖  ║" -ForegroundColor Cyan
Write-Host "║                                                            ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host "`n"

# Verificar Git
Write-Host "✓ Verificando Git..." -ForegroundColor Yellow
$gitVersion = git --version 2>$null
if (!$gitVersion) {
    Write-Host "❌ Git não encontrado! Baixe em: https://git-scm.com/download/win" -ForegroundColor Red
    Read-Host "Pressione ENTER"
    exit 1
}
Write-Host "✅ Git OK: $gitVersion" -ForegroundColor Green
Write-Host "`n"

# Configurar Git (se não estiver configurado)
Write-Host "✓ Configurando Git..." -ForegroundColor Yellow
$gitUser = git config --global user.name 2>$null
if (!$gitUser) {
    Write-Host "   Configurando nome de usuário..." -ForegroundColor Gray
    git config --global user.name "Rodrigo Vianna" | Out-Null
    git config --global user.email "contato@primecorpconsultoria.com.br" | Out-Null
    Write-Host "✅ Git configurado!" -ForegroundColor Green
} else {
    Write-Host "✅ Git já configurado para: $gitUser" -ForegroundColor Green
}
Write-Host "`n"

# Verificar repositório Git
Write-Host "✓ Verificando repositório Git..." -ForegroundColor Yellow
if (!(Test-Path ".git")) {
    Write-Host "   Inicializando repositório Git..." -ForegroundColor Gray
    git init | Out-Null
    git branch -M main | Out-Null

    # Adicionar remote (você precisa criar o repositório no GitHub primeiro)
    $repoUrl = git config --get remote.origin.url 2>$null
    if (!$repoUrl) {
        Write-Host "   ⚠️  Nenhum repositório remoto configurado" -ForegroundColor Yellow
        Write-Host "   Por favor, crie um repositório no GitHub: https://github.com/new" -ForegroundColor Yellow
        $repoUrl = Read-Host "   Cole a URL do repositório GitHub (ex: https://github.com/seu-usuario/bot-risco-telegram)"
        if ($repoUrl) {
            git remote add origin $repoUrl | Out-Null
            Write-Host "   ✅ Remote adicionado!" -ForegroundColor Green
        }
    }
} else {
    Write-Host "✅ Repositório Git encontrado!" -ForegroundColor Green
}
Write-Host "`n"

# Status do repositório
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "📊 STATUS ATUAL:" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
git status
Write-Host "`n"

# Adicionar arquivos
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "📝 ADICIONANDO ARQUIVOS..." -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
git add . 2>&1
Write-Host "✅ Arquivos adicionados!" -ForegroundColor Green
Write-Host "`n"

# Fazer commit
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "💾 CRIANDO COMMIT..." -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
$commitResult = git commit -m "Bot Telegram com Claude API - Deploy Automático" 2>&1
if ($commitResult -like "*nothing to commit*") {
    Write-Host "⚠️  Nenhuma alteração para commitar (já foi feito)" -ForegroundColor Yellow
} else {
    Write-Host "✅ Commit criado!" -ForegroundColor Green
}
Write-Host "`n"

# Fazer push
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "🚀 ENVIANDO PARA GITHUB (PUSH)..." -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "   Aguarde... isso pode levar alguns segundos..." -ForegroundColor Gray
Write-Host "`n"

$pushOutput = git push -u origin main 2>&1
Write-Host $pushOutput

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n"
    Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host "✅ SUCESSO! PUSH REALIZADO!" -ForegroundColor Green
    Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host "`n"
    Write-Host "🎉 PARABÉNS! Seu bot foi enviado para o GitHub!" -ForegroundColor Green
    Write-Host "🔄 O Render vai detectar a mudança em 30 segundos..." -ForegroundColor Green
    Write-Host "   Você vai ver 'Live' no Render Dashboard!" -ForegroundColor Green
    Write-Host "`n"
    Write-Host "📊 Próximos passos:" -ForegroundColor Cyan
    Write-Host "   1. Vá para: https://dashboard.render.com" -ForegroundColor Cyan
    Write-Host "   2. Clique em: bot-risco-telegram" -ForegroundColor Cyan
    Write-Host "   3. Aguarde o Deploy (2-3 minutos)" -ForegroundColor Cyan
    Write-Host "   4. Teste no Telegram: @seu_risco_bot" -ForegroundColor Cyan
    Write-Host "`n"
} else {
    Write-Host "`n"
    Write-Host "❌ ERRO ao fazer push!" -ForegroundColor Red
    Write-Host "`n"
    Write-Host "Possíveis soluções:" -ForegroundColor Yellow
    Write-Host "   1. Verifique se tem conexão com internet" -ForegroundColor Yellow
    Write-Host "   2. Verifique se criou o repositório no GitHub" -ForegroundColor Yellow
    Write-Host "   3. Tente fazer login do GitHub novamente" -ForegroundColor Yellow
    Write-Host "`n"
}

Write-Host "Pressione ENTER para fechar..." -ForegroundColor Gray
Read-Host
