---
title: PATH manipulation in bash
date: 2025-09-13

tags:
- ruby
- software
---

Here are a couple of bash functions to add or remove an entry from
the PATH environment variable.  Add them to your `~/.bashrc`.

<!--more-->

To append an entry to PATH:

```bash
addpath ()  { export PATH="${PATH}:${1}"; }
```

To remove an entry from PATH:

```bash
rmpath ()   { export PATH=`ruby -e "puts ENV['PATH'].split(':').reject{|x|x==ARGV[0]}.join(':')" -- ${1}`; }
```
