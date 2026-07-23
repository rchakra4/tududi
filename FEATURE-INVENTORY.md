# Tududi — Feature Inventory (Current State)

> **Purpose:** Current-state, user-facing feature inventory for product/roadmap planning.
> **Scope:** What ships today, verified against the codebase (not just docs).
> **Last compiled:** 2026-07-23

**Maturity legend:**

| Badge | Meaning |
| --- | --- |
| 🟢 GA | Fully implemented and on by default |
| 🚩 Gated | Fully implemented but hidden behind a deployment feature flag (off by default) |
| 🟡 Partial | Works, but a documented sub-capability is stubbed or simplified |
| ⚪ Off-by-default | Implemented, but the user must opt in via a setting |
| 🔴 Stub | Placeholder / not functional |

**Feature flags (deployment-level, set via server env vars; no runtime/per-user toggle):** `FF_ENABLE_BACKUPS`, `FF_ENABLE_CALENDAR`, `FF_ENABLE_HABITS` — all default **off**.

---

## 1. Core Task Management

| Feature | Description | Key Capabilities | Maturity | Notes / Limits |
| --- | --- | --- | --- | --- |
| Tasks | Core actionable unit; name is the only required field | 7-state lifecycle (Not Started, In Progress, Done, Archived, Waiting, Cancelled, Planned); 3 priority levels (Low/Med/High) | 🟢 GA | Priority is sort/visual only |
| Due dates & Defer-until | Independent scheduling fields | `due_date` for deadlines; `defer_until` fully hides a task until its date passes, then auto-surfaces it with a notification | 🟢 GA | Deferred-task surfacing runs on a 5-min cron |
| Subtasks | One level of hierarchy under a task | Drag-to-reorder; cascade-delete with parent; parent status change cascades to subtasks (Done→all Done, Cancelled→cancel open) | 🟢 GA | Only **one** level deep. "All subtasks done → auto-complete parent" is **not** wired up (dead code) |
| Attachments | File uploads per task | 10 MB/file, mime-type allow-list; permission-gated (rw to add/delete, ro to download) | 🟢 GA | Hard cap **20 attachments/task** |
| Completion history | Immutable per-task audit log | `TaskTimeline` view of status changes/events; recurring completions logged separately | 🟢 GA | — |
| Task permissions | Ownership + inherited project sharing | Standalone tasks owner-only; project-assigned tasks inherit project share level | 🟢 GA | Deletion is permanent (cascades subtasks + attachments + events) |

## 2. Recurring Tasks

| Feature | Description | Key Capabilities | Maturity | Notes / Limits |
| --- | --- | --- | --- | --- |
| Recurring tasks | A single task that advances itself on completion (no copy spam) | Patterns: daily, weekly (single or multi-weekday), monthly (fixed day), monthly-Nth-weekday, monthly-last-day; "every N" interval; optional end date | 🟢 GA | Same task ID is reused across occurrences |
| Next-date modes | How the next occurrence is scheduled | Due-date-based (default) or completion-date-based | 🟢 GA | — |
| Virtual occurrences | Future instances previewed without creating rows | ~6–7 look-ahead previews in Today/Upcoming; overdue recurrences skip forward to next future date | 🟢 GA | Dual model under the hood (virtual + some materialized child instances) |

## 3. Organization & Hierarchy

| Feature | Description | Key Capabilities | Maturity | Notes / Limits |
| --- | --- | --- | --- | --- |
| Projects | Mid-tier container (Areas > Projects > Tasks/Notes) | Description, area, priority, due date, banner image, sidebar pinning, per-project completed-task visibility & sort order; 6 status states | 🟢 GA | — |
| Project progress | Auto-computed rollups | Task counts, completion %, **stalled detection** (active project with 0 active tasks) | 🟢 GA | — |
| Project sharing | Multi-user collaboration | Share at `ro` / `rw`; access cascades to all tasks/notes/subtasks; owner-only delete & share management | 🟢 GA | — |
| Areas | Top-level life-domain grouping | Name + description only; alphabetical grid; used to group/filter Projects | 🟢 GA | **Not shareable** (unlike projects); delete orphans projects (preserves them) |
| Tags | Flat, cross-entity labels (tasks/notes/projects) | Auto-created on use; rename/delete; per-tag detail page with filter/sort/group/search; autocomplete input | 🟢 GA | Max 10 tags/item; no colors/hierarchy; user-scoped (not shared even on shared projects) |

## 4. Views, Navigation & Search

| Feature | Description | Key Capabilities | Maturity | Notes / Limits |
| --- | --- | --- | --- | --- |
| Today page | Single-day dashboard | Four dedup'd sections — Overdue, Planned, Suggested, Completed; weekly completion chart; progress bar; daily quote; per-user section toggles; timezone-aware | 🟢 GA | Suggestions & metrics off by default; 20/section pagination |
| Upcoming view | Forward 7-day, grouped-by-day board | Due tasks, deferred-becoming-available, recurring occurrences, "No Due Date" group; status filter + sort; upcoming projects | 🟢 GA | No task creation/search/pagination in-view |
| Calendar | Task-driven month/week/day calendar | Tasks placed by due/defer/created date; **drag-and-drop reschedule**; click → task detail modal | 🚩 Gated | `FF_ENABLE_CALENDAR`. No event creation, no recurring-event render, no external sync |
| Views (saved searches) | Personal "smart folders" that re-run live | Save from Universal Search; pin to sidebar + drag-reorder; per-session sort/group/status; deep-linkable | 🟢 GA | Sort/group/status not persisted (per-session) |
| Universal Search | Global search modal + engine behind Views | Searches Tasks/Projects/Areas/Notes/Tags; filters by priority, due, defer, tags (AND), and extras (recurring, overdue, has-content, deferred, has-tags, assigned-to-project) | 🟢 GA | Substring match (not fuzzy); tag match exact |

## 5. Capture & Notes

| Feature | Description | Key Capabilities | Maturity | Notes / Limits |
| --- | --- | --- | --- | --- |
| Inbox | Zero-friction quick-capture holding area | Smart parsing of `#hashtags`, `+project` refs, and URLs; suggests Task vs Note vs Project (verb detection via NLP); one-click convert; URL→Note auto-bookmarks | 🟢 GA | 15s background poll; 20-item pagination; no in-inbox search/filter |
| Notes | Markdown reference/knowledge store | GitHub-flavored Markdown render; 1s debounced auto-save; 0-or-1 project link; multi-tag; 10 preset colors; full-screen focus mode; client-side search/sort | 🟢 GA | No versioning/undo, no attachments, last-write-wins, no pagination |
| URL link preview | Metadata enrichment for pasted links | Extracts title (og/twitter/`<title>`), image, description; YouTube special-casing; multi-tier fetch with proxy fallback | 🟢 GA | Enriches links in inbox/tasks/notes |

## 6. Habits & Productivity

| Feature | Description | Key Capabilities | Maturity | Notes / Limits |
| --- | --- | --- | --- | --- |
| Habits | Recurring behavior tracking (tasks with `habit_mode`) | Target frequency (N× daily/weekly/monthly); flexible vs strict scheduling; streak mode (calendar vs scheduled); tracks current/best streak, total & last completion; dashboard + "Habits Today" widget; stats endpoint | 🟡 Partial | `FF_ENABLE_HABITS`. "Scheduled" streak mode is a **stub** (falls back to calendar streak) |
| Productivity Assistant | Actionable insight generator on Today page | Flags stalled projects, projects lacking a next action, tasks-that-are-really-projects, vague tasks, stale/overdue tasks; expandable, links to items | ⚪ Off-by-default | Toggled per-user |
| Metrics dashboard | Standalone task/project metrics cards | — | 🔴 Stub | `Metrics/*` components are **empty (0 lines)**. Only inline Today/Project metrics + weekly chart exist |

## 7. Notifications & Reminders

| Feature | Description | Key Capabilities | Maturity | Notes / Limits |
| --- | --- | --- | --- | --- |
| In-app notifications | Bell-icon notification center | Unread badge (30s poll); mark read/unread, mark-all, dismiss; deep-link to task/project; 10 typed events, 4 severity levels | 🟢 GA | — |
| Notification channels | Multi-channel delivery + preferences | In-app (always), Email (if configured), Telegram (if configured); per-type channel matrix in Profile; "Send Test" tool | 🟢 GA | **Push** shown as "Coming Soon" |
| Automated reminders | Scheduler-generated alerts | Due-soon/overdue tasks, due-soon/overdue projects, "task now active" on defer expiry; de-duplicated | 🟢 GA | Cron-driven (5–15 min cadences) |

## 8. Integrations & API

| Feature | Description | Key Capabilities | Maturity | Notes / Limits |
| --- | --- | --- | --- | --- |
| Telegram bot | Two-way messaging integration | Message→Inbox capture; `/start` `/help`; per-user bot token setup with verification; optional user whitelist | 🟢 GA | 5s polling; setup in Profile |
| Telegram digest | Scheduled task-summary push | "Today's Plan" (due today, in-progress, up to 5 suggested, completed-today); frequencies 1h–weekly; "Send Test Summary" | 🟢 GA | Cron-scheduled (e.g. daily 07:00) |
| REST API + tokens | Programmatic access | Personal Access Tokens (`tt_…`) with name/expiry, list/revoke/delete, last-used tracking; Swagger docs | 🟢 GA | Token endpoints rate-limited |

## 9. User, Auth & Admin

| Feature | Description | Key Capabilities | Maturity | Notes / Limits |
| --- | --- | --- | --- | --- |
| Registration & verification | Account signup flow | Registration **disabled by default** (admin toggle); email verification required before login (needs email service) | 🟢 GA | If email disabled, registration rolls back |
| Authentication | Session-based login | Cookie sessions; rate-limited login; logout destroys session; blocked until email verified | 🟢 GA | Plus API-token auth (§8) |
| Profile & preferences | Per-user settings | Name, appearance (light/dark), language, timezone, first day of week; avatar upload (5 MB); password change; many feature toggles (pomodoro, shortcuts, task intelligence, etc.) | 🟢 GA | — |
| Admin console | User administration | List/create/edit/delete users; set/unset admin role; toggle global registration | 🟢 GA | First-user bootstrap self-assigns admin; can't delete own account |

## 10. Data & Platform

| Feature | Description | Key Capabilities | Maturity | Notes / Limits |
| --- | --- | --- | --- | --- |
| Backup & restore (user) | Per-user data export/import | Export areas/projects/tasks/tags/notes/inbox/views (JSON, optional gzip); last 5 auto-saved server-side; validate-then-import with **merge** mode | 🚩 Gated | `FF_ENABLE_BACKUPS`. Import max 100 MB |
| Automatic DB backups (ops) | Server-level SQLite safety net | Auto-created before migrations & on startup; retention policy; restored via file/volume swap | 🟢 GA | Ops-level, not a user UI |
| Daily quotes | Motivational quote surface | Random quote on Today page; loaded from host-editable YAML (falls back to built-ins) | ⚪ Off-by-default | On by default via Today settings |
| Multi-language (i18n) | Localized UI | **25 languages**; on-demand locale loading; auto-detect (query→cookie→localStorage→browser); switch in Profile | 🟢 GA | Date localization covers a subset of languages; rest fall back to en-US |

---

## Roadmap-Relevant Gaps & Caveats

Items worth flagging when planning, based on code (not docs):

1. **Metrics dashboard is not built** — the dedicated `Metrics/*` components are empty stubs. Only inline Today-page metrics, project metrics, and a weekly completion chart exist today. A standalone analytics view is greenfield.
2. **Habits "scheduled" streak mode is a placeholder** — it silently falls back to calendar-day streaks (Phase-2 TODO in code).
3. **Push notifications are stubbed** — surfaced as "Coming Soon" in the preferences matrix.
4. **Three flagship features are flag-gated off by default** — Calendar, Habits, and user-facing Backups require deployment env vars. No runtime or per-user enablement exists.
5. **Auto-complete parent from subtasks is dead code** — the handler exists but is never invoked; completing all subtasks does not roll up to the parent.
6. **Calendar is task-driven only** — no standalone events, recurring-event rendering, or external calendar sync.
7. **Collaboration is project-scoped and `ro`/`rw` only** — Areas can't be shared; tags are user-private even on shared projects; no per-field or granular permissions.
8. **Notes and several list views load everything client-side** (no pagination) — a scale consideration for power users with large datasets.

---

## Recently Shipped / Recently Stabilized

Based on the local git history (this repo is a fork). **Note on timeframe:** the actual last calendar month contains only local fork commits (workshop setup, file logging, `.claude` config) — no product work. The most recent *real* PR activity is inherited from upstream and clusters in a ~3-week burst, **Feb 24 – Mar 14, 2026** (~42 squash-merged PRs). That burst was a **hardening/stabilization phase**, not feature expansion — ~90% bug fixes.

### Newly shipped features & capabilities (this window)

| PR | Date | What shipped | Related section | Scope |
| --- | --- | --- | --- | --- |
| #891 — Notes focus mode | 2026-03-03 | New distraction-free full-screen note editor | §5 Notes | Substantial (new component) |
| #942 — Inbox URL detection | 2026-03-14 | Inbox smart-parsing now recognizes URLs (feeds URL→Note auto-bookmark) | §5 Inbox | Small |
| #913 — Load areas into store | 2026-03-06 | Areas loaded into frontend store (enables reliable area filter/group) | §3 Areas | Enabling / trivial |
| #856 — Auto-focus new task | 2026-02-24 | Cursor auto-focuses the new-task input | Core task UX | Minor polish |

> #939 (LLM development documentation) also landed in this window, but it is the developer `docs/` guide — not a user-facing feature.

### Recently stabilized (heavy fix activity — treat as "recently landed, verify quality")

The concentration of bug fixes signals which features were freshly shipped and still shaking out as of the fork point:

| Feature area | Fix volume | Representative PRs | Roadmap implication |
| --- | --- | --- | --- |
| **Recurring tasks** | High (5+) | #844/#890 (bi-weekly reverting to weekly), #859 (Sunday monthly-weekday), #886 (name/subtasks lost on status change), #910 (defer validation) | Most volatile area; validate edge cases before building on it |
| **Subtasks** | High (6+) | #920/#936/#932 (persistence), #931/#930 (ordering), #935 (icons), #839 (visibility) | Freshly stabilized; regression-test heavily |
| **Today view** | Medium (3+) | #892 (deferred tasks post-defer), #894 (in-progress tasks), #928 (projects with due dates) | Section/filter logic recently corrected |
| **Tags** | Medium | #843 (link refresh), #861 (validation messages), #933/#934 (completed projects under Open filter) | Minor polish, stabilizing |
| **Telegram / Upcoming / Notifications** | Low (1 each) | #860 (Telegram escaping), #928 (Upcoming projects), #945 (notification dedup) | Isolated fixes |

**Takeaway for roadmap:** As of the fork point, the project was consolidating rather than expanding — one real new feature (Notes focus mode) plus a large volume of fixes concentrated on **recurring tasks** and **subtasks**. Treat those two areas as recently-landed and least-proven; treat the rest of the inventory as comparatively mature.
