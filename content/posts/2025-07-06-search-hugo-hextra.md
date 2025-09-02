---
title: Fixing Search Problems in Hugo Hextra theme
date: '2025-07-06'
comments: true
tags:
- linux
- software
- hugo
---

The Hugo [Hextra theme](https://github.com/imfing/hextra)
used by this blog has a useful search feature, implemented
using the popular [FlexSearch](https://github.com/nextapps-de/flexsearch)
library.  But after playing with search for a while, I discovered
that it often returned only a small subset of the expected
posts.  For example, my blog has 20 posts that contain the word "firefox", but search displayed
only five of those posts.  Here I describe how to fix this problem, which
actually turned out to be several problems.

<!---more-->

## Hardcoded Limits

The code that implements
search is the file `themes/hextra/assets/js/flexsearch.js`.  
After examining that file, I could see that the limit on the number of posts
returned by the page search was a hardcoded 5:

```js
    const pageResults = window.pageIndex.search(query, 5,
      { enrich: true, suggest: true })[0]?.result || [];
```

Further down, the number of sections (i.e., paragraphs) returned for
each found page was also a hardcoded 5:

```js
      const sectionResults = window.sectionIndex.search(query, 5,
        { enrich: true, suggest: true, tag: { 'pageId': `page_${result.id}` } })[0]?.result || [];
```

The Hextra author kindly provided a patch that allowed these two limits
to be configurable in `hugo.yaml`.  Here are the revised versions of the
two code snippets above:

```js
    // Configurable search limits with sensible defaults
    const maxPageResults = parseInt('{{- site.Params.search.flexsearch.maxPageResults |
       default 20 -}}', 10);
    const maxSectionResults = parseInt('{{- site.Params.search.flexsearch.maxSectionResults |
       default 10 -}}', 10);

    const pageResults = window.pageIndex.search(query, maxPageResults,
      { enrich: true, suggest: true })[0]?.result || [];
...
      const sectionResults = window.sectionIndex.search(query, maxSectionResults,
        { enrich: true, suggest: true, tag: { 'pageId': `page_${result.id}` } })[0]?.result || [];
```

Here are the relevant lines from `hugo.yaml`:

```yaml
params:
...
  search:
    enable: true
    type: flexsearch

    flexsearch:
      index: content
      maxPageResults: 50
      maxSectionResults: 3
```

## FlexSearch Bug?

But the problem persisted.  In particular, when I set
`maxSectionResults` to a small number, say 3, it seemed
to restrict the total number of found pages (i.e., posts) to 3, as if
`maxPageResults` had no effect. I couldn't see any more problems with the Hextra
code, so I started looking at FlexSearch issues to see
if anybody had reported this issue.  I did find
[one issue](https://github.com/nextapps-de/flexsearch/issues/459)
that seemed similar.  It appeared to me that the search
of `sectionIndex` was misbehaving if a limit parameter was supplied.
So I removed the limit parameter to the search, and instead used `maxSectionResults`
to limit the subsequent loop through the results:

```js
      const sectionResults = window.sectionIndex.search(query,
        { enrich: true, suggest: true, tag: { 'pageId': `page_${result.id}` } })[0]?.result || [];
...
      const nResults = Math.min(sectionResults.length, maxSectionResults);
      for (let j = 0; j < nResults; j++) {
...
```

With this change, search finally started returning the expected number of posts *and*
sections (i.e., paragraphs) within those posts.

## Issue

I reported these problems in [this issue](https://github.com/imfing/hextra/issues/714).
Apparently, this issue is not important enough to be fixed, so I will continue to
patch `flexsearch.js` with each new release of Hextra, as detailed in
the next section.

## Patch

To avoid modifying Hextra directly, copy `flexsearch.js` to your project's
own assets:

```bash
mkdir -p assets/js
cp themes/hextra/assets/js/flexsearch.js assets/js/flexsearch.js
```

Then apply the following patch to your copy of `flexsearch.js`:

```diff
--- themes/hextra/assets/js/flexsearch.js	2025-07-05 11:28:42.527276630 -0700
+++ assets/js/flexsearch.js	2025-07-06 19:17:14.088721440 -0700
@@ -244,7 +244,7 @@
 
         const crumbData = data[searchUrl];
         if (!crumbData) {
-          console.warn('Excluded page', searchUrl, '- will not be included for search result breadcrumb for', route);
+          // console.warn('Excluded page', searchUrl, '- will not be included for search result breadcrumb for', route);
           continue;
         }
 
@@ -318,7 +318,11 @@
     }
     resultsElement.classList.remove('hx:hidden');
 
-    const pageResults = window.pageIndex.search(query, 5, { enrich: true, suggest: true })[0]?.result || [];
+    // Configurable search limits with sensible defaults
+    const maxPageResults = parseInt('{{- site.Params.search.flexsearch.maxPageResults | default 20 -}}', 10);
+    const maxSectionResults = parseInt('{{- site.Params.search.flexsearch.maxSectionResults | default 10 -}}', 10);
+
+    const pageResults = window.pageIndex.search(query, maxPageResults, { enrich: true, suggest: true })[0]?.result || [];
 
     const results = [];
     const pageTitleMatches = {};
@@ -327,12 +331,13 @@
       const result = pageResults[i];
       pageTitleMatches[i] = 0;
 
-      // Show the top 5 results for each page
-      const sectionResults = window.sectionIndex.search(query, 5, { enrich: true, suggest: true, tag: { 'pageId': `page_${result.id}` } })[0]?.result || [];
+      const sectionResults = window.sectionIndex.search(query,
+        { enrich: true, suggest: true, tag: { 'pageId': `page_${result.id}` } })[0]?.result || [];
       let isFirstItemOfPage = true
       const occurred = {}
 
-      for (let j = 0; j < sectionResults.length; j++) {
+      const nResults = Math.min(sectionResults.length, maxSectionResults);
+      for (let j = 0; j < nResults; j++) {
         const { doc } = sectionResults[j]
         const isMatchingTitle = doc.display !== undefined
         if (isMatchingTitle) {
```
