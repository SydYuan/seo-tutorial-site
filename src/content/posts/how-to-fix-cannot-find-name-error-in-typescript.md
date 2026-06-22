---
title: "How to Fix 'Cannot find name' Error in TypeScript"
pubDatetime: 2026-06-23T01:42:24.000Z
modDatetime: 2026-06-23T01:42:24.000Z
description: "The "Cannot find name" error in TypeScript occurs when the compiler encounters an identifier that hasn't been declared o..."
tags:
  - tutorial
  - error-fix
  - seo
---

## What Causes This Error

The "Cannot find name" error in TypeScript occurs when the compiler encounters an identifier that hasn't been declared or imported in the current scope. This typically happens when you reference a variable, function, or type that TypeScript cannot locate in any accessible namespace.

Common triggers include missing import statements, typos in variable names, or referencing variables outside their declaration scope. The error message usually includes the specific identifier that TypeScript cannot resolve, making it relatively straightforward to diagnose.

## How to Fix It

### Step 1: Check Your Imports

The most common fix is ensuring all required modules are properly imported. Missing imports are the primary cause of this error.

```typescript
// ❌ Error: Cannot find name 'React'
const App = () => <div>Hello</div>;

// ✅ Fixed: Import React
import React from 'react';
const App = () => <div>Hello</div>;
```

### Step 2: Verify Variable Scope

Ensure variables are declared before use and within the correct scope block.

```typescript
// ❌ Error: Cannot find name 'userName'
console.log(userName);

// ✅ Fixed: Declare variable first
const userName = 'John';
console.log(userName);
```

### Step 3: Check for Typos

Double-check spelling of identifiers, as TypeScript is case-sensitive.

```typescript
// ❌ Error: Cannot find name 'getuser'
const user = getuser();

// ✅ Fixed: Correct the function name
const user = getUser();
```

### Step 4: Update tsconfig.json

Sometimes the error occurs due to missing type definitions. Install required @types packages.

```bash
npm install --save-dev @types/node
```

## Common Variations

### Cannot find name 'process'

This occurs when Node.js types aren't available. Install Node type definitions.

```bash
npm install --save-dev @types/node
```

### Cannot find name 'window' or 'document'

Browser globals aren't available in Node.js contexts. Add DOM lib to tsconfig.json.

```json
{
  "compilerOptions": {
    "lib": ["dom", "es2020"]
  }
}
```

### Cannot find name 'require'

CommonJS require isn't recognized in ES modules. Use import syntax instead.

```typescript
// ❌ Error in ES modules
const fs = require('fs');

// ✅ Fixed: Use import
import fs from 'fs';
```

### Cannot find name 'module'

Node.js module system types missing. Install @types/node or use ES modules.

```bash
npm install --save-dev @types/node
```

## FAQ

### Why does this error appear even when the variable exists?

This usually indicates a scope issue or the variable is declared in a different file without proper export/import. Check that the variable is exported from its source file and imported where needed.

### How do I fix this error for third-party libraries?

Install the corresponding @types package for the library. For example, `npm install --save-dev @types/express` for Express.js. If types aren't available, you can declare the module manually.

### Can tsconfig.json cause this error?

Yes, incorrect compiler options can prevent TypeScript from finding type definitions. Ensure your `lib` and `types` arrays include the necessary declarations for your target environment.
