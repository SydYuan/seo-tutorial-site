import { defineAstroPaperConfig } from "./src/types/config";

export default defineAstroPaperConfig({
  site: {
    url: "https://seo-tutorial-site.vercel.app",
    title: "DevTutorials — Fix Code Errors Fast",
    description: "Clear, step-by-step solutions for common programming errors. Fix React, Next.js, JavaScript, and Python errors with working code examples.",
    author: "DevTutorials",
    profile: "https://github.com/SydYuan",
    ogImage: "default-og.jpg",
    lang: "en",
    timezone: "Asia/Shanghai",
    dir: "ltr",
  },
  posts: {
    perPage: 4,
    perIndex: 4,
    scheduledPostMargin: 15 * 60 * 1000,
  },
  features: {
    lightAndDarkMode: true,
    dynamicOgImage: true,
    showArchives: true,
    showBackButton: true,
    editPost: {
      enabled: true,
      url: "https://github.com/satnaing/astro-paper/edit/main/",
    },
    search: "pagefind",
  },
  socials: [
    { name: "github",   url: "https://github.com/SydYuan" },
  ],
  shareLinks: [
    { name: "x",        url: "https://x.com/intent/post?url=" },
  ],
});