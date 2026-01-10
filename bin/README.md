# RC - React Component CLI

**Modern CLI tool for generating React components, pages, layouts, hooks, context providers, and Zustand stores.**

Generate production-ready React code with intelligent naming conventions, nested folder support, and comprehensive template options.

---

## ✨ Features

- 🎯 **6 Component Types**: Components, Pages, Layouts, Hooks, Context Providers, Zustand Stores
- 📁 **Nested Paths**: `rc c atoms/button` creates proper folder structures
- 🎨 **CSS Modules**: By default, with options for regular CSS or no CSS
- ⚡ **React Hooks**: Built-in templates for useState, useEffect, or both
- 🏪 **Zustand Integration**: Store templates with persist, immer, and devtools middleware
- 🔧 **Smart Naming**: Auto-converts kebab-case to PascalCase, camelCase, and useXxx patterns
- 📦 **Zero Dependencies**: Pure bash script, works anywhere
- 💡 **Comprehensive Help**: Built-in documentation for every command

---

## 🚀 Installation

### Prerequisites

- **Unix-like system** (Linux, macOS, WSL)
- **Bash** (already installed on most systems)
- **React project** to use it in (with `package.json`)

### Step 1: Create ~/bin directory (if it doesn't exist)

```bash
mkdir -p ~/bin
```

### Step 2: Get the rc script

**Option A: Download directly to ~/bin**
```bash
curl -o ~/bin/rc https://raw.githubusercontent.com/YOUR_USERNAME/REPO_NAME/main/bin/rc
chmod +x ~/bin/rc
```

**Option B: Clone the repository (preserves executable permissions)**
```bash
git clone https://github.com/YOUR_USERNAME/REPO_NAME.git
cp REPO_NAME/bin/rc ~/bin/rc
# No chmod needed - git preserves executable bit
```

**Option C: Manual download**
```bash
# Download rc file manually, then:
mv ~/Downloads/rc ~/bin/rc
chmod +x ~/bin/rc
```

### Step 3: Add ~/bin to PATH (if not already there)

**Check if ~/bin is in your PATH:**
```bash
echo $PATH | grep "$HOME/bin"
```

**If nothing appears, add ~/bin to PATH:**

For **Zsh** (default on macOS):
```bash
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

For **Bash**:
```bash
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### Step 4: Verify installation

```bash
rc --version
```

You should see: `rc version 2.0.0`

---

## 📚 Usage

### Basic Syntax

```bash
rc <command> <name> [options]
```

### Commands

| Command | Description | Output Folder |
|---------|-------------|---------------|
| `c`, `component` | Create a component | `src/components/` |
| `p`, `page` | Create a page | `src/pages/` |
| `l`, `layout` | Create a layout (with children prop) | `src/layouts/` |
| `h`, `hook` | Create a custom hook | `src/hooks/` |
| `cx`, `context` | Create a context provider | `src/context/` |
| `s`, `store` | Create a Zustand store | `src/stores/` |

---

## 📖 Examples

### Components

```bash
# Basic component
rc c button
# Creates: src/components/button/Button.jsx + Button.module.css

# Component with useState
rc c counter --state
# Includes: import { useState } from 'react'

# Component with useEffect
rc c data-fetcher --effect
# Includes: import { useEffect } from 'react'

# Component with both hooks
rc c form --state-effect
# Includes: import { useState, useEffect } from 'react'

# Nested component (atoms pattern)
rc c atoms/button
# Creates: src/components/atoms/button/Button.jsx

# Regular CSS instead of CSS modules
rc c card --css
# Creates: Card.css instead of Card.module.css

# No CSS file
rc c modal --no-css
# Creates only the .jsx file
```

### Pages

```bash
# Basic page
rc p home
# Creates: src/pages/home/Home.jsx

# Page with state
rc p dashboard --state
# Creates: src/pages/dashboard/Dashboard.jsx with useState

# Nested page
rc p user/profile
# Creates: src/pages/user/profile/UserProfile.jsx
```

### Layouts

```bash
# Basic layout (automatically includes children prop)
rc l main-layout
# Creates: src/layouts/main-layout/MainLayout.jsx

# Layout with state
rc l admin/dashboard --state
# Creates: src/layouts/admin/dashboard/AdminDashboard.jsx
```

### Hooks

```bash
# Basic hook (auto-prefixes with "use")
rc h counter
# Creates: src/hooks/useCounter.js

# Hook with useState
rc h auth --state
# Creates: src/hooks/useAuth.js with useState

# Hook with useEffect
rc h fetch-data --effect
# Creates: src/hooks/useFetchData.js with useEffect

# Name already has "use" prefix (won't duplicate)
rc h use-storage
# Creates: src/hooks/useStorage.js
```

### Context Providers

```bash
# Context with state
rc cx theme
# Creates: src/context/theme/ThemeProvider.jsx
# Exports: ThemeProvider and useTheme hook

# Context without state
rc cx settings --no-state
# Creates: src/context/settings/SettingsProvider.jsx
```

### Zustand Stores

```bash
# Basic store
rc s user
# Creates: src/stores/userStore.js
# Exports: useUserStore

# Store with localStorage persistence
rc s cart --persist
# Creates store with persist middleware

# Store with immer (mutable updates)
rc s todos --immer
# Creates store with immer middleware

# Store with Redux DevTools
rc s app --devtools
# Creates store with devtools middleware
```

---

## 🎨 Naming Conventions

The tool automatically handles naming conversions:

| Input | Component Name | File Name | Folder Name |
|-------|---------------|-----------|-------------|
| `button` | `Button` | `Button.jsx` | `button/` |
| `user-card` | `UserCard` | `UserCard.jsx` | `user-card/` |
| `atoms/button` | `Button` | `Button.jsx` | `atoms/button/` |

**Hooks:** Always prefixed with `use`
- Input: `counter` → Output: `useCounter`
- Input: `use-auth` → Output: `useAuth` (doesn't duplicate "use")

**Stores:** camelCase with "Store" suffix
- Input: `user` → File: `userStore.js` → Hook: `useUserStore`
- Input: `shopping-cart` → File: `shoppingCartStore.js` → Hook: `useShoppingCartStore`

---

## ⚙️ Options

### Component/Page/Layout Options

| Flag | Description |
|------|-------------|
| `--state` | Add `useState` hook |
| `--effect` | Add `useEffect` hook |
| `--state-effect` | Add both `useState` and `useEffect` |
| `--css` | Use regular CSS instead of CSS modules |
| `--no-css` | Don't create CSS file |

### Hook Options

| Flag | Description |
|------|-------------|
| `--state` | Include `useState` |
| `--effect` | Include `useEffect` |
| `--state-effect` | Include both hooks |

### Context Options

| Flag | Description |
|------|-------------|
| `--no-state` | Create context without state management |

### Store Options

| Flag | Description |
|------|-------------|
| `--persist` | Add Zustand persist middleware (localStorage) |
| `--immer` | Add immer middleware (mutable updates) |
| `--devtools` | Add Redux DevTools integration |

---

## 🛠️ Template Details

### What's Required vs Example

All generated templates include clear comments indicating:
- **`// EXAMPLE ...`** - Placeholder code to customize for your needs
- **`// REQUIRED: ...`** - Essential code that should remain

**Example from Zustand store:**
```javascript
const useUserStore = create((set) => ({
  // EXAMPLE State - Replace with your actual state properties
  count: 0,
  user: null,

  // EXAMPLE Actions - Replace with your actual actions
  // Use set() to update state: set({ propertyName: newValue })
  increment: () => set((state) => ({ count: state.count + 1 })),
  setUser: (user) => set({ user }),
}));
```

The `count`, `increment`, etc. are **examples only** - replace with your actual business logic!

---

## 📋 Requirements

**For the script to work:**
1. You must be in a **React project root** (directory with `package.json`)
2. The script validates this before creating files

**Supported project structures:**
- Create React App
- Vite
- Next.js (though Next.js has its own conventions)
- Any React project with standard folder structure

---

## 🆘 Getting Help

```bash
# Main help
rc --help

# Command-specific help
rc c --help          # Component help
rc p --help          # Page help
rc l --help          # Layout help
rc h --help          # Hook help
rc cx --help         # Context help
rc s --help          # Store help
```

---

## 🔧 Troubleshooting

### "command not found: rc"

Your `~/bin` directory is not in PATH.

**Solution:**
```bash
# For Zsh
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# For Bash
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### "No package.json found"

You're not in a React project root.

**Solution:**
```bash
cd /path/to/your/react/project
rc c button  # Try again
```

### "File already exists"

The component/hook/store you're trying to create already exists.

**Solution:**
- Use a different name, or
- Delete the existing file if you want to replace it

---

## 🌟 Advanced Features

### Nested Folder Structures

Create organized component hierarchies:

```bash
rc c atoms/button
rc c atoms/input
rc c molecules/form
rc c organisms/header
rc c templates/main-layout
```

Creates:
```
src/components/
├── atoms/
│   ├── button/Button.jsx
│   └── input/Input.jsx
├── molecules/
│   └── form/Form.jsx
├── organisms/
│   └── header/Header.jsx
└── templates/
    └── main-layout/MainLayout.jsx
```

### Combining Options

```bash
# Component with state, effect, and regular CSS
rc c complex-form --state-effect --css

# Page without CSS
rc p thank-you --no-css

# Nested layout with state
rc l admin/dashboard --state
```

---

## 📝 License

MIT License - Feel free to use, modify, and share!

---

## 🤝 Contributing

Found a bug or have a feature request? Contributions welcome!

---

## 💡 Tips

1. **Use nested paths** for better organization (Atomic Design, feature folders, etc.)
2. **Read the generated comments** - They explain what to customize vs what's required
3. **Check the help** - Every command has detailed documentation: `rc <command> --help`
4. **Start simple** - Use basic templates first, add flags as needed
5. **CSS modules are default** - They're the modern React standard for scoped styles

---

**Happy coding! 🚀**
