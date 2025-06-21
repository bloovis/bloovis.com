---
title: Pagination in Hugo Hextra theme
date: '2025-06-20'
tags:
- linux
- software
- hugo
---

I recently switched this blog to use the Hugo [Hextra theme](https://github.com/imfing/hextra).
Compared with the previous theme I was using, Hextra had
a search function that actually worked correctly, and it
had a more pleasing and simpler appearance.  But one
problem I noticed right away was that it didn't support
pagination in the listing of posts: the summaries
of all 283 posts for this blog appeared on one page.
<!---more-->

After examining the official Hugo documentation for
[pagination](https://gohugo.io/templates/pagination/),
I was able to apply the following simple patch to the theme:

```diff
diff --git a/layouts/blog/list.html b/layouts/blog/list.html
index 5527ba8..064920e 100644
--- a/layouts/blog/list.html
+++ b/layouts/blog/list.html
@@ -8,7 +8,8 @@
         {{ if .Title }}<h1 class="hx:text-center hx:mt-2 hx:text-4xl hx:font-bold hx:tracking-tight hx:text-slate-900 hx:dark:text-slate-100">{{ .Title }}</h1>{{ end }}
         <div class="content">{{ .Content }}</div>
         {{- $pages := partial "utils/sort-pages" (dict "page" . "by" site.Params.blog.list.sortBy "order" site.Params.blog.list.sortOrder) -}}
-        {{- range $pages }}
+        {{- $paginator := .Paginate $pages 10 }}
+        {{- range $paginator.Pages }}
           <div class="hx:mb-10">
             <h3><a style="color: inherit; text-decoration: none;" class="hx:block hx:font-semibold hx:mt-8 hx:text-2xl " href="{{ .RelPermalink }}">{{ .Title }}</a></h3>
             {{ if site.Params.blog.list.displayTags }}
@@ -23,6 +24,7 @@
             <p class="hx:opacity-50 hx:text-sm hx:mt-4 hx:leading-7">{{ partial "utils/format-date" .Date }}</p>
           </div>
         {{ end -}}
+        {{ partial "pagination.html" . }}
       </main>
     </article>
     <div class="hx:max-xl:hidden hx:h-0 hx:w-64 hx:shrink-0"></div>
```

This produced pages of 10 posts each on the post list page (the hardcoded 10
should probably be a paramater in `hugo.yaml`).  It also
produced the desired pagination controls at the bottom of the page,
but its appearance was unsatisfactory, with each control on a separate line.
To fix this, I added some custom CSS that reproduced the appearance of
the pagination controls in the previous theme I'd been using.  It's
probably not as clean as it should be, but it does seem to work:

```diff
diff --git a/assets/css/custom.css b/assets/css/custom.css
index e69de29..53ba2a4 100644
--- a/assets/css/custom.css
+++ b/assets/css/custom.css
@@ -0,0 +1,36 @@
+.pagination {
+  display: flex;
+  border-radius:.25rem;
+  margin:2rem 1rem;
+  padding:.5rem 0;
+  align-items:center;
+  justify-content:center;
+  /*background-color:#eee;*/
+  border-style: solid;
+  border-width: 1px;
+}
+
+.pagination li {
+  border-radius:.25rem
+}
+
+.page-item {
+  padding: 5px;
+  display: inline;
+}
+
+.pagination li.disabled a:hover,
+.pagination li.disabled a:active,
+.pagination li.disabled a:focus {
+  /*color:#757575;*/
+  text-decoration:none
+}
+
+.pagination a {
+  font-size:1.25rem;
+  padding:.5rem .75rem
+}
+
+li.active {
+  color: #26a69a;
+}
```
