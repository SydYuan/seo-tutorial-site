---
title: "How to Fix 'Module parse failed: Unexpected token' in Webpack"
pubDatetime: 2026-06-23T01:34:55.000Z
modDatetime: 2026-06-23T01:34:55.000Z
description: "Fix the Webpack 'Module parse failed: Unexpected token' error with practical solutions including loaders, Babel config, and file type handling."
tags:
  - tutorial
  - error-fix
  - seo
---

## What Causes This Error

The "Module parse failed: Unexpected token" error occurs when Webpack encounters a file type it doesn't know how to process. This typically happens when you import modern JavaScript (ES6+), TypeScript, JSX, or other non-standard syntax without the proper loader configuration.

Webpack natively understands only CommonJS and basic ES modules. When it encounters arrow functions, optional chaining, or JSX syntax, it throws this error because it can't parse these advanced language features.

The root cause is almost always a missing or misconfigured loader in your webpack.config.js file. Loaders transform non-JavaScript files into modules that Webpack can process.

## How to Fix It

### Step 1: Install the Required Loader

First, identify which file type is causing the error. For modern JavaScript, install Babel loader:

```bash
npm install --save-dev babel-loader @babel/core @babel/preset-env
```

For TypeScript files:

```bash
npm install --save-dev ts-loader typescript
```

### Step 2: Configure Webpack

Add the loader rule to your webpack.config.js:

```javascript
module.exports = {
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader',
          options: {
            presets: ['@babel/preset-env']
          }
        }
      }
    ]
  }
};
```

### Step 3: Create Babel Configuration

Create a .babelrc file in your project root:

```json
{
  "presets": ["@babel/preset-env"]
}
```

### Step 4: Handle TypeScript Files

For TypeScript projects, add this rule:

```javascript
{
  test: /\.tsx?$/,
  use: 'ts-loader',
  exclude: /node_modules/
}
```

## Common Variations

### Unexpected token '<' (JSX Error)

Install JSX support:

```bash
npm install --save-dev @babel/preset-react
```

Add to .babelrc:

```json
{
  "presets": ["@babel/preset-env", "@babel/preset-react"]
}
```

### Unexpected token 'export' (ES Module Error)

Install the appropriate loader for the specific module causing issues:

```javascript
{
  test: /\.m?js$/,
  resolve: {
    fullySpecified: false
  }
}
```

### Unexpected token '?' (Optional Chaining)

Ensure your Babel preset targets modern browsers:

```json
{
  "presets": [
    ["@babel/preset-env", {
      "targets": "defaults"
    }]
  ]
}
```

### Unexpected token 'import.meta'

Add the appropriate plugin:

```bash
npm install --save-dev @babel/plugin-syntax-import-meta
```

## FAQ

### Why does this error only appear with some packages?

Some npm packages ship modern JavaScript that requires transpilation. Check if the package includes a "module" field in its package.json, which indicates ES module format.

### Can I exclude specific node_modules from processing?

Yes, but you shouldn't. Instead, use the `include` option to explicitly process problematic packages:

```javascript
{
  test: /\.js$/,
  include: [
    path.resolve(__dirname, 'src'),
    path.resolve(__dirname, 'node_modules/problematic-package')
  ],
  use: 'babel-loader'
}
```

### How do I know which loader I need?

Check the file extension causing the error. .ts/.tsx needs ts-loader, .jsx needs babel-loader with React preset, and modern .js needs babel-loader with preset-env.
