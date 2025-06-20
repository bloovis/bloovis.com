---
title: Mailing labels in Linux
date: '2018-06-22 04:51:00 +0000'

tags:
- linux
- software
---

Once a year our library sends out appeal letters to donors, using mailing labels that
we print ourselves.  The librarian keeps a list of donors in a spreadsheet that
records their names, addresses, and past donation amounts.  Formerly the librarian
attempted to use MS Office to generate the labels, but this was an error-prone and
time-consuming operation.  I prefer to automate processes like this using scripts
and open source software instead of GUIs, so I took on this task.

<!--more-->

The first step was to install [labelnation](https://www.red-bean.com/labelnation/),
a "command-line label-printing program".  That was the easy part.

The next step was more difficult: I needed convert the librarian's
spreadsheet into one that could be fed to labelnation.  The
spreadsheet provided by the librarian, when converted to CSV in
LibreOffice Calc, was in this format:

    "firstname", "surname", "street address", "city", "state", "zipcode"

But labelnation wants to read a CSV file in this format:

    "line 1", "line 2", "line 3"

where each of the three cells is printed on a separate line in the label.

I wrote the following script to convert the former into the latter:

```ruby
#!/usr/bin/env ruby

require 'csv'

# Check arguments. First is input file.  Second is output file.
if ARGV.length < 2
   puts "usage: labels.rb inputfile.csv outputfile.csv"
   exit 1
end

input_file = ARGV[0]
output_file = ARGV[1]
if File.exist?(output_file)
  puts "#{output_file} exists; will not overwrite."
  exit 1
end

out = CSV.open(output_file, "wb", { force_quotes: true })

CSV.foreach(input_file) do |row|
  firstname = row[0]
  lastname  = row[1]
  address   = row[2]
  city      = row[3]
  state     = row[4]
  zipcode   = row[5]
  out << [ "#{firstname} #{lastname}", address, "#{city}, #{state} #{zipcode}" ]
end

out.close
```

Now that I had a CSV file in the correct format, I used labelnation to generate
a Postscript file for Avery 5160, the label type we use:

    labelnation --font-size 10 --csv -t Avery-5160 -i labels.csv -o labels.ps

Then I converted the Postcript to a PDF file that I could send back to the librarian
for printing:

    ps2pdf labels.ps labels.pdf

The first time the librarian tried to print the labels, they came out slightly out of
alignment: the top labels were fine, but the farther from the top they were, the more
they were shifted upwards, so that the bottom labels were nowhere close to being centered.
After much struggle, I determined that the problem was that the librarian was using
Google Chrome's internal PDF viewer, which was scaling the PDF to 96% of normal.  (For testing,
I had been using Linux Mint's PDF viewer, `xreader`, which did not have this problem.)
When the librarian told Chrome to scale the labels to 100%, the problem disappeared.
