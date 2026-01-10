#!/bin/bash

# React Component Creator (RCC)
# Usage: rcc [options] component-name

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
COMPONENT_TYPE="functional"
COMPONENT_DIR="src/components"
CSS_TYPE="module"

# Help function
show_help() {
    echo "React Component Creator (RCC)"
    echo ""
    echo "Usage: rcc [options] component-name"
    echo ""
    echo "Options:"
    echo "  -f, --functional      Create functional component (default)"
    echo "  -s, --state           Create functional component with useState"
    echo "  -e, --effect          Create functional component with useEffect"
    echo "  -se, --state-effect   Create component with useState and useEffect"
    echo "  -c, --context         Create context component"
    echo "  -h, --hook            Create custom hook"
    echo "  -p, --page            Create page component (in src/pages)"
    echo "  -d, --dir PATH        Specify custom directory (default: src/components)"
    echo "  --css                 Use regular CSS instead of CSS modules"
    echo "  --no-css              Don't create CSS file"
    echo "  --help                Show this help message"
    echo ""
    echo "Examples:"
    echo "  rcc button                    # Creates Button component with module.css"
    echo "  rcc my-button                 # Creates MyButton component (converts kebab-case)"
    echo "  rcc -s counter                # With useState"
    echo "  rcc -e data-fetcher           # With useEffect"
    echo "  rcc -p home-page              # Page component"
    echo "  rcc --css user-card           # With regular CSS"
    echo "  rcc --no-css modal            # Without CSS file"
    echo "  rcc -d src/components/forms login-form"
}

# Function to convert kebab-case to PascalCase
kebab_to_pascal() {
    echo "$1" | sed -r 's/(^|-)([a-z])/\U\2/g'
}

# Function to create CSS file
create_css_file() {
    local css_path="$1"
    local component_name_kebab="$2"

    cat > "$css_path" << EOF
.${component_name_kebab} {
  /* Add your styles here */
}
EOF
}

# Parse arguments
CREATE_CSS=true
while [[ $# -gt 0 ]]; do
    case $1 in
        -f|--functional)
            COMPONENT_TYPE="functional"
            shift
            ;;
        -s|--state)
            COMPONENT_TYPE="state"
            shift
            ;;
        -e|--effect)
            COMPONENT_TYPE="effect"
            shift
            ;;
        -se|--state-effect)
            COMPONENT_TYPE="state-effect"
            shift
            ;;
        -c|--context)
            COMPONENT_TYPE="context"
            shift
            ;;
        -h|--hook)
            COMPONENT_TYPE="hook"
            CREATE_CSS=false
            shift
            ;;
        -p|--page)
            COMPONENT_TYPE="page"
            COMPONENT_DIR="src/pages"
            shift
            ;;
        -d|--dir)
            COMPONENT_DIR="$2"
            shift 2
            ;;
        --css)
            CSS_TYPE="regular"
            shift
            ;;
        --no-css)
            CREATE_CSS=false
            shift
            ;;
        --help)
            show_help
            exit 0
            ;;
        *)
            COMPONENT_NAME_KEBAB="$1"
            shift
            ;;
    esac
done

# Check if component name is provided
if [ -z "$COMPONENT_NAME_KEBAB" ]; then
    echo -e "${RED}Error: Component name is required${NC}"
    echo "Run 'rcc --help' for usage information"
    exit 1
fi

# Check if we're in a React project
if [ ! -f "package.json" ]; then
    echo -e "${RED}Error: No package.json found. Are you in a React project root?${NC}"
    exit 1
fi

# Convert kebab-case to PascalCase
COMPONENT_NAME=$(kebab_to_pascal "$COMPONENT_NAME_KEBAB")

# Handle hooks differently (no folder, no CSS)
if [ "$COMPONENT_TYPE" = "hook" ]; then
    # Hooks start with 'use'
    if [[ ! $COMPONENT_NAME == use* ]]; then
        COMPONENT_NAME="use${COMPONENT_NAME}"
    fi

    # Create hooks directory if it doesn't exist
    HOOKS_DIR="src/hooks"
    mkdir -p "$HOOKS_DIR"
    FILE_PATH="$HOOKS_DIR/${COMPONENT_NAME}.js"

    # Check if file already exists
    if [ -f "$FILE_PATH" ]; then
        echo -e "${RED}Error: Hook already exists at $FILE_PATH${NC}"
        exit 1
    fi

    cat > "$FILE_PATH" << EOF
import { useState, useEffect } from 'react';

const ${COMPONENT_NAME} = () => {
  const [state, setState] = useState(null);

  useEffect(() => {
    // Hook logic here
  }, []);

  return { state, setState };
};

export default ${COMPONENT_NAME};
EOF

    echo -e "${GREEN}✓ Custom hook created successfully!${NC}"
    echo -e "${YELLOW}Path:${NC} $FILE_PATH"
    exit 0
fi

# Create component folder
COMPONENT_FOLDER="$COMPONENT_DIR/$COMPONENT_NAME_KEBAB"
mkdir -p "$COMPONENT_FOLDER"

# Set file paths
JSX_FILE="$COMPONENT_FOLDER/${COMPONENT_NAME}.jsx"

# Determine CSS file name and import statement
if [ "$CREATE_CSS" = true ]; then
    if [ "$CSS_TYPE" = "module" ]; then
        CSS_FILE="$COMPONENT_FOLDER/${COMPONENT_NAME}.module.css"
        CSS_IMPORT="import styles from './${COMPONENT_NAME}.module.css';"
        CLASS_NAME="styles.${COMPONENT_NAME_KEBAB//-}"
    else
        CSS_FILE="$COMPONENT_FOLDER/${COMPONENT_NAME}.css"
        CSS_IMPORT="import './${COMPONENT_NAME}.css';"
        CLASS_NAME="\"${COMPONENT_NAME_KEBAB}\""
    fi
fi

# Check if files already exist
if [ -f "$JSX_FILE" ]; then
    echo -e "${RED}Error: Component already exists at $JSX_FILE${NC}"
    exit 1
fi

# Generate component based on type
case $COMPONENT_TYPE in
    functional)
        cat > "$JSX_FILE" << EOF
${CREATE_CSS:+$CSS_IMPORT}

const ${COMPONENT_NAME} = () => {
  return (
    <div className={${CLASS_NAME:-\"${COMPONENT_NAME_KEBAB}\"}}>
      <h1>The ${COMPONENT_NAME} works</h1>
    </div>
  );
};

export default ${COMPONENT_NAME};
EOF
        ;;

    state)
        cat > "$JSX_FILE" << EOF
import { useState } from 'react';
${CREATE_CSS:+$CSS_IMPORT}

const ${COMPONENT_NAME} = () => {
  const [state, setState] = useState('');

  return (
    <div className={${CLASS_NAME:-\"${COMPONENT_NAME_KEBAB}\"}}>
      <h1>The ${COMPONENT_NAME} works</h1>
    </div>
  );
};

export default ${COMPONENT_NAME};
EOF
        ;;

    effect)
        cat > "$JSX_FILE" << EOF
import { useEffect } from 'react';
${CREATE_CSS:+$CSS_IMPORT}

const ${COMPONENT_NAME} = () => {
  useEffect(() => {
    // Effect logic here

    return () => {
      // Cleanup logic here
    };
  }, []);

  return (
    <div className={${CLASS_NAME:-\"${COMPONENT_NAME_KEBAB}\"}}>
      <h1>The ${COMPONENT_NAME} works</h1>
    </div>
  );
};

export default ${COMPONENT_NAME};
EOF
        ;;

    state-effect)
        cat > "$JSX_FILE" << EOF
import { useState, useEffect } from 'react';
${CREATE_CSS:+$CSS_IMPORT}

const ${COMPONENT_NAME} = () => {
  const [state, setState] = useState('');

  useEffect(() => {
    // Effect logic here

    return () => {
      // Cleanup logic here
    };
  }, []);

  return (
    <div className={${CLASS_NAME:-\"${COMPONENT_NAME_KEBAB}\"}}>
      <h1>The ${COMPONENT_NAME} works</h1>
    </div>
  );
};

export default ${COMPONENT_NAME};
EOF
        ;;

    context)
        cat > "$JSX_FILE" << EOF
import React, { createContext, useContext, useState } from 'react';

const ${COMPONENT_NAME}Context = createContext();

export const use${COMPONENT_NAME} = () => {
  const context = useContext(${COMPONENT_NAME}Context);
  if (!context) {
    throw new Error('use${COMPONENT_NAME} must be used within ${COMPONENT_NAME}Provider');
  }
  return context;
};

export const ${COMPONENT_NAME}Provider = ({ children }) => {
  const [state, setState] = useState(null);

  const value = {
    state,
    setState,
  };

  return (
    <${COMPONENT_NAME}Context.Provider value={value}>
      {children}
    </${COMPONENT_NAME}Context.Provider>
  );
};
EOF
        ;;

    page)
        cat > "$JSX_FILE" << EOF
${CREATE_CSS:+$CSS_IMPORT}

const ${COMPONENT_NAME} = () => {
  return (
    <div className={${CLASS_NAME:-\"${COMPONENT_NAME_KEBAB}\"}}>
      <h1>The ${COMPONENT_NAME} works</h1>
      {/* Page content */}
    </div>
  );
};

export default ${COMPONENT_NAME};
EOF
        ;;
esac

# Create CSS file if needed
if [ "$CREATE_CSS" = true ]; then
    create_css_file "$CSS_FILE" "$COMPONENT_NAME_KEBAB"
fi

# Success message
echo -e "${GREEN}✓ Component created successfully!${NC}"
echo -e "${BLUE}Structure:${NC}"
echo "$COMPONENT_FOLDER/"
echo "├── ${COMPONENT_NAME}.jsx"
[ "$CREATE_CSS" = true ] && echo "└── ${COMPONENT_NAME}.$([ "$CSS_TYPE" = "module" ] && echo "module.")css"
echo ""
echo -e "${YELLOW}Import it with:${NC}"
if [ "$COMPONENT_TYPE" = "page" ]; then
    echo "import ${COMPONENT_NAME} from '../pages/${COMPONENT_NAME_KEBAB}/${COMPONENT_NAME}';"
else
    echo "import ${COMPONENT_NAME} from './components/${COMPONENT_NAME_KEBAB}/${COMPONENT_NAME}';"
fi
