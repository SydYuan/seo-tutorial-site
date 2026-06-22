---
title: "How to Fix 'Error: listen EADDRINUSE' in Node.js"
pubDatetime: 2026-06-23T01:41:33.000Z
modDatetime: 2026-06-23T01:41:33.000Z
description: "Fix 'Error: listen EADDRINUSE' in Node.js by killing the process using the port or changing the port number."
tags:
  - tutorial
  - error-fix
  - seo
---

## What Causes This Error

The `Error: listen EADDRINUSE` occurs when your Node.js application attempts to bind to a port that is already occupied by another process. This typically happens when you have multiple instances of your server running simultaneously, or when a previous instance didn't shut down cleanly and left the port in a `TIME_WAIT` state.

On Linux and macOS, you can identify the conflicting process using `lsof -i :<port>` or `netstat -tlnp | grep <port>`. The error is especially common during development when hot-reload tools restart your server faster than the OS releases the port.

## How to Fix It

The fastest solution is to kill the process occupying the port. On Unix-based systems, run:

```bash
# Find the process using port 3000
lsof -i :3000
# Kill the process by PID
kill -9 <PID>
```

For a more robust approach, modify your Node.js code to handle the error gracefully and retry with a different port:

```javascript
const server = app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});

server.on('error', (err) => {
  if (err.code === 'EADDRINUSE') {
    console.log(`Port ${PORT} is in use, retrying with port ${PORT + 1}`);
    app.listen(PORT + 1);
  }
});
```

Alternatively, use the `portfinder` package to automatically find an available port:

```javascript
const portfinder = require('portfinder');
portfinder.getPort((err, port) => {
  app.listen(port, () => {
    console.log(`Server running on port ${port}`);
  });
});
```

## Common Variations

**EACCES (Permission denied)**: Occurs when trying to bind to a port below 1024 without root privileges. Fix by using a higher port or running with `sudo` (not recommended for production).

**EADDRNOTAVAIL**: Happens when the specified IP address is not available on the machine. Ensure your `listen()` call uses a valid local address like `0.0.0.0.0` or `127.0.0.1`.

**ECONNRESET**: Often appears alongside EADDRINUSE in unstable network conditions. Implement connection retry logic in your client code.

**EMFILE**: Indicates too many open file descriptors. Increase system limits with `ulimit -n 65536` on Unix systems.

## FAQ

**Q: Why does this happen even after I stopped my server?**
A: The OS keeps ports in `TIME_WAIT` state for 30-120 seconds after closure. Use `SO_REUSEADDR` socket option or wait before restarting.

**Q: Can I run multiple servers on the same port?**
A: No, only one process can bind to a specific IP:port combination. Use different ports or implement a reverse proxy like Nginx.

**Q: How do I prevent this in production?**
A: Implement proper process managers like PM2 that handle port conflicts and automatic restarts. Always include error handling for `EADDRINUSE` in your server code.
