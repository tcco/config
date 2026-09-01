# 🤖 AI Skills Repository

Canonical, version-controlled library of agent skills and executive workflows.

Skills are organized into domain-specific subdirectories for modularity and clarity.

---

## 📂 Directory Structure

```
ai/skills/
├── fynnai/                     # Quantitative trading & portfolio intelligence
│   ├── finance-watchlist-sync/
│   ├── fundamental-quant-evaluator/
│   ├── macro-regime-analyst/
│   ├── portfolio-orchestrator/
│   ├── social-sentiment-scanner/
│   └── technical-chart-analyst/
├── mac/                        # macOS system maintenance & storage health
│   └── mac-disk-maintenance/
└── q/                          # Executive Operating System & Chief of Staff
    └── chief-of-staff-builder/
```

---

## 📚 Skills Catalog

### 1. 📈 `fynnai/` (Investing & Portfolio Intelligence)

| Skill | Description |
| :--- | :--- |
| **`finance-watchlist-sync`** | Automates cross-platform watchlist synchronization across Robinhood, Seeking Alpha, Google Finance Beta, and external finance dashboards using browser automation and AppleScript DOM drivers. |
| **`fundamental-quant-evaluator`** | Generates earnings report cards, Seeking Alpha 5-Factor Quant scores (A+ to F), 5 Lifecycle Archetype classifications (AOTG framework), and 3-Year Base/Bull/Bear price projections with annual CAGR. |
| **`macro-regime-analyst`** | Ingests macroeconomic telemetry (VIX, CPI/PCE, Fed Funds Rate, Treasury Yield Curves $2\text{Y}/10\text{Y}/30\text{Y}$, Jobs, ISM) and classifies market environment regimes. |
| **`portfolio-orchestrator`** | Central orchestrator managing multi-agent pipeline fan-out, multi-dimensional distributions, watchlist onboarding, capital displacement, and retrospective signal audit logging ($T+30, T+90, T+180$). |
| **`social-sentiment-scanner`** | Evaluates retail and developer psychology from Discord channels, X (FinTwit), and YouTube transcripts. |
| **`technical-chart-analyst`** | Evaluates stock tickers using the 33 Fair Value Band (33 FVB EMA) and Multi-Timeframe BX Trender momentum histograms across a 4-zone posture model. |

---

### 2. 🧹 `mac/` (System Maintenance)

| Skill | Description |
| :--- | :--- |
| **`mac-disk-maintenance`** | Comprehensive 4-phase macOS disk audit and cleanup playbook. Diagnoses storage bloat (Xcode simulators, developer caches, `node_modules`, Electron caches) and generates tiered, safe cleanup menus. Includes `scripts/audit.py`. |

---

### 3. 🏛️ `q/` (Chief of Staff & Executive OS)

| Skill | Description |
| :--- | :--- |
| **`chief-of-staff-builder`** | Architect, scaffold, and operate an AI Chief of Staff (CoS) system. Includes scaffolding CLI (`scripts/scaffold_cos.py`), diagnostic testing (`scripts/test_subagents.py`), architecture guides, and domain templates (Personal, Professional, Wealth, Operator). |

---

## 🛠️ Usage

To use these skills in a specific workspace:
- **Antigravity Workspace**: Copy or register desired skills into `.agents/skills/<skill-name>/` at the project root.
- **Antigravity Global**: Place skills into `~/.gemini/config/skills/<skill-name>/` to make them globally accessible across all projects.
