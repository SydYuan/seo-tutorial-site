---
title: "How to Fix 'Module not found: Error: Can't resolve' in Webpack"
pubDatetime: 2026-06-23T01:44:23.000Z
modDatetime: 2026-06-23T01:44:23.000Z
description: "Fix 'Module not found: Error: Can't resolve' in Webpack by correcting import paths and installing missing packages."
tags:
  - tutorial
  - error-fix
  - seo
---

## What Causes This Error

The "Module not found: Error: Can't resolve" in Webpack occurs when the bundler cannot locate a module specified in an `import` or `require()` statement. This typically happens due to incorrect file paths, missing dependencies, or misconfigured Webpack aliases. The error message usually includes the exact module path that failed to resolve, such as `Can't resolve './utils/helpers'` or `Can't resolve 'lodash'`.

Webpack resolves modules by checking relative paths, `node_modules`, and any custom `resolve.alias` or `resolve.modules` configurations. If the file doesn’t exist at the expected location or the package isn’t installed, Webpack throws this error during build time. Case sensitivity on certain operating systems (e.g., Linux) can also cause resolution failures even with seemingly correct paths.

## How to Fix It

First, verify the import path matches the actual file location. For example, if your component is in `src/components/Button.js` and you're importing it from `src/pages/Home.js`, ensure you use the correct relative path:

```javascript
// Correct import from Home.js
import Button from '../components/Button';
```

If the module is an npm package, confirm it's installed:

```bash
# Install missing package
npm install lodash

# Or if using Yarn
yarn add lodash
```

For custom directories, configure Webpack's `resolve.alias` in `webpack.config.js` to avoid long relative paths:

```javascript
// webpack.config.js
const path = require('path');

module.exports = {
  //...
  resolve: {
    alias: {
      '@components': path.resolve(__dirname, 'src/components/')
    }
  }
};
```

Then use the alias in imports:

```javascript
import Button from '@components/Button';
```

## Common Variations

**Error: Can't resolve 'react'**  
Fix by installing React: `npm install react react-dom`.

**Error: Can't resolve './assets/logo.png'**  
Ensure the file exists or add a file-loader rule in Webpack:

```javascript
// webpack.config.js
module: {
  rules: [
    {
      test: /\.(png|svg|jpg|gif)$/,
      use: ['file-loader']
    }
  ]
}
```

**Error: Can't resolve 'fs'**  
This occurs when using Node.js modules in a client bundle. Exclude them:

```javascript
// webpack.config.js
resolve: {
  fallback: {
    fs: false
  }
}
```

**Error: Can't resolve 'crypto'**  
Similar to `fs`, handle via Webpack 5+ fallbacks:

```javascript
// webpack.config.js
resolve: {
  fallback: {
    crypto: require.resolve('crypto-browserify')
  }
}
```

## FAQ

**Why does this error only appear on Linux but not Windows?**  
Linux filesystems are case-sensitive, while Windows is not. A path like `./Utils/helper.js` won’t match `utils/helper.js` on Linux.

**Can I suppress this error without fixing the import?**  
No. This is a build-time error that prevents bundling. You must correct the path or install the missing dependency.

**How do I debug which module failed to resolve?**  
Run Webpack with `--display-error-details` flag or check the full stack trace in the error output—it shows the exact file and line causing the issue.
