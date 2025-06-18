---
title: Infinite recursion in Rails associations
date: '2017-06-20 10:29:00 +0000'

tags:
- ruby
- rails
- software
---

I'm working on a Rails 5.0 project that is using an existing database.  This kind
of project is more difficult than creating a database from scratch using Rails
migrations.  One problem is that the existing database doesn't use Rails conventions
for the names of its columns.  That led me to a bone-headed mistake in my
model associations that caused Rails to get into an infinite recursion.

<!--more-->

The database I was given was designed to represent courses in a free
cabin-fever "university" for our small town (a common thing in Vermont).
There was a `people` table and a `courses` table.  Each course could
have up to two professors and one greeter, so there there three columns
in the `courses` table that were IDs referencing the `people` table.

(If I had designed the tables from scratch, I would have created separate
`professors` and `greeters` tables that would have expressed the relationships
between a course and its professors and greeter.  Then each row in the
`professors` and `greeters` tables would have had exactly one reference
to `people`.  That would simplify expressing the associations in the Rails
models.)

In addition to the "three person IDs in one course record" problem, the
names of the person ID columns did not have the "_id" suffix in accordance
with the Rails conventions.

This led me to making the following bone-headed mistakes in my `Course`
model:

    belongs_to :professor_1, class_name: "Person", foreign_key: "professor_1"
    belongs_to :professor_2, class_name: "Person", foreign_key: "professor_2", optional: true
    belongs_to :greeter,     class_name: "Person", foreign_key: "greeter",     optional: true

This caused Rails to get into an infinite recursion and report a stack
overflow when it tried to resolve the associations.  It took me a long
time to figure out the problem, and Google wasn't a lot of help,
apparently because most people aren't as inexperienced with Rails as I.

The problem here was that the name of each association (the first argument
to `belongs_to`) was the same as the name of its `foreign_key`.  The solution
was to rename those foreign keys to follow Rails conventions, so that
`professor_1` was renamed to `professor_1_id`, and so forth.  Then
the associations could be expressed more simply (and without infinite recursion!):

    belongs_to :professor_1, class_name: "Person"
    belongs_to :professor_2, class_name: "Person", optional: true
    belongs_to :greeter,     class_name: "Person", optional: true
