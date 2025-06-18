---
title: How to use CDC mortality data without the Internet
date: '2020-12-23 07:27:00 +0000'

tags:
- covid19
---

The CDC mortality data for the last two years is difficult to find,
but thanks to a [posting on Lockdown Sceptics](https://lockdownsceptics.org)
I was able to go directly to the [data on the CDC site](https://data.cdc.gov/NCHS/Weekly-Counts-of-Deaths-by-State-and-Select-Causes/muzy-jte6/data).
This site contains death data for all of 2019 and 2020.
But the site is bit clunky to use, and some filter condition operators (such as <=) aren't
supported.  So I decided to download the raw data and import it into MySQL so that
I could run my queries directly.  Here's how I did that:

<!--more-->

The first step is to download the data as a CSV file.  Click on the
"Export" link near the top of the CDC data page mentioned above.
Select CSV and save the resulting file on your computer.  Note that
many of the data fields are empty, which will cause errors when you
try to import the file into MySQL, so use LibreOffice Calc or a text
editor to replace all of the blank entries with 0 (zero).

I've provided a copy of the CSV file [here](/cdc.csv) that has
the blank fields fixed.  I've also deleted the flag columns for simplicity.

Copy the CSV file to the place where MySQL allows data to be loaded:

    sudo cp cdc.csv /var/lib/mysql-files/

Log into MySQL using your usual credentials, and execute the following commands
to create a table that will contain the CDC data:

    create database covid;
    use covid;
    create table cdcweeklydeath (
      jurisdiction varchar(255),
      mmwr_year int,
      mmwr_week int,
      week_ending_date date,
      all_cause int,
      natural_cause int,
      septicemia int,
      cancer int,
      diabetes int,
      alzheimer int,
      influenza_pneumonia int,
      chronic_lower_respiratory int,
      other_respiratory int,
      nephritis int,
      not_classified int,
      heart int,
      cerebrovascular int,
      covid19_multiple int,
      covid19_underlying int);

Finally, import the data:

    load data infile '/var/lib/mysql-files/cdc.csv'
      into table cdcweeklydeath
      FIELDS TERMINATED BY ','
      ENCLOSED BY '"'
      LINES TERMINATED BY '\n'
      IGNORE 1 ROWS;

Now you can perform queries on the data.  As one example, this query compares
the various causes of death for 2019 and 2020:

    select mmwr_year as year,
      sum(all_cause) as all_causes,
      sum(natural_cause) as natural_causes,
      sum(not_classified) as not_classified,
      sum(septicemia) as septicemia,
      sum(cancer) as cancer,
      sum(diabetes) as diabetes,
      sum(alzheimer) as alzheimer,
      sum(chronic_lower_respiratory) as clr,
      sum(other_respiratory) as other_resp,
      sum(heart) as heart,
      sum(influenza_pneumonia) as flu,
      sum(cerebrovascular) as cv,
      sum(nephritis) as neph,
      sum(covid19_multiple) as with_covid,
      sum(covid19_underlying) as from_covid
      from cdcweeklydeath
      where jurisdiction = 'United States'
      group by mmwr_year;

Note that the jurisdiction is "United States", which eliminates
the duplicate counts from the individual states.

In subsequent posts I'll examine some of the more interesting results from these data.

*Update 2021-01-12*: The data for the years 2014 to 2018 can be found on the CDC
web site [here](https://data.cdc.gov/NCHS/Weekly-Counts-of-Deaths-by-State-and-Select-Causes/3yf8-kanr).
I've imported this data, and a dump of the resulting MySQL database can be found
[here](/cdcweeklydeath.sql.gz).
