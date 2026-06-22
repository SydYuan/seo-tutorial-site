---
title: "How to Fix 'Error: GetAddrinfo ENOTFOUND' in Node.js"
pubDatetime: 2026-06-23T01:43:08.000Z
modDatetime: 2026-06-23T01:43:08.000Z
description: "Fix 'Error: GetAddrinfo ENOTFOUND' in Node.js by checking DNS, network connectivity, and hostname validity."
tags:
  - tutorial
  - error-fix
  - seo
---

## What Causes This Error

The `Error: getaddrinfo ENOTFOUND` occurs when Node.js cannot resolve a hostname to an IP address. This typically happens when your application tries to connect to a domain name that doesn't exist, has a typo, or is currently unavailable. The error originates from the operating system's DNS resolution process failing to find the requested hostname.

Common triggers include misspelled domain names, network connectivity issues, or DNS server problems. The error can also appear when environment variables containing URLs are misconfigured or when services you're trying to connect to are down. This error is particularly common in development environments where services might not be running locally.

## How to Fix It

### Verify the Hostname

First, check that the hostname in your code is correct. A simple typo can cause this error.

```javascript
// Incorrect
const url = 'https://api.exmaple.com/data';

// Correct
const url = 'https://api.example.com/data';
```

### Check Network Connectivity

Ensure your network connection is active and DNS is working. Test with a simple ping or curl command.

```bash
# Test DNS resolution
nslookup api.example.com

# Or use curl
curl -I https://api.example.com
```

### Use IP Addresses Directly

If DNS resolution fails, you can temporarily use the IP address instead of the hostname.

```javascript
// Instead of hostname
const response = await fetch('https://api.example.com/data');

// Use IP address
const response = await fetch('https://93.184.216.34/data');
```

### Implement Retry Logic

Add retry logic to handle temporary DNS failures gracefully.

```javascript
async function fetchWithRetry(url, retries = 3) {
  for (let i = 0; i < retries; i++) {
    try {
      const response = await fetch(url);
      return response;
    } catch (error) {
      if (error.code === 'ENOTFOUND' && i < retries - 1) {
        await new Promise(resolve => setTimeout(resolve, 1000 * (i + 1)));
        continue;
      }
      throw error;
    }
  }
}
```

### Configure DNS Settings

For persistent issues, configure your DNS settings or use a reliable DNS provider.

```javascript
// Set custom DNS servers in Node.js
const dns = require('dns');
dns.setServers(['8.8.8.8', '8.8.4.4']);
```

## Common Variations

### ECONNREFUSED Error

This occurs when the hostname resolves but the service isn't running on the specified port.

```javascript
// Check if service is running
const net = require('net');
const socket = net.createConnection(3000, 'localhost');
socket.on('connect', () => console.log('Service is running'));
socket.on('error', () => console.log('Service not available'));
```

### ETIMEDOUT Error

The connection attempt timed out, often due to network issues or firewall blocking.

```javascript
// Increase timeout
const https = require('https');
const agent = new https.Agent({ timeout: 30000 });
```

### EAI_AGAIN Error

Temporary DNS failure that usually resolves on retry.

```javascript
// Implement exponential backoff
const delay = (ms) => new Promise(resolve => setTimeout(resolve, ms));
async function retryRequest(fn, maxRetries = 5) {
  for (let i = 0; i < maxRetries; i++) {
    try {
      return await fn();
    } catch (error) {
      if (error.code === 'EAI_AGAIN') {
        await delay(Math.pow(2, i) * 1000);
        continue;
      }
      throw error;
    }
  }
}
```

## FAQ

### Why does this error occur only in production?

Production environments often have different DNS configurations, network restrictions, or firewall rules. Check your production DNS settings and ensure all required domains are whitelisted.

### How can I prevent this error in my application?

Implement proper error handling, use retry logic, validate URLs before making requests, and consider using connection pooling for database connections.

### Is this error specific to Node.js?

No, this error can occur in any application that performs DNS resolution. However, Node.js surfaces it as `ENOTFOUND` while other languages might use different error codes.
