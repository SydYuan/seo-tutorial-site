---
title: "How to Fix 'Cannot find module' Error in Node.js"
pubDatetime: 2026-06-23T01:34:54.000Z
modDatetime: 2026-06-23T01:34:54.000Z
description: "Step-by-step guide to fix the 'Cannot find module' error in Node.js. Learn about module resolution, install missing packages, and fix import paths."
tags:
  - tutorial
  - error-fix
  - seo
---

## What Causes This Error

The "Cannot find module" error occurs when Node.js cannot locate a required module in your project. This typically happens when the module isn't installed, the path is incorrect, or the module isn't listed in your `package.json` dependencies.

Common causes include missing `npm install`, incorrect relative paths, or typos in module names. Node.js searches for modules in the `node_modules` directory and follows a specific resolution algorithm that checks parent directories recursively.

## How to Fix It

### Step 1: Install Missing Modules

Run npm install to add the missing dependency to your project.

```bash
npm install express
```

### Step 2: Verify Package.json

Ensure the module is listed in your dependencies.

```json
{
  "dependencies": {
    "express": "^4.18.2"
  }
}
```

### Step 3: Check File Paths

Use correct relative paths when requiring local modules.

```javascript
// Correct
const myModule = require('./myModule');

// Incorrect
const myModule = require('myModule');
```

### Step 4: Clear Cache and Reinstall

Delete node_modules and reinstall all dependencies.

```bash
rm -rf node_modules
npm install
```

## Common Variations

### MODULE_NOT_FOUND

This is the standard error for missing packages. Install the package using `npm install package-name`.

### Cannot find module 'internal/modules/cjs/helpers'

Usually indicates Node.js version mismatch. Update Node.js or use nvm to switch versions.

```bash
nvm install 18
nvm use 18
```

### Error: Cannot find module './file.js'

Check file extensions and case sensitivity. Linux systems are case-sensitive.

```javascript
// Ensure exact filename match
const config = require('./config.js');
```

## FAQ

**Q: Why does this error occur after cloning a repository?**
A: Run `npm install` to install all dependencies listed in package.json.

**Q: How to fix this error in production?**
A: Ensure all dependencies are in `dependencies` not `devDependencies`, and run `npm ci` for consistent installs.

**Q: What if the module exists but still shows error?**
A: Check for typos, verify the module exports correctly, and ensure proper file permissions.
