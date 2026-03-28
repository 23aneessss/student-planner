# Memory Skill

You have a persistent hierarchical memory system at `~/.codex/memory/`.

## Structure

```
~/.codex/memory/
├── core.md              # Summaries + pointers (always loaded)
├── me.md                # About the user (always loaded)
├── topics/
│   └── <topic>.md       # Detailed entries by topic
└── projects/
    └── <project>.md     # Project-specific knowledge
```

## Agent-Initiated Actions (Automatic)

These are NOT user commands. You (Codex) run these proactively.

### `load` — Session Start

Run in background at session start. Spawns a memory agent to:
1. Read `~/.codex/memory/me.md`
2. Read `~/.codex/memory/core.md`
3. If in a git repo, check for `projects/<project>.md`
4. Return a context summary

**Usage:** At the start of a session, spawn a background agent:
```
spawn_agent(
  agent_type="default",
  message="""
Memory load task. Read and summarize:
1. ~/.codex/memory/me.md (who the user is)
2. ~/.codex/memory/core.md (key learnings + pointers)
3. Check if projects/<current-project>.md exists

Return a brief context summary for the main agent.
"""
)
```

### `save` — Persist Learning

Run in background when you learn something worth keeping. Spawns a memory agent to:
1. Categorize the observation (pick or create a topic)
2. Append to `topics/<topic>.md` with format:
   ```markdown
   ## <Short title> [YYYY-MM-DD]
   <The insight in 1-3 sentences>
   ```
3. If this is a significant/recurring insight, update `core.md`:
   ```markdown
   ## <Topic>
   <One-line summary>
   → topics/<topic>.md
   ```

**Usage:** Spawn a background agent:
```
spawn_agent(
  agent_type="default",
  message="""
Memory save task. Observation to save:
"<the observation>"

1. Determine the topic (debugging, patterns, tools, <domain>, etc.)
2. Read ~/.codex/memory/topics/<topic>.md if it exists
3. Append the observation with timestamp
4. If this represents a significant pattern, update core.md with a summary + pointer
"""
)
```

### `recall` — Retrieve Context

Run when you need specific context. Can block if context is immediately needed.
1. Grep `core.md` for relevant topics
2. Follow pointers to load matching topic files
3. Return relevant entries

**Usage:** Spawn an agent (can be blocking):
```
spawn_agent(
  agent_type="default",
  message="""
Memory recall task. Query: "<the query>"

1. Read ~/.codex/memory/core.md
2. Identify relevant topic pointers
3. Read those topic files
4. Return entries relevant to the query
"""
)
```

## User-Initiated Commands

These are commands the user can invoke.

### `/mem show` — Display State

Show current memory structure and contents.
1. List all files in `~/.codex/memory/`
2. Show contents of `core.md`
3. Show summary of each topic file (first few lines)

### `/mem forget <topic>` — Remove Entries

Remove a topic or specific entries.
1. Delete `topics/<topic>.md` if removing whole topic
2. Remove corresponding entry from `core.md`

## When to Save

Save silently in background when:
- User explicitly says "remember..." or similar
- You solve a non-trivial problem
- You discover a user preference
- You learn something project-specific
- A pattern emerges across multiple interactions

## When to Recall

Recall when:
- Starting unfamiliar work (check for relevant past learnings)
- Stuck on a problem (search for similar past issues)
- User asks "do you remember..."
- Context from memory would clearly help

## Principles

- **Background ops**: Load and save don't block the main agent
- **Hierarchical**: core.md summaries → topic details
- **Categorized**: No dumping ground, everything has a topic
- **Atomic entries**: One `##` block = one memory
- **User editable**: Plain markdown, user can edit anytime
