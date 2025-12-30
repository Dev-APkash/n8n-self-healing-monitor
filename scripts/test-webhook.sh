#!/bin/bash
# Test Discord webhook connectivity

WEBHOOK_URL="${1:-YOUR_WEBHOOK_URL}"

curl -X POST "$WEBHOOK_URL" \
  -H "Content-Type: application/json" \
  -d '{
    "embeds": [{
      "title": "✅ Webhook Test",
      "description": "If you see this, your webhook is working!",
      "color": 5763719
    }]
  }'

echo -e "\n✅ Test message sent!"
