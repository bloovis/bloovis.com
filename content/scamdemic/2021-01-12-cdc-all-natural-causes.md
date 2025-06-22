---
title: CDC mortality data for all causes and natural causes
date: '2021-01-12 19:22:00 +0000'

tags:
- covid19
---

In an [earlier post](/posts/2020-12-23-cdc-mortality-data/) I described how
to download CDC weekly mortality data for the years 2014 through 2020 and
import them into a MySQL database.

The first interesting piece of data I looked at was the number of
deaths by all causes and by natural causes for each year.  (At the
time of this writing, only the data for the first 49 weeks of 2020 are
available.  To make the comparisons more fair, I used the data for the
first 49 weeeks of all the other years.)

| year | all causes | natural causes |
|:-----|:----------:|---------------:|
| 2014 |    2422841 |        2234024 |
| 2015 |    2541452 |        2336303 |
| 2016 |    2561148 |        2339197 |
| 2017 |    2632472 |        2397635 |
| 2018 |    2669694 |        2436463 |
| 2019 |    2678618 |        2440590 |
| 2020 |    2999326 |        2763829 |

There are several things to be learned from this:

1. The deaths by natural causes make up the great majority of all deaths (92% in 2020, 91% in 2019).
2. Total deaths by all causes were 320708 higher in 2020 than in 2019, an increase of 12%.
3. Deaths by natural causes were 323239 higher in 2020 than in 2019, an increase of 13%.

It is surprising that deaths by natural causes increased by such a
large amount, much greater than the increases for previous years.
Because natural deaths make up most of all deaths, and because
the increase in natural deaths was almost the same (actually slightly greater) in absolute numbers
as the increase in all deaths, it seems likely that they account for most of the increase in all
deaths.  It will be necessary to examine the other causes of death to see if this
is true.
