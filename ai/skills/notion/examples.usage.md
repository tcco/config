# Notion Brain Usage Examples

Your ready-to-run query examples.

## Query 1: 2026 Goals

Search Life database for goals intended for 2026.

```bash
NOTION_KEY=$(cat ~/.config/notion/api_key)
curl -X POST "https://api.notion.com/v1/databases/7ee8b17317cbe40b28b24aed349be0c300/query" \
  -H "Authorization: Bearer $NOTION_KEY" \
  -H "Notion-Version: 2025-09-03" \
  -H "Content-Type: application/json" \
  -d '{
    "filter": {
      "and": [
        {"property": "Year", "select": {"equals": "2026"}},
        {"property": "Type", "select": {"equals": "Goal"}}
      ]
    }
  }'
```

## Query 2: Personal & Real Estate Tasks

Get pending tasks from Get Done database filtered by category.

```bash
NOTION_KEY=$(cat ~/.config/notion/api_key)
curl -X POST "https://api.notion.com/v1/databases/4f3373c44b4d4cf39f713de07b28f50be9/query" \
  -H "Authorization: Bearer $NOTION_KEY" \
  -H "Notion-Version: 2025-09-03" \
  -H "Content-Type: application/json" \
  -d '{
    "filter": {
      "or": [
        {"property": "Category", "select": {"equals": "Personal"}},
        {"property": "Category", "select": {"equals": "Real Estate"}}
      ]
    },
    "sorts": [{"property": "Status", "direction": "ascending"}]
  }'
```

## Query 3: Stock Rotation (Side Gigs)

Find stocks to rotate out of and into, organized by portfolio.

```bash
NOTION_KEY=$(cat ~/.config/notion/api_key)
curl -X POST "https://api.notion.com/v1/databases/db22baf9f0de492bca6e48db49a46b2/query" \
  -H "Authorization: Bearer $NOTION_KEY" \
  -H "Notion-Version: 2025-09-03" \
  -H "Content-Type: application/json" \
  -d '{
    "filter": {
      "property": "Type", "select": {"equals": "Rotation"}
    }
  }'
```

## Query 4: All Active Goals (2026)

Get all active 2026 goals across Life.

```bash
NOTION_KEY=$(cat ~/.config/notion/api_key)
curl -X POST "https://api.notion.com/v1/databases/7ee8b17317cbe40b28b24aed349be0c300/query" \
  -H "Authorization: Bearer $NOTION_KEY" \
  -H "Notion-Version: 2025-09-03" \
  -H "Content-Type: application/json" \
  -d '{
    "filter": {
      "and": [
        {"property": "Status", "select": {"equals": "In Progress"}},
        {"property": "Year", "select": {"equals": "2026"}}
      ]
    }
  }'
```

## Query 5: Future Goals

Get all future/long-term goals.

```bash
NOTION_KEY=$(cat ~/.config/notion/api_key)
curl -X POST "https://api.notion.com/v1/databases/29c26e739c16b711baf10c6f99b84291/query" \
  -H "Authorization: Bearer $NOTION_KEY" \
  -H "Notion-Version: 2025-09-03" \
  -H "Content-Type: application/json" \
  -d '{}'
```

## Quick Search (All Pages)

Search across all your Notion:

```bash
NOTION_KEY=$(cat ~/.config/notion/api_key)
curl -X POST "https://api.notion.com/v1/search" \
  -H "Authorization: Bearer $NOTION_KEY" \
  -H "Notion-Version: 2025-09-03" \
  -H "Content-Type: application/json" \
  -d '{"query": "2026 goals"}'
```