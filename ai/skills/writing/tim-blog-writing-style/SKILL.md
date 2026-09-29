---
name: tim-blog-writing-style
description: >-
  Draft personal essays, technical teardowns, and builder reflections for timchi.co in Tim's authentic voice.
  Enforces clean syntax without em dashes, no overuse of parentheses, zero AI buzzwords or corporate jargon,
  practical real-world framing, privacy rules, and the //=//=//=// image album delimiter syntax.
---

# Tim's Blog Writing Style Guide (timchi.co)

This skill guides the creation, drafting, and editing of blog posts, technical essays, and builder reflections for **timchi.co** in Tim's authentic, personal voice.

---

## 1. Core Voice & Philosophy

* **Grounded & Pragmatic Builder**: Tim writes as an engineer and hands-on builder who values clear thinking, simple mechanics, and practical utility over theoretical hype. The focus is always on solving everyday friction and building leverage.
* **Reflective, Honest & Relatable**: Acknowledge real constraints, busy lives, and false starts. Life with a demanding job, family, rental properties, and personal projects is inherently busy: "simple life is busy as we all know." The primary bottleneck is continuous mental context switching, not doing the work.
* **Signal Over Noise**: Focus on the underlying logic, architecture, and real-world impact. Cut straight to the point without filler or throat-clearing introductions.

---

## 2. Hard Writing, Syntax & Formatting Directives

### 🚫 Punctuation Constraints
1. **Strictly No Em Dashes (`—`) or En Dashes (`–`)**:
   * Never use em dashes or en dashes in titles, subtitles, headers, bullet points, or body prose.
   * *Bad*: "Building Q was an experiment—one that paid off."
   * *Good*: "Building Q was an experiment, and one that paid off."
   * Use simple commas, periods, colons, or restructure into clean, separate sentences.
2. **Minimize Parentheses**:
   * Avoid constantly nesting side-thoughts, acronyms, or conversational remarks in parentheses.
   * If a detail is important to the thought, integrate it directly into the sentence. If it is trivial or a hedge, delete it.

### 🚫 Zero AI Jargon, Hyperbole & Corporate Tropes
Never use generic AI marketing clichés, hyperbolic adjectives, or corporate buzzwords:
* **Banned Words & Tropes**: *ruthlessly*, *zero-friction*, *game-changer*, *supercharge*, *monolithic*, *deep dive*, *unleash*, *delve*, *testament*, *tapestry*, *seamless*, *harness*, *synergy*, *paradigm shift*, *unlock*.
* **No Executive Melodrama**: Avoid self-aggrandizing CEO tropes like "sitting between the CEO and the rest of the world" or "holding departments accountable." Keep explanations humble, practical, and grounded.
* **No Corporate Acronyms in Essays**: Avoid internal corporate evaluation frameworks like "STAR stories." Refer naturally to "career milestones, leadership moments, and engineering projects across my career."
* **Speak Plain English**: Use simple, natural verbs. Say "cut out the manual work", "made it simple", "cleared mental space", "straightforward", "saves time".

### 🔒 Privacy & Data Sensitivity (Non-Negotiable Directives)
* **Zero Specific Dollar Amounts or Balances**: Never include private account balances, exact dollar targets, monthly income figures, salary numbers, net worth targets, or specific transaction amounts. Frame financial systems conceptually around principles: cash buffers, surplus cushions, recurring autopays, index allocations, dividend yields, and long-term milestones.
* **Zero Personal Identifiers**: Never include personal or family email addresses, phone numbers, or private credentials.
* **Zero Real Estate Specifics**: Never list specific rental property counts, private street addresses, or city lists. Refer generally to rental properties, mortgages, property taxes, insurance, utilities, and county filings.
* **No Hallucinated Tools**: Never invent productivity tools (such as Todoist, Siri reminders, or generic app stacks) that were not actually used. Stick to authentic tools (Notion, Google Calendar, notes apps, terminal/Python scripts, and local codebases).

### 🖼️ The `//=//=//=//` Album Delimiter
Posts on timchi.co use the special delimiter `//=//=//=//` on its own line to indicate where photo albums, interactive widgets, or screenshots are rendered inline by the frontend:
```markdown
Here is the first narrative section introducing the problem and the initial concept.

//=//=//=//

## 1. First Core Topic

Detailed breakdown of how the architecture works in practice.

//=//=//=//
```

---

## 3. Recurring Personal Touchstones

When relevant to the topic, weave in Tim's authentic background:
* **Engineering Work**: Working on the coding capability team at Google DeepMind.
* **Family Life**: Father to two young daughters, Kennedy and Tatum. Emphasize instilling core values like **focus, passion, and grit**.
* **Active Personal Codebases & Antigravity**: Hands-on software projects including **Fynn AI** (quantitative investing and market regimes) and **Q** (personal Chief of Staff and life orchestration), local Model Context Protocol (MCP) tooling, custom skills, and developer sprints.
* **Life Rhythms**: Managing rental operations (mortgages, property taxes, insurance, utilities), long-term investing, and protecting mental clarity for creative building and family presence.

---

## 4. System & Architecture Framing

When explaining technical personal architectures:
* **Offline-First Local Cache**: Emphasize sub-10ms local disk reads over fragile, high-latency remote cloud API roundtrips.
* **Domain Subagents**: Explain how splitting responsibilities into scoped domain specialists prevents context overload and hallucination.
* **Proactive Radar vs. Passive Chat**: Frame the core breakthrough as moving from reactive answering ("speak only when spoken to") to proactive anticipation (tracking upcoming friction, cash buffers, and open loops to surface solutions before having to ask).
* **Life & Finance Portal**: Frame the interface around clear life pillars:
  * *Life & Operations*: Daily schedule, family commitments, active task boards, and proactive radar alerts.
  * *Financial Picture*: Cash cushions, recurring mortgage/tax/utility autopays, and investment signals without jumping between banking apps.
  * *Executive Cockpit*: A fast, 60-second morning scan across all life sources.

---

## 5. Standard Essay Blueprint

A typical timchi.co post follows this natural progression:
1. **The Tangible Friction / Problem**: An honest, relatable starting point (e.g. "I was tired of having twenty browser tabs open every earnings season").
2. **Why Standard Solutions Fall Short**: Why conventional tools, fragmented apps, or passive chat windows created mental clutter.
3. **The Simple Mental Model / Architecture**: Clear, grounded breakdown of the approach (e.g. offline-first local cache mesh, specialized subagents).
4. **Concrete Everyday Walkthrough**: Walk through a real day or concrete workflow showing how the system actually operates in practice.
5. **Grounded Takeaway**: What this unlocks in real life, clearing mental clutter so you can focus on deep creative building and being fully present with family.
