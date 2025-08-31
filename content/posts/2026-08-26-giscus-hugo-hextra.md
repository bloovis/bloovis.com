---
title: Giscus Lazy Loading in Hugo Hextra Theme
date: '2025-08-26'
comments: true
tags:
- linux
- software
- hugo
---

The Hugo [Hextra theme](https://github.com/imfing/hextra)
has a feature that allows you to enable [Giscus](https://giscus.app/) comments on
selected pages.  The Hextra documentation for the
[Giscus feature](https://imfing.github.io/hextra/docs/advanced/comments/)
is a good start, but to make this feature usable, I did two things that are
either not documented or not implemented.
<!--more-->

## Language

The Hextra documentation doesn't mention this, but you need to set `lang` to `en`
in your configuration for Giscus.  If you don't, you'll get a weird browser error
that is described in [this issue](https://github.com/giscus/giscus/issues/721).
Here's what the Giscus section of my `hugo.yaml` looks like now:

```yaml {filename="hugo.yaml"}
params:
  comments:
    enable: false
    type: giscus
    giscus:
      repo: "joeuser/myrepo"
      repoId: "<repo id>"
      category: "Announcements"
      categoryId: "<category id>"
      lang: "en"
      reactionsEnabled: 0
```

You get the values for `repoID` and `categoryID` from the configuration
setup portion of the [Giscus site](https://giscus.app/).

Note also that I disabled reactions, because I prefer discussions
to content-free emojis.

There is a complete list of possible configuration values in the Hextra example site's
`hugo.yaml`:

``` {filename="themes/hextra/exampleSite/hugo.yaml"}
...
      repo: imfing/hextra
      repoId: R_kgDOJ9fJag
      category: General
      categoryId: DIC_kwDOJ9fJas4CY7gW
      # mapping: pathname
      # strict: 0
      # reactionsEnabled: 1
      # emitMetadata: 0
      # inputPosition: top
      # lang: en
      # theme: noborder_dark
...
```


## Lazy Loading

Using Giscus causes the browser to load a large amount of Javascript
in order to display the comments for a page.  I wanted to delay the loading of
this extra stuff until it's actually needed, so that pages
wouldn't be penalized by default.  This penalty is noticeable to me because
my internet service (AT&T U-verse via copper lines) is very slow by today's
standards.

The solution, as suggested by Bryce Wray [here](https://www.brycewray.com/posts/2023/08/making-giscus-less-gabby/),
is to put the loading of the Giscus Javascript into a `<details>` block and hide it until the user
reveals it.  Hextra already implements the dynamic theme changing described
by Wray and discussed in [this issue](https://github.com/giscus/giscus/issues/336),
so it's only necessary to implement the details part.  Hextra provides
a handy shortcode for [details](https://imfing.github.io/hextra/docs/guide/shortcodes/details/),
so I naively assumed I could modify Hextra's layout for Giscus like so:

``` {filename="themes/hextra/layouts/_partials/components/giscus.html"}
...
{{</* details title="Discussions" closed="true" */>}}
<div id="giscus"></div>
{{</* /details */>}}
...
```

Wrong!  You can't use shortcodes in a Hugo template; Hugo complains about
a syntax error when it sees the < character.  It was also a mistake to
modify Hextra directly, because that interferes with git updates.

So I had to use raw HTML.  I applied
the details shortcode to a plain piece of text, and copied
the resulting Hugo-generated HTML to a temporary file.

Then I copied Hextra's `giscus.html` to my project's own layout directory, effectively
overriding Hextra:


```bash
mkdir -p layouts/_partials/components
cp themes/hextra/layouts/_partials/components/giscus.html layouts/_partials/components
```

Then I applied the following patch to my copy of `giscus.html`, using
the HTML generated for details by Hugo earlier:

```diff
*** themes/hextra/layouts/_partials/components/giscus.html	2025-06-17 22:00:58.342830895 -0700
--- layouts/_partials/components/giscus.html	2025-08-26 15:05:57.347651049 -0700
***************
*** 49,54 ****
--- 49,55 ----
        "data-theme": getGiscusTheme(),
        "data-lang": "{{ .lang | default $lang }}",
        "crossorigin": "anonymous",
+       "data-loading": "lazy",
        "async": "",
      };
  
***************
*** 65,71 ****
    });
  </script>
  
! <div id="giscus"></div>
  {{- else -}}
    {{ warnf "giscus is not configured" }}
  {{- end -}}
--- 66,79 ----
    });
  </script>
  
! <details class="hx:last-of-type:mb-0 hx:rounded-lg hx:bg-neutral-50 hx:dark:bg-neutral-800 hx:p-2 hx:mt-4 hx:group" >
!   <summary class="hx:flex hx:items-center hx:cursor-pointer hx:select-none hx:list-none hx:p-1 hx:rounded-sm hx:transition-colors hx:hover:bg-gray-100 hx:dark:hover:bg-neutral-800 hx:before:mr-1 hx:before:inline-block hx:before:transition-transform hx:before:content-[''] hx:dark:before:invert hx:rtl:before:rotate-180 hx:group-open:before:rotate-90">
!     <strong class="hx:text-lg">Discussions</strong>
!   </summary>
!   <div class="hx:p-2 hx:overflow-hidden">
!     <div id="giscus"></div>
!   </div>
! </details>
  {{- else -}}
    {{ warnf "giscus is not configured" }}
  {{- end -}}
```

(Seeing the verbosity of [Tailwind CSS](https://tailwindcss.com/)
makes me hesitate to use it in my own projects.)

This hides the comments under a **> Discussions** widget (you can see one at
the bottom of this page).  When the user clicks on the
widget, the browser exposes the comments and loads the Giscus Javascript payload.
I verified this behavior by using the Firefox developer tools (right click
and select "Inspect" anywhere on a page), clicking on the "Network" tab, and observing
what happens when I reload the page, and then unhide the comments.

## Selective Enabling of Comments

I disabled comments by default (`enable: false` in `hugo.yaml` above),
so comments need to be enabled on a page-by-page basis, by putting
the following line in the page's frontmatter:

```yaml
comments: true
```
