# Notion API Reference

Complete reference for Notion API v2025-09-03.

## Headers (Required for All Requests)

```bash
NOTION_KEY=$(cat ~/.config/notion/api_key)
-H "Authorization: Bearer $NOTION_KEY" \
-H "Notion-Version: 2025-09-03" \
-H "Content-Type: application/json"
```

## Endpoints

### Search

```bash
POST https://api.notion.com/v1/search
```

### Pages

```bash
GET  https://api.notion.com/v1/pages/{page_id}
POST https://api.notion.com/v1/pages
PATCH https://api.notion.com/v1/pages/{page_id}
```

### Databases

```bash
GET  https://api.notion.com/v1/databases/{database_id}
POST https://api.notion.com/v1/databases
PATCH https://api.notion.com/v1/databases/{database_id}
POST https://api.notion.com/v1/databases/{database_id}/query
```

### Blocks

```bash
GET  https://api.notion.com/v1/blocks/{block_id}
GET  https://api.notion.com/v1/blocks/{block_id}/children
PATCH https://api.notion.com/v1/blocks/{block_id}
PATCH https://api.notion.com/v1/blocks/{block_id}/children
```

## Property Formats

### Title
```json
{"title": [{"text": {"content": "Page Title"}}]}
```

### Rich Text
```json
{"rich_text": [{"text": {"content": "Some text"}}]}
```

### Select
```json
{"select": {"name": "Option"}}
```

### Multi-Select
```json
{"multi_select": [{"name": "A"}, {"name": "B"}]}
```

### Date
```json
{"date": {"start": "2026-01-15", "end": "2026-01-16"}}
```

### Checkbox
```json
{"checkbox": true}
```

### Number
```json
{"number": 42}
```

### URL
```json
{"url": "https://example.com"}
```

### Email
```json
{"email": "user@example.com"}
```

### Relation
```json
{"relation": [{"id": "page_id"}]}
```

## Filter Operators

```json
{"property": "Name", "title": {"equals": "Title"}}
{"property": "Status", "select": {"equals": "Done"}}
{"property": "Tags", "multi_select": {"contains": "A"}}
{"property": "Date", "date": {"on_or_after": "2026-01-01"}}
{"property": "Count", "number": {"greater_than": 10}}

// Combine with AND/OR
{"and": [
  {"property": "Status", "select": {"equals": "In Progress"}},
  {"property": "Year", "select": {"equals": "2026"}}
]}
```

## Sort

```json
{"sorts": [{"property": "Date", "direction": "descending"}]}
```

## Pagination

```json
{"page_size": 100, "start_cursor": "cursor_token"}
```

## Rate Limits

- 3 requests/second average
- Burst allowed but will get 429 response
- Backoff and retry