#!/bin/bash
# SEO article generator using FreeLLMAPI
# Usage: ./scripts/generate-article.sh "How to fix [error message] in [framework]"

TOPIC="$1"
if [ -z "$TOPIC" ]; then
  echo "Usage: ./scripts/generate-article.sh \"How to fix TypeError in React\""
  exit 1
fi

API_KEY="freellmapi-fd35c9c47e752c030f776c783517c5d79b6aeaa54c47c3db"
API_URL="http://localhost:3001/v1/chat/completions"

# Slugify properly using Python
SLUG=$(echo "$TOPIC" | python3 -c "import sys,re; s=sys.stdin.read().strip(); s=re.sub(r\"'\",'',s); s=re.sub(r'[^a-z0-9]+','-',s.lower()).strip('-'); print(s)")
DATE=$(date +%Y-%m-%dT%H:%M:%S.000Z)

read -r -d '' PROMPT << PROMPT_EOF
Write an SEO-optimized blog post for the topic: "${TOPIC}".

Use this exact structure:

## What Causes This Error
2-3 paragraphs explaining the root cause. Be specific and technical.

## How to Fix It
Step-by-step with working code examples. Show the exact code changes needed.

## Common Variations
List 3-4 related errors with brief solutions and code snippets.

## FAQ
2-3 common questions with short answers.

Rules:
- Title is already set, do NOT repeat it
- Use H2 and H3 headings only (no H1)
- Include working code blocks with language tags
- Keep paragraphs short (2-3 sentences max)
- Total length: 600-1000 words
- Write in clear, direct English
- Do NOT add "Introduction", "Conclusion", "Summary" sections
- Focus on practical solutions, not theory
- First paragraph after each heading should be the solution

Output ONLY the article content in markdown format.
PROMPT_EOF

echo "Generating article for: $TOPIC"
echo "URL slug: $SLUG"

RESPONSE=$(curl -s --max-time 180 "$API_URL" \
  -H "Authorization: Bearer $API_KEY" \
  -H "Content-Type: application/json" \
  -d "{
    \"model\": \"auto\",
    \"messages\": [{\"role\": \"user\", \"content\": $(echo "$PROMPT" | jq -Rs .)}],
    \"temperature\": 0.7,
    \"max_tokens\": 2048
  }")

CONTENT=$(echo "$RESPONSE" | python3 -c "
import sys, json
try:
    d = json.load(sys.stdin)
    print(d['choices'][0]['message']['content'])
except Exception as e:
    print(f'Error: {e}', file=sys.stderr)
    print(json.dumps(d, indent=2)[:500])
")

# Write to the correct astro-paper path
OUTPUT_DIR="src/content/posts"
mkdir -p "$OUTPUT_DIR"

# Format description from first sentence, ensure no inner double quotes
DESC=$(echo "$CONTENT" | head -5 | python3 -c "
import sys
lines = sys.stdin.read()
for line in lines.split('\n'):
    line = line.strip().lstrip('#').strip()
    if line and len(line) > 30:
        desc = line[:120].replace('\"', \"'\")
        print(desc)
        break
")

cat > "${OUTPUT_DIR}/${SLUG}.md" << ARTICLE_EOF
---
title: "${TOPIC}"
pubDatetime: ${DATE}
modDatetime: ${DATE}
description: "${DESC}..."
tags:
  - tutorial
  - error-fix
  - seo
---

${CONTENT}
ARTICLE_EOF

echo "Saved to: ${OUTPUT_DIR}/${SLUG}.md"
echo "Word count: $(echo "$CONTENT" | wc -w)"
