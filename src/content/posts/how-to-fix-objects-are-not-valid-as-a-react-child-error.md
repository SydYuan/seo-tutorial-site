---
title: "How to Fix 'Objects are not valid as a React child' Error"
pubDatetime: 2026-06-23T01:43:39.000Z
modDatetime: 2026-06-23T01:43:39.000Z
description: "The "Objects are not valid as a React child" error occurs when you attempt to render a JavaScript object directly in JSX..."
tags:
  - tutorial
  - error-fix
  - seo
---

## What Causes This Error

The "Objects are not valid as a React child" error occurs when you attempt to render a JavaScript object directly in JSX. React can only render primitive values (strings, numbers, booleans) or arrays of React elements—not raw objects.

This commonly happens when you accidentally pass an object to a component's children prop or use curly braces `{}` around an object instead of accessing its properties. For example, rendering `{user}` instead of `{user.name}` triggers this error because React doesn't know how to display the entire object.

Another frequent cause is returning an object from a function that's used in JSX, or passing complex data structures through props without proper destructuring. The error message typically includes the object's keys, helping you identify exactly which value caused the issue.

## How to Fix It

The solution is straightforward: ensure you're rendering object properties, not the object itself. Here's how to fix common scenarios:

**Fix 1: Access object properties directly**

```jsx
// ❌ Wrong - renders the entire object
function UserProfile({ user }) {
  return <div>{user}</div>;
}

// ✅ Correct - render specific properties
function UserProfile({ user }) {
  return <div>{user.name} - {user.email}</div>;
}
```

**Fix 2: Convert objects to strings when needed**

```jsx
// ❌ Wrong
function DataDisplay({ data }) {
  return <span>{data}</span>;
}

// ✅ Correct - use JSON.stringify for debugging
function DataDisplay({ data }) {
  return <span>{JSON.stringify(data)}</span>;
}
```

**Fix 3: Handle arrays of objects properly**

```jsx
// ❌ Wrong - trying to render array of objects directly
function UserList({ users }) {
  return <div>{users}</div>;
}

// ✅ Correct - map through array and render properties
function UserList({ users }) {
  return (
    <div>
      {users.map(user => (
        <div key={user.id}>{user.name}</div>
      ))}
    </div>
  );
}
```

**Fix 4: Check prop types and destructure correctly**

```jsx
// ❌ Wrong - passing object as children
<Modal content={{ title: "Hello", body: "World" }} />

// ✅ Correct - pass primitives or proper JSX
<Modal>
  <h2>Hello</h2>
  <p>World</p>
</Modal>
```

## Common Variations

**"Objects are not valid as a React child (found: object with keys {id, name})"**

This specific message tells you exactly which object caused the error. Access the properties instead:

```jsx
// Fix: {item.id} or {item.name} instead of {item}
```

**"Objects are not valid as a React child (found: [object Promise])"**

This occurs when rendering a Promise directly. Use async/await or `.then()`:

```jsx
// ❌ Wrong
function Data() {
  const data = fetchData(); // Returns Promise
  return <div>{data}</div>;
}

// ✅ Correct
function Data() {
  const [data, setData] = useState(null);
  useEffect(() => {
    fetchData().then(setData);
  }, []);
  return <div>{data}</div>;
}
```

**"Objects are not valid as a React child (found: Symbol)"**

Symbols can't be rendered. Convert to string:

```jsx
// ❌ Wrong
const id = Symbol('id');
return <div>{id}</div>;

// ✅ Correct
return <div>{id.toString()}</div>;
```

**Rendering Date objects**

Date objects need explicit conversion:

```jsx
// ❌ Wrong
const date = new Date();
return <span>{date}</span>;

// ✅ Correct
return <span>{date.toLocaleDateString()}</span>;
```

## FAQ

**Why does this error only appear in development?**

React shows this error in development mode to help catch bugs early. In production, it may silently fail or display `[object Object]`, making debugging harder. Always fix these errors before deploying.

**Can I render objects as JSON for debugging?**

Yes, use `JSON.stringify()` to display objects during development:

```jsx
<pre>{JSON.stringify(data, null, 2)}</pre>
```

This formats the object as readable JSON, which is useful for debugging but shouldn't be used in production UI.

**How do I prevent this error in TypeScript?**

TypeScript can catch many of these errors at compile time. Define proper types for your props and use type guards:

```typescript
interface User {
  name: string;
  email: string;
}

function UserProfile({ user }: { user: User }) {
  return <div>{user.name}</div>; // TypeScript ensures user.name is string
}
```
