# rcc → rc Migration Guide

## Overview

The `rc` command is a modern replacement for `rcc` with a cleaner subcommand architecture and new features. Both commands will continue to work during the migration period.

---

## Command Mapping

### Basic Commands

| Old (rcc)           | New (rc)                    | Notes |
|---------------------|-----------------------------|-------|
| `rcc button`        | `rc c button`               | Component in src/components/ |
| `rcc -s counter`    | `rc c counter --state`      | Component with useState |
| `rcc -e fetcher`    | `rc c fetcher --effect`     | Component with useEffect |
| `rcc -se form`      | `rc c form --state-effect`  | Component with both hooks |
| `rcc -p home`       | `rc p home`                 | Page in src/pages/ |
| `rcc -h use-auth`   | `rc h auth`                 | Hook in src/hooks/ |
| `rcc -c auth`       | `rc cx auth`                | Context provider in src/context/ |

### New Features in rc

Commands that didn't exist in rcc:

| Command                  | Description |
|--------------------------|-------------|
| `rc l main-layout`       | Create layout component (with children prop) |
| `rc s user`              | Create Zustand store (basic) |
| `rc s cart --persist`    | Create store with localStorage persistence |
| `rc s todos --immer`     | Create store with immer middleware |
| `rc s app --devtools`    | Create store with Redux DevTools |

---

## Folder Structure Changes

### Components, Pages, Layouts
✅ **No change** - Still creates folder-based structure:
- `rcc button` → `src/components/button/Button.jsx`
- `rc c button` → `src/components/button/Button.jsx`

### Hooks
⚠️ **Changed** - No longer creates subfolders:
- `rcc -h use-auth` → `src/hooks/useAuth.js` (in subfolder)
- `rc h auth` → `src/hooks/useAuth.js` (directly in hooks/)

### Context
⚠️ **Changed** - Different folder location:
- `rcc -c auth` → `src/components/auth/` or similar
- `rc cx auth` → `src/context/auth/AuthProvider.jsx`

### Stores (NEW)
✨ **New feature** - Dedicated stores folder:
- `rc s user` → `src/stores/userStore.js`

---

## Naming Convention Changes

### Hooks
The `use` prefix is now **auto-applied**:
```bash
# Old (rcc)
rcc -h use-auth          # Must include "use"

# New (rc)
rc h auth                # Automatically becomes "useAuth"
rc h use-auth            # Also works (won't duplicate "use")
```

### Stores
Store names are converted to **camelCase** with "Store" suffix:
```bash
rc s user                # Creates: userStore.js (exports useUserStore)
rc s shopping-cart       # Creates: shoppingCartStore.js (exports useShoppingCartStore)
```

---

## Nested Paths (NEW Feature)

The new `rc` command supports nested folder structures:

```bash
# Create component in nested folder
rc c atoms/button        # src/components/atoms/button/Button.jsx

# Create page in nested folder
rc p user/profile        # src/pages/user/profile/UserProfile.jsx

# Create layout in nested folder
rc l admin/dashboard     # src/layouts/admin/dashboard/AdminDashboard.jsx
```

This wasn't possible with `rcc`.

---

## Flag Changes

### Consistent Across All Component Types

Component, Page, and Layout all support the same flags:
- `--state` - Add useState
- `--effect` - Add useEffect
- `--state-effect` - Add both
- `--css` - Use regular CSS instead of modules
- `--no-css` - Don't create CSS file

### New Flags

**Context:**
- `--no-state` - Create context without state management

**Stores:**
- `--persist` - Add Zustand persist middleware
- `--immer` - Add Zustand immer middleware
- `--devtools` - Add Redux DevTools middleware

---

## Help System

The help system is much more comprehensive in `rc`:

```bash
# Main help
rc --help

# Command-specific help
rc c --help              # Component help
rc p --help              # Page help
rc l --help              # Layout help
rc h --help              # Hook help
rc cx --help             # Context help
rc s --help              # Store help
```

---

## Quick Reference Card

### Most Common Use Cases

```bash
# Components
rc c button                    # Basic component
rc c atoms/button --state      # Nested component with state
rc c form --state-effect       # With both hooks

# Pages
rc p home                      # Basic page
rc p user/profile --state      # Nested page with state

# Layouts
rc l main                      # Main layout (includes children prop)
rc l admin/dashboard           # Admin layout

# Hooks
rc h auth                      # Custom hook (becomes useAuth)
rc h fetch-data --effect       # Hook with useEffect

# Context
rc cx theme                    # Theme context provider
rc cx auth --no-state          # Context without state

# Stores
rc s user                      # Basic Zustand store
rc s cart --persist            # Store with localStorage
rc s todos --immer             # Store with immer (mutable updates)
```

---

## Migration Timeline

### Phase 1: Parallel Usage (Current)
- ✅ Both `rcc` and `rc` are available
- ✅ Use `rc` for new components
- ✅ Continue using `rcc` if preferred

### Phase 2: Gradual Transition (Recommended)
- 🔄 Start using `rc` exclusively for new work
- 🔄 Update muscle memory and aliases
- 🔄 Explore new features (layouts, stores, nested paths)

### Phase 3: Full Migration (Future)
- ⏰ Eventually `rcc` may be deprecated
- ⏰ All workflows should use `rc`

---

## Benefits of Migrating

1. **Clearer Commands** - `rc c` vs `rcc -f` is more explicit
2. **New Features** - Layouts and Zustand stores
3. **Nested Paths** - `atoms/button` support
4. **Better Organization** - Separate folders for context and stores
5. **Comprehensive Help** - Better documentation built-in
6. **Modern Architecture** - Subcommand pattern is more extensible

---

## Troubleshooting

### "Unknown subcommand" Error
Make sure you're using the subcommand format:
```bash
rc c button           # ✅ Correct
rc button             # ❌ Wrong (missing subcommand)
```

### "No package.json found" Error
Both `rcc` and `rc` require you to be in a React project root:
```bash
cd /path/to/react/project
rc c button           # ✅ Works
```

### Help Not Working
If help doesn't show, make sure the script is executable:
```bash
chmod +x ~/bin/rc
```

---

## Getting Help

- Main help: `rc --help`
- Command help: `rc <command> --help`
- Examples in every help message
- This migration guide: `cat ~/bin/RCC_TO_RC_MIGRATION.md`

---

## Feedback

If you encounter issues or have suggestions for the `rc` command, please provide feedback!
