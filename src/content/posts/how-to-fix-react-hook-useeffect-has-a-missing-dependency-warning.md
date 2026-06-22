---
title: "How to Fix 'React Hook useEffect has a missing dependency' Warning"
pubDatetime: 2026-06-23T01:42:03.000Z
modDatetime: 2026-06-23T01:42:03.000Z
description: "Fix React useEffect missing dependency warning by adding the missing dependency array entries."
tags:
  - tutorial
  - error-fix
  - seo
---

## What Causes This Error

The "React Hook useEffect has a missing dependency" warning occurs when you use a variable or function inside your `useEffect` callback that isn't included in the dependency array. React's exhaustive-deps lint rule enforces this to prevent stale closures and unexpected behavior.

This typically happens when you reference props, state, or functions defined outside the effect. React needs these dependencies declared so it knows when to re-run your effect with fresh values.

## How to Fix It

The solution is straightforward: add all referenced variables to your dependency array. Here's a common problematic pattern and its fix:

```javascript
// ❌ Problem: 'userId' is missing from dependencies
useEffect(() => {
  fetch(`/api/users/${userId}`).then(res => res.json());
}, []);
```

```javascript
// ✅ Fixed: Include 'userId' in the dependency array
useEffect(() => {
  fetch(`/api/users/${userId}`).then(res => res.json());
}, [userId]);
```

For functions defined in the component body, you have two options. Either move the function inside the effect or wrap it with `useCallback`:

```javascript
// Option 1: Move function inside useEffect
useEffect(() => {
  const fetchData = async () => {
    const result = await api.getData();
    setData(result);
  };
  fetchData();
}, []);

// Option 2: Wrap with useCallback
const fetchData = useCallback(async () => {
  const result = await api.getData();
  setData(result);
}, []);

useEffect(() => {
  fetchData();
}, [fetchData]);
```

## Common Variations

**Missing function dependencies**: When using event handlers or utility functions inside effects, include them in the dependency array or define them within the effect.

**Object/array dependencies**: These cause infinite loops because they're recreated each render. Use `useMemo` to memoize them or extract primitive values.

**State setter functions**: These are stable and don't need to be in dependencies. React guarantees their identity won't change between renders.

**Ref objects**: Similarly stable and can be omitted from dependency arrays. The `current` property is mutable but the ref object itself is constant.

## FAQ

**Should I disable the exhaustive-deps rule?** No. This rule prevents subtle bugs. Instead, properly manage your dependencies using the patterns shown above.

**Why does my effect run infinitely after adding dependencies?** This usually means you're passing objects or arrays that get recreated each render. Use `useMemo` for objects or extract primitive values to the dependency array.

**Can I use empty dependency arrays safely?** Only when your effect truly doesn't depend on any external values. If you reference props, state, or functions, you must include them.
