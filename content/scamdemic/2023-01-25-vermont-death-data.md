---
title: Vermont Death Certificate Data
date: '2023-01-25 14:48:00'
draft: false
tags:
- covid19
---

(Sarcasm is *OFF* for this post.)

Substacker Ashmedai has been writing some valuable articles about
[mortality in Vermont](https://ashmedai.substack.com/archive?sort=search&search=vermont),
using death certificate data that he obtained from the state
of Vermont.  These data are now available on
[DailyClout](https://campaigns.dailyclout.io/campaign/item/b8cec42b-15fa-4f24-906e-dca909ab161e/).
The data consists of two very large CSV files, containing a total
of 46964 records for death certificates in Vermont from 2015 through October 2022.

It is tempting to import these CSV files directly into a spreadsheet program,
but their large size could cause problems.  Ashmedai admitted in one of his
articles that Excel crashed at one point during the processing of
these data.  I'm trying to avoid these problems by importing these data
into a MySQL database.  Performing queries and calculations on databases
will be slower than a spreadsheet, but the tables are stored on disk,
so they can be much larger than will fit into memory.

When I looked at the CSV files linked to above, I noticed several problems
I needed to correct before I could import the data into MySQL:

1. Many fields were empty.  By default, MySQL does not like importing empty (NULL) fields,
so empty text fields needed to be replaced with zero length strings,
and empty numeric fields need to be replaced with 0.

2. Dates were in the nonsensical American date format (MM/DD/YYYY) and needed
to be converted to the ISO standard (YYYY-MM-DD).

3. Some timestamps used out of range values for hours and/or minutes, like 99,
and needed to be changed to 0.

4. Many columns contained data that should not be needed for trend analysis,
such as veteran war information, or information about the disposal of bodies,
and should be deleted to save storage space and query time.

I wrote a script that performed these fixes, wrote a MySQL script for
creating the table prior to importing the CSV files, and finally
imported both files.  I ran a few simple queries, and verified that
they match very closely what Ashmedai found in his analysis.  I placed
these scripts, information about how to import the data, and sample
queries on a Gitlab page [here](https://gitlab.com/bloovis/covid).

In future posts, I'll show how to run queries on the death certificate
data and graph the results.

