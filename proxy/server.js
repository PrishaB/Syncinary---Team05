const express = require('express');
const cors = require('cors');
const fetch = require('node-fetch');

const app = express();
app.use(cors());

const SERPAPI_KEY = '61032da7f9b9d14c67f7baf091d2fb3660a75d5df1f638b1f440343a1459da56';

app.get('/flights', async (req, res) => {
  const { origin, destination, departureDate, adults } = req.query;
  const url = new URL('https://serpapi.com/search');
  url.searchParams.set('engine', 'google_flights');
  url.searchParams.set('departure_id', origin);
  url.searchParams.set('arrival_id', destination);
  url.searchParams.set('outbound_date', departureDate);
  url.searchParams.set('adults', adults ?? '1');
  url.searchParams.set('type', '2');
  url.searchParams.set('api_key', SERPAPI_KEY);

  try {
    const response = await fetch(url.toString());
    const data = await response.json();
    console.log('Full SerpApi response:', JSON.stringify(data, null, 2));
    res.json(data['best_flights'] ?? data['other_flights'] ?? []);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

app.listen(3000, () => console.log('Proxy running on http://localhost:3000'));
