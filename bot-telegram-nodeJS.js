const axios = require('axios');
const express = require('express');
require('dotenv').config();
const Anthropic = require('@anthropic-ai/sdk');

const TELEGRAM_TOKEN = process.env.TELEGRAM_TOKEN;
const CLAUDE_API_KEY = process.env.CLAUDE_API_KEY;
const CLAUDE_MODEL = process.env.CLAUDE_MODEL || 'claude-sonnet-4-5';
const PORT = process.env.PORT || 3000;
const TG_API = `https://api.telegram.org/bot${TELEGRAM_TOKEN}`;

if (!TELEGRAM_TOKEN || !CLAUDE_API_KEY) {
  console.error('❌ Faltam variáveis TELEGRAM_TOKEN e/ou CLAUDE_API_KEY');
  process.exit(1);
}

const client = new Anthropic({ apiKey: CLAUDE_API_KEY });
let lastUpdateId = 0;

// Servidor HTTP mínimo: Render (Web Service) exige porta aberta
const app = express();
app.get('/', (req, res) => res.send('Bot online'));
app.get('/health', (req, res) => res.json({ ok: true, lastUpdateId }));
app.listen(PORT, () => console.log(`🌐 HTTP na porta ${PORT}`));

async function sendMessage(chatId, text, replyMarkup) {
  await axios.post(`${TG_API}/sendMessage`, {
    chat_id: chatId,
    text,
    ...(replyMarkup ? { reply_markup: replyMarkup } : {}),
  });
}

async function handleMessage(chatId, userMessage) {
  const inlineKeyboard = {
    inline_keyboard: [
      [{ text: '💼 Agendar Consulta (US$ 200)', url: 'https://calendly.com/rodrigo-franca-viana' }],
    ],
  };

  if (userMessage === '/start') {
    await sendMessage(chatId, 'Olá! Descreva sua situação e eu faço uma análise de risco rápida.', inlineKeyboard);
    return;
  }

  try {
    const response = await client.messages.create({
      model: CLAUDE_MODEL,
      max_tokens: 300,
      system: 'Você é um consultor de risco. Responda em português com NO MÁXIMO 3 linhas.',
      messages: [{ role: 'user', content: userMessage }],
    });
    const botResponse = response.content.map(b => b.text || '').join('').trim() || 'Sem resposta.';
    await sendMessage(chatId, botResponse, inlineKeyboard);
    console.log('✅ Resposta enviada');
  } catch (error) {
    console.error('❌ Erro Claude/Telegram:', error.response?.data || error.message);
    try {
      await sendMessage(chatId, 'Instabilidade momentânea. Tente novamente em instantes.', inlineKeyboard);
    } catch (_) {}
  }
}

async function getUpdates() {
  try {
    const response = await axios.get(`${TG_API}/getUpdates`, {
      params: { offset: lastUpdateId + 1, timeout: 30 },
      timeout: 35000,
    });
    for (const update of response.data.result || []) {
      lastUpdateId = update.update_id;
      if (update.message && update.message.text) {
        console.log(`📨 Mensagem de ${update.message.chat.id}: "${update.message.text}"`);
        await handleMessage(update.message.chat.id, update.message.text);
      }
    }
  } catch (error) {
    console.error('❌ Erro getUpdates:', error.response?.data || error.message);
    await new Promise(r => setTimeout(r, 5000));
  }
}

async function start() {
  // Remove webhook antigo — senão getUpdates retorna 409 Conflict
  try {
    await axios.post(`${TG_API}/deleteWebhook`, { drop_pending_updates: false });
    const me = await axios.get(`${TG_API}/getMe`);
    console.log(`🤖 Bot @${me.data.result.username} em modo POLLING`);
  } catch (error) {
    console.error('❌ Token Telegram inválido?', error.response?.data || error.message);
  }
  while (true) {
    await getUpdates();
  }
}

start();
