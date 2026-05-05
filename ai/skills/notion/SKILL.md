---
name: notion-brain
description: Query and manage your Notion "brain" - life goals, tasks, investments, and personal knowledge base
trigger-when: user mentions notion, brain, goals, tasks, investments, stocks, life, real estate, professional, kids, future, side gigs, side-gigs, portfolio
disable-automation: true
allowed-commands:
  - notion-query
  - notion-search
  - notion-page
allowed-tools: Read, Grep, Glob, Bash
---

# Notion Brain

Your personal Notion for life goals, tasks, investments, and professional knowledge.

## Databases

| Database | ID | Purpose |
|----------|---|---------|
| Get Done | 4f3373c44b4d4cf39f713de07b28f50be9 | Daily life kanban |
| Life | 7ee8b17317cbe40b28b24aed349be0c300 | Goals, professional, kids |
| Future | 29c26e739c16b711baf10c6f99b84291 | Long term goals |
| Side Gigs | db22baf9f0de492bca6e48db49a46b2 | Investments, trading |

## Usage

### Search

```bash
NOTION_KEY=$(cat ~/.config/notion/api_key)
curl -X POST "https://api.notion.com/v1/search" \
  -H "Authorization: Bearer $NOTION_KEY" \
  -H "Notion-Version: 2025-09-03" \
  -H "Content-Type: application/json" \
  -d '{"query": "your search"}'
```

### Query Database

```bash
NOTION_KEY=$(cat ~/.config/notion/api_key)
curl -X POST "https://api.notion.com/v1/databases/{database_id}/query" \
  -H "Authorization: Bearer $NOTION_KEY" \
  -H "Notion-Version: 2025-09-03" \
  -H "Content-Type: application/json" \
  -d '{"filter": {"property": "Status", "select": {"equals": "Todo"}}}'
```

### Get Page Content

```bash
curl "https://api.notion.com/v1/blocks/{page_id}/children" \
  -H "Authorization: Bearer $NOTION_KEY" \
  -H "Notion-Version: 2025-09-03"
```

### Create Page

```bash
curl -X POST "https://api.notion.com/v1/pages" \
  -H "Authorization: Bearer $NOTION_KEY" \
  -H "Notion-Version: 2025-09-03" \
  -H "Content-Type: application/json" \
  -d '{
    "parent": {"database_id": "DATABASE_ID"},
    "properties": {
      "Name": {"title": [{"text": {"content": "Title"}}]}
    }
  }'
```

## Setup

1. Create integration at https://notion.so/my-integrations
2. Copy API key to `~/.config/notion/api_key`
3. Share databases with integration in Notion (click "..." → "Connect to")