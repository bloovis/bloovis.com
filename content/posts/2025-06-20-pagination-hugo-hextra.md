---
title: Pagination in Hugo Hextra theme
date: '2025-06-20'
comments: true
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
<!--more-->

## Configuration

In order to enable pagination and specify the number of posts to appear
on one page in the blog listing, create a configuration parameter
in `hugo.yaml` called `blog.list.pageSize`.  If present, this variable specifies the
number of posts that should appear on a page in the post listing.
If it is not present, the post listing will not be paginated.

Here is how I specified a page size of 10 posts in `hugo.yaml`:

```yaml
params:
  blog:
    list:
      displayTags: true
      pageSize: 10
```
## Patch the Blog List Layout

At the project top level directory, copy the theme's `layouts/blog/list.html`
to the project's own layout:

```bash
mkdir layouts/blog
cp themes/hextra/layouts/blog/list.html layouts/blog/list.html
```

{{< callout type="info" >}}
After I wrote the first version of this post, Hextra introduced
support for blog list pagination in version v0.10.  Skip to
the appropriate section, depending on which version of Hextra
you are using.
{{< /callout >}}

### Pre-v0.10 Patch

If you are using a version of Hextra prior to v0.10,
apply the following patch to `layouts/blog/list.html`:

```diff
--- themes/hextra/layouts/blog/list.html	2025-06-21 16:30:19.640005204 -0700
+++ layouts/blog/list.html	2025-06-22 05:08:24.840819850 -0700
@@ -8,6 +8,10 @@
         {{ if .Title }}<h1 class="hx:text-center hx:mt-2 hx:text-4xl hx:font-bold hx:tracking-tight hx:text-slate-900 hx:dark:text-slate-100">{{ .Title }}</h1>{{ end }}
         <div class="content">{{ .Content }}</div>
         {{- $pages := partial "utils/sort-pages" (dict "page" . "by" site.Params.blog.list.sortBy "order" site.Params.blog.list.sortOrder) -}}
+        {{- if site.Params.blog.list.pageSize -}}
+          {{- $paginator := .Paginate $pages site.Params.blog.list.pageSize -}}
+          {{- $pages = $paginator.Pages -}}
+        {{- end -}}
         {{- range $pages }}
           <div class="hx:mb-10">
             <h3><a style="color: inherit; text-decoration: none;" class="hx:block hx:font-semibold hx:mt-8 hx:text-2xl " href="{{ .RelPermalink }}">{{ .Title }}</a></h3>
@@ -23,6 +27,9 @@
             <p class="hx:opacity-50 hx:text-sm hx:mt-4 hx:leading-7">{{ partial "utils/format-date" .Date }}</p>
           </div>
         {{ end -}}
+        {{- if site.Params.blog.list.pageSize -}}
+          {{ partial "pagination.html" . }}
+        {{- end -}}
       </main>
     </article>
     <div class="hx:max-xl:hidden hx:h-0 hx:w-64 hx:shrink-0"></div>
```

### Post-v0.10 Patch

Hextra now has support for pagination, but I still prefer to use
Hugo's built-in paginator layout instead of Hextra's, because it allows me to use pagination
controls that have buttons for first and last posts, as well as
five numbered pages.  The patch for this is much simpler
than the Pre-v0.10 patch:

```diff
--- themes/hextra/layouts/blog/list.html	2025-08-31 12:46:27.578030335 -0700
+++ layouts/blog/list.html	2025-08-31 18:34:56.785848760 -0700
@@ -30,7 +30,7 @@
         {{ end -}}
         
         {{- if gt $paginator.TotalPages 1 -}}
-          {{ partial "components/blog-pager.html" $paginator }}
+          {{ partial "pagination.html" . }}
         {{- end -}}
       </main>
     </article>
```

## Custom CSS

Given the configuration above, this produces pages of 10 posts each on the post list page.
It also produces the desired pagination controls at the bottom of the page,
but its appearance is unsatisfactory, with each control on a separate line.

To fix the appearance of the controls, I added some custom CSS that reproduced the appearance of
the pagination controls in the previous theme I'd been using.

At the project top level directory, create the directory `assets/css`,
then copy the following to `assets/css/custom.css`:

```css {filename="assets/css/custom.css"}
.pagination {
  display: flex;
  border-radius:.25rem;
  margin:2rem 1rem;
  padding:.5rem 0;
  align-items:center;
  justify-content:center;
  /*background-color:#eee;*/
  border-style: solid;
  border-width: 1px;
}

.page-item {
  padding: 5px;
  display: inline;
}

.pagination li {
  border-radius:.25rem
}

.pagination li.active {
  color: #26a69a;
}

.pagination li.disabled a:hover,
.pagination li.disabled a:active,
.pagination li.disabled a:focus {
  /*color:#757575;*/
  text-decoration:none
}

.pagination a {
  font-size:1.25rem;
  padding:.5rem .75rem
}

```

Here is what the pagination controls should look like now:

![pagination controls](/images/pagination-controls.png)
