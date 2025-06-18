---
title: Quarantining books in Koha
date: '2021-03-05 07:36:00 +0000'

tags:
- koha
- covid19
---

In September our little library (which is closed to patrons right now
and only does curbside pickup) was asked by the state library agency
to put returned books in quarantine when they are checked in.  We now
move returned books to a "dirty" table, where they are sanitized once
a week by a volunteer, then moved to a "clean" table.  After resting
there for a couple of days, the books are moved to the shelving cart.

<!--more-->

This procedure means that a returned book could be in quarantine for
as much as a week.  During that week, we want the Koha OPAC to show
the book as being in quarantine, and hence unavailable for checkout.
Then when the book is made ready to be shelved, we want Koha to show
the book as available.

The way to achieve this is to check the book in twice.  On the first
checkin (performed when the book is moved to the "dirty" table"), we
want Koha to mark the book as unavailable and in quarantine.  On the
second checkin (performed when the book is moved the shelving cart),
we want Koha to mark the book as available.  We also want holds to
*not* be fulfilled until the book is checked in the second time.

Here is how we achieved this in the Koha staff client:

1. Go to Administration / Authorized Values.  Find the `NOT_LOAN` category
(should be on the second page).  Add a new authorized value
for `NOT_LOAN` with value -5 and description "Quarantine".

2. Go to Administration / System preferences.  Search for `TrapHoldsOnOrder`.
Set it to "Don't trap".

3. While still in System preferences, search for `UpdateNotForLoanStatusOnCheckin`.
Edit it and add the following lines:

~~~~
0: -5
-5: 0
~~~~

This has the effect of changing the `NOT_LOAN` value of an item to -5 (quarantine)
on the first checkin, and to 0 (available) on the second checkin.

In order to undo this quarantine system, erase everything in the
`UpdateNotForLoanStatusOnCheckin` system preference.
