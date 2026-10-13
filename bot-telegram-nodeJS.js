⏳✅❌⏳ó⚠️ãóãêéÁã💼🤖á⏳✅const express = require('express');
const axios = require('axios');
require('dotenv').config();
const Anthropic = require('@anthropic-ai/sdk');

const app = express();
app.use(express.json());

const TELEGRAM_TOKEN = process.env.TELEGRAM_TOKEN;
const CLAUDE_API_KEY = process.env.CLAUDE_API_KEY;
const WEBHOOK_URL = process.env.WEBHOOK_URL;
const PORT = process.env.PORT || 3000;

const client = new Anthropic({
  apiKey: CLAUDE_API_KEY,
});

// Configurar webhook do Telegram
async function setupWebhook() {
  try {
    const url = `https://api.telegram.org/bot${TELEGRAM_TOKEN}/setWebhook`;
    const response = await axios.post(url, {
      url: `${WEBHOOK_URL}/webhook`,
      allowed_updates: ['message'],
    });
    console.log('Webhook configurado:', response.data);
  } catch (error) {
    console.error('Erro ao configurar webhook:', error.message);
  }
}

// Endpoint do webhook
app.post('/webhook', async (req, res) => {
  try {
    const { message } = req.body;

    if (!message || !message.text) {
      return res.sendStatus(200);
    }

    const chatId = message.chat.id;
    const userMessage = message.text;

    // Enviar para Claude API
    const response = await client.messages.create({
      model: 'claude-3-5-sonnet-20241022',
      max_tokens: 150,
      system: 'Você é um consultor de risco. Responda com NO MÁXIMO 3 linhas.',
      messages: [
        {
          role: 'user',
          content: userMessage,
        },
      ],
    });

    const botResponse = response.content[0].text;

    // Botão inline para Calendly
    const inlineKeyboard = {
      inline_keyboard: [
        [
          {
            text: '💼 Agendar Consulta ($200 USD)',
            url: 'https://www.calendinho.com/rodrigo-franca-viana',
          },
        ],
      ],
    };

    // Enviar resposta ao Telegram
    await axios.post(
      `https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage`,
      {
        chat_id: chatId,
        text: botResponse,
        reply_markup: inlineKeyboard,
      }
    );

    res.sendStatus(200);
  } catch (error) {
    console.error('Erro ao processar mensagem:', error.message);
    res.sendStatus(500);
  }
});

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'ok' });
});

// Iniciar servidor
app.listen(PORT, async () => {
  console.log(`🤖 Bot Telegram rodando na porta ${PORT}`);
  await setupWebhook();
});
