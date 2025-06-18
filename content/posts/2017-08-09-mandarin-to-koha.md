---
title: Converting from Mandarin M3 to Koha
date: '2017-08-09 18:44:00 +0000'

tags:
- linux
- software
- debian
- koha
---

I wrote previously about [Koha](https://koha-community.org/), an open source library system
that our little (24,000 book) library in Vermont is now using.
Before we switched to Koha, we were using Mandarin M3. This is a proprietary
system that is accessed primarily through a Windows application that connects to
a database server hosted by Mandarin.  The system worked fairly well, but there
were a number of problems and annoyances (not to mention pricing) that pushed us
to move to Koha.  But migrating our catalog, patron list, and checkout information
to Koha was a challenge, and we didn't want to do it manually, which could
take months.  I ended up writing some Ruby scripts to perform these tasks.

<!--more-->

### Github

Before I describe the migration scripts, go ahead and take a look at them here:
[https://gitlab.com/bloovis/marc](https://gitlab.com/bloovis/marc)

### Catalog

Mandarin's web application can export a catalog as a series of MARC 21 records,
but the holding information is in an entirely different format from what
Koha expects.  In general, holding information isn't defined by the
[MARC 21 standard](https://www.loc.gov/marc/bibliographic/), which is mainly
concerned with bibliographic records.  So each library
system implements its own extensions to MARC 21.  Mandarin stores holding
information in a MARC 852 field, while Koha stores this information in a 952 field,
and the subfields are entirely different in meaning. Also, Mandarin uses
the MARC-8 character encoding for non-ASCII characters, while Koha uses
the more modern UTF-8 encoding.

To handle these differences, I wrote a script called
[m2k.rb](https://gitlab.com/bloovis/marc/-/blob/master/m2k.rb) to convert
Mandarin MARC records to Koha MARC records.  Much of the script is very
specific to our own library, especially in how it determines a book's
call number, shelving location, and item type.  But my hope is that
other libraries could use it as a template for doing their own conversions.

### Patrons

The second set of data that needs to be converted to Koha is the patron
list.  Mandarin can export this list as a set of MARC records,
but Koha needs to import it as a CSV file with specific column names.
I wrote a script called [patroncsv.rb](https://gitlab.com/bloovis/marc/-/blob/master/patroncsv.rb)
to perform the conversion.  This script also has some code that is specific
to our library, such as the library's branch code in our state-wide library system,
and the local towns served by our library.  But otherwise, it should
be fairly easy to modify for another library's purposes.

### Checkouts

At the time of our conversion to Koha, there were several hundred books checked
out to patrons in Mandarin.  It would have been a daunting task to enter all
of this checkout information manually, so I wrote a script to allow this information
to be imported into Koha.

The first step is to use Mandarin's report generator (a rather difficult to use
Windows application) to generate a report for "loan list by patron".  Once you
have generated this report, you must save it as PDF file.  Windows doesn't have
a PDF printer driver installed by default, so you must install one yourself.
I used one called [CutePDF](http://www.cutepdf.com/).  With CutePDF installed,
you can now generate the PDF for the Mandarin report by printing it to the CutePDF
"printer", which will ask you for the name of the file to which the PDF file should
be saved.

Now that you have the PDF report of the loan list, you can feed it to the
somewhat poorly named [pdf2koc.rb](https://gitlab.com/bloovis/marc/-/blob/master/pdf2koc.rb) script.
This script will read the PDF report and generate a Koha Offline Circulation (KOC)
file.  You can then import this KOC file into Koha: on the Circulation page,
click on "Upload offline circulation file (.koc)".

In order for this to work you must have previously set up your circulation rules,
especially the loan periods, which Koha will use to calculate due dates.
