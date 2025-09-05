---
title: JavaScript is a Wonderful, Terrible Language
date: '2025-09-03'
comments: true
draft: false
tags:
- linux
- software
- hugo
- javascript
- ruby
---

I was forced to learn a tiny bit of JavaScript in order to fix
some problems I had with the Hugo Hextra theme I'm using.
I made a newbie blunder during that process, which led me
to attempt to learn more about this ubiquitous language.
I started working through with the
[MDN JavaScript Guide](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide),
and after only a few minutes I came across language features that
made me laugh out loud or barely suppress vomiting.
<!--more-->

I recognize that the inventor of JavaScript, Brendan Eich, is a brilliant
fellow who whipped together the first JavaScript in ten days, back
in late 1900s.  I can see that he was trying to come up
with something that would be a bit Java-like (for familiarity) but
useable in a browser.  It's obvious that the language is powerful
and suitable for a wide range of tasks.  

But some of the design choices seem horrible, compared with
Ruby, the language I use the most now, after C.  To be sure, Ruby
isn't perfect, and C is ancient and crufty.  But at least they have
some consistency and predictability.  Surely the people
who have improved JavaScript since the early days could have done
better.  Here are some of the things about JavaScript that made me laugh or feel ill,
just in the first couple of days of my studies.

## The Boolean Hack

When I was trying to debug the search function in Hextra, I came across
this mysterious line:

```js
const paragraphs = content.split('\n').filter(Boolean);
```

The use of a type class name (`Boolean`) as an argument to `filter`
seemed weird.  I looked up `filter` and found that it is supposed
to take a callback function as a parameter.  So I assumed that
passing `Boolean` as callback function was a bug.  But later I found
I was wrong about this: it turns out that `Boolean` can also be used
as a function that tries to return a "truthy" value for whatever object
is passed to it.  So in the above example, `Boolean` will return
false if the string (i.e., paragraph) passed to it is empty.

In Ruby, you'd write it this way:

```ruby
paragraphs = content.split("\n").reject{|p| p.length == 0}
```

It's more verbose, but the intent is clear; we're not depending
on implicit type coercions to determine truthiness.

## Hoisted Variables

The three kinds of variable declarations (`var`, `let`, and `const`) made
my head spin.  There is no way a newbie can tell just from the
names of these three kinds what their scoping rules might be.
But the worst part is the so-called "variable hoisting".
This feature allows you to use a variable before it's declared.
Here's an example from MDN:

```js
(function () {
  console.log(x); // undefined
  var x = "local value";
})();
```

What happens is that the declaration of the variable, but *not* its assignment,
is treated as if it appeared at the beginning of a function.  I have no
idea why this feature is present, except that maybe it's needed for 
frameworks that generate JavaScript on the fly.  At least in Ruby,
we don't need to declare variables: just use them, and the scoping
rules are simple.

## Destructuring Syntax

Javascript is full of weird shortcuts that make up for the lack of imagination
in its basic design.  One such weirdness is the so-called "destructuring" syntax.
Here's an example from MDN:

```js
const { bar } = foo;
```

According to MDN, "This will create a variable named bar and assign to
it the value corresponding to the key of the same name from our object
foo."  In Ruby you could do something similar, *and* have a different
name for the assigned variable:

```ruby
plugh = foo.bar
```

But with the Javascript hack, the variable *must* have the same name
as the key of the object being accessed.

## Tagged Templates

JavaScript has taken the "interpolated string" feature of languages
like Perl and Ruby, and added a glorious complication called "tagged
templates".  This allows you to interpolate values in a string
using your own specialized function.  This seems like a good idea,
but the [example in MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Template_literals#tagged_templates)
made my head hurt so much that I'm not going
to repeat it here.  I suppose it will make sense eventually,
but right now my response is a gag reflex.

## Spread Syntax

JavaScript, like Python, doesn't have the full-featured iterators
of Ruby.  So it has to make up for this shortcoming with features
like the "three dot" or "spread" operator.  When used in
function calls, it's like "splat" ("*") operator in Ruby.
It also can unpack and copy objects (i.e., key/value sets),
but you have to be careful about the distinction between "deep"
and "shallow" copying of objects.

I first came across this strange feature in the following code
from Hextra:

```js
sectionIndex.add({
  id: url,
  url,
  title,
  crumb,
  pageId: `page_${pageId}`,
  content: title,
  ...(paragraphs[0] && { display: paragraphs[0] })
});
```

This example confused me for a long time, partly due to
presence of the "&&" operator.  But without the three dots,
you get this syntax error in the Firefox console: `expected property name, got '('`.
The three dots are needed for unpacking its operand so that its element(s)
can be used as function argument(s).  In this case, if `paragraphs[0]` is
not empty, the argument `display: paragraphs[0]` is passed to `sectionIndex.add`.

I suppose there isn't anything particularly bad about the three dots,
but it strikes me as a complicated solution for a problem that could
have been simplified with a little more imagination.

## The Future

I'm sure I'll come across more of these surprising and delightful
features as I learn more, and I'll get over my distaste with
the passing of time.  I never had to do this kind of acclimation
when I was learning Ruby: it all made sense from the beginning
and continues to be a pleasant language to work in.  But I
can't expect that kind of pleasure with everything in the
field of programming languages.  One could adapt the motto
of the Mutt email client to Ruby: "All languages suck, but
this one sucks less."

## I'm Not Alone in This

It's reassuring to learn that I'm not the only one who has these
feelings about Javascript.  Way back in in 2014, James Mickens, who used to
work at Microsoft, and is now at [Harvard](https://mickens.seas.harvard.edu/),
gave a [hilarous talk](https://vimeo.com/111122950)
about how terrible the web is.  He also wrote an
[equally hilarious column](https://www.usenix.org/system/files/1403_02-08_mickens.pdf)
for Usenix about how terrible the web is.  Things haven't improved since then; in fact,
the overuse of AI by lazy programmers is bound to make things worse -- *much, much* worse.
