const axios = require('axios');
require('dotenv').config();
const Anthropic = require('@anthropic-ai/sdk');

const TELEGRAM_TOKEN = process.env.TELEGRAM_TOKEN;
const CLAUDE_API_KEY = process.env.CLAUDE_API_KEY;
const client = new Anthropic({apiKey: CLAUDE_API_KEY});

let lastUpdateId = 0;

async function handleMessage(chatId, userMessage) {
  const response = await client.messages.create({
    model: 'claude-3-5-sonnet-20241022',
    max_tokens: 150,
    system: 'Você é um consultor de risco. Responda com NO MÁXIMO 3 linhas.',
    messages: [{role: 'user', content: userMessage}],
  });

  const botResponse = response.content[0].text;
  const inlineKeyboard = {inline_keyboard: [[{text: '💼 Agendar Consulta', url: 'https://calendly.com/rodrigo-franca-viana'}]]};

  await axios.post(https://api.telegram.org/bot/sendMessage, {chat_id: chatId, text: botResponse, reply_markup: inlineKeyboard});
  console.log('✅ Resposta enviada!');
}

async function getUpdates() {
  const response = await axios.get(https://api.telegram.org/bot/getUpdates, {params: {offset: lastUpdateId + 1, timeout: 30}});
  const updates = response.data.result || [];
  for (const update of updates) {
    lastUpdateId = update.update_id;
    if (update.message && update.message.text) {
      await handleMessage(update.message.chat.id, update.message.text);
    }
  }
}

async function start() {
  console.log('🤖 Bot iniciado!');
  while (true) {
    await getUpdates();
    await new Promise(r => setTimeout(r, 1000));
  }
}

start();
