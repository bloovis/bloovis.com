---
title: Koha Configuration
date: '2018-03-04 15:05:00 +0000'

tags:
- linux
- software
- debian
- koha
---

Once you've [installed Koha](/posts/2017-01-18-koha-on-linode/), you'll need
to do some configuration in Koha itself to get ready for use in a library.
All of this can be done in the staff client, so log in with the same user
name and password that you used to log in during installation.

<!--more-->

ByWater's [Post Training Checklist](http://bywatersolutions.com/education/koha-post-training-checklist/)
is a good summary of the kinds of things you might want to configure.
Below is a more detailed list that includes real-world examples.
Once the configuration is complete, you can test Koha using
ByWater's [Test Plan](http://bywatersolutions.com/koha-testing-plan/complete-koha-test-plan/).

### Libraries and groups

The first thing you'll need to do is add one or more libraries.
Get there by selecting More / Administration, then select Libraries
and Groups under the Basic parameters heading.  Select New library
to add a library.  The library code should have been assigned to
you already by the state library system.

### Item types

Before you can add bibliographic and holding records, you'll need
to define item types.  Koha uses item types to define circulation
rules.  For example, books might have a three week checkout limit,
DVDs might be one week, and reference books might not be allowed
to be checked out at all.  So you might want to have an item
type for each of these categories.

Choose item type descriptions whose meaning will be clear to both patrons
and staff.

Here is an example item type list:

| Code | Description |
|------|-------------|
| CAS | Audio Cassette |
| CD | Audiobook |
| BK | Book |
| PC | Computer |
| CARD | Credit card |
| DVD | DVD |
| ER | E-reader |
| KEY | Keys |
| MAG | Magazine |
| MAP | Maps |
| MX | Mixed Materials |
| PASS | Museum/Park pass |
| MU | Music CD |
| NEW | New book |
| REF | Reference |
| VC | Video Cassette (VHS) |

### Shelving Locations

Next, you'll need to define shelving locations.  These will make it easier
to locate books in their physical locations.  Koha also uses locations (in
addition to call numbers) to show books in its "Browse shelf" feature.

To define locations, select Administration / Authorized values (under
Basic parameters).  Then select "LOC" in the "Show category" dropdown.
Koha may already have a set of predefined locations; you can edit these
or delete them as needed.

To add a location, select the button labelled "New authorized value for LOC".
Choose location descriptions whose meaning will be clear to both patrons
and staff.

Here is an example shelving location list (you may not need such a finely
grained list):

| Authorized value | Description |
|------------------|-------------|
| BIO | Biography |
| CD | CD |
| J | Children's Room -- Other |
| JBIO | Children's Biographies |
| JCD | Children's CDs |
| JDVD | Children's DVDs |
| JFIC | Children's Fiction |
| JNFIC | Children's Non-fiction |
| PIC | Children's picture books |
| EZ | Children's EZ readers |
| BABY | Baby/board books |
| XMAS | Christmas |
| DVD | DVD |
| FICD | Fiction Downstairs |
| FICU | Fiction Upstairs |
| LP | Large Print |
| NEWFIC | New Fiction |
| NEWNFIC | New Non-fiction |
| NFIC | Non-fiction |
| DISPLAY | On Display |
| PBK | Paperbacks |
| REF | Reference |
| STAFF | Staff Office |
| STO | Storage |
| VT | Vermont Room |
| YA | Young adult |

### Collections

Next, you'll need to define collections.  One strategy is to define
groups of holdings by target audience (adults, children, etc.).  You
may also want to define a more finely grained set of categories
(fiction, non-fiction, graphic novels, etc.).  Koha allows users to
narrow down searches by collection.

To define collections, select Administration / Authorized values (under
Basic parameters).  Then select "CCODE" in the "Show category" dropdown.
Koha may already have a set of predefined collections; you can edit these
or delete them as needed.

To add a collection, select the button labelled "New authorized value for CCODE".
Choose collection descriptions whose meaning will be clear to both patrons
and staff.

Here is an example collection list (you may need a more finely
grained list):

| Authorized value | Description |
|------------------|-------------|
| A | Adult |
| J | Children |
| YA | Young adult |
| VTA | Vermont Adult |
| VTJ | Vermont Children |
| VTYA | Vermont Young adult |

### Patron types

Koha comes with a predefined set of patron categories, such as Patron, Staff, Student,
Teacher, and so forth.  You can view or change these at Administration / Patron
categories (under "Patrons and circulation").

Once you have imported or created a patron list, you will want to put at least one patron
in the "Staff" category, and assign him/her a password.  This will be the person
authorized to log into the staff client.  It is better to log in using this patron's
username and password, instead of the master username and password that Koha created
during installation.

To assign a patron to the Staff category, or to make any other changes to a patron record,
select the Patrons link at the upper left of the staff client screen.  Search for the
patron by name or browse by first letter.  Once you see the patron you want to change,
click on the name to bring up the record for that patron.  Click on the Edit button
to change the patron's category, username, password, and other information.

For a patron in the "Staff" category, you will want to change that person's
permissions.  While viewing that person's patron record, click on More / Set permissions.
This will present a screen that lets you set specific permissions, or you can
give that person all possible permissions by clicking on "superlibrarian"
permission at the top.

It can also be helpful to define a new patron category called "Restricted".  You
can use this to restrict patrons in this category to a certain number of checkouts
(see Circulation Rules below for more information).

### Circulation Rules

Circulation rules define how long items of a particular type can be loaned to patrons
of a particular type.  At the very least, you should define a default rule
for all item and patron types, and then define rules for specific item and patron
types.  When checking out an item, Koha searches the circulations rules from the more specific
to the more general, so it will use your "all/all" default rule if it can't
find a more specific matching rule.

View or change your circulation rules by selecting Administration / Circulation and fines rules
(under the Patrons and circulation heading).

In each circulation rule, you may want to set "On shelf holds allowed"
to "If all unavailable".  This prevents users from placing holds that are on
the shelf (i.e., not checked out).

It may be helpful to define a limit on the total number of checkouts per patron.
You can define this limit on the circulation rules page under the heading
"Default checkout, hold and return policy".

If you have defined a "Restricted" patron category, as suggested above in "Patron Types",
you can set a limit on the number of checkouts allowed to this category.  You can do
this by creating a circulation rule specifically for the "Restricted" patron category.
For example, you can add a rule limiting patrons in this category to one checkout.

In our library we set the system preference "useDaysMode" to "circulation rules only".
This prevents due dates from being affected by any calendars we might add later that
specify the library's open and closed days.

### Cities and Towns

As a convenience when adding patrons, you can define towns
at Administration / Cities and towns (under Patrons and circulation).  Then when
you add a patron, you can select a town from a drop-down list instead of
manually typing the town name and zip code (an error-prone process).

### Automatic item modifications by age

Koha has the ability to modify items by their age.  This is useful for changing
the item types and locations of new books to those of ordinary books when they
reach a certain age.  These rules can be added at Tools / Catalog / Automatic item modifications by age.
Here are the rules we used to modify new books after 6 months:

| Age | Conditions | Substitutions |
|-----|------------|---------------|
| 180 days | items.itype = NEW | items.itype = BK |
| 180 days | items.location = NEWFIC | items.location = FICD |
| 180 days | items.location = NEWNFIC | items.location = NFIC |
| 180 days | items.location = NEWBIO | items.location = BIO |

The one problem with these rules is that our fiction is divided into
two locations: upstairs (fiction for authors A through Coben) and downstairs (everything
after Coben).  So after the automatic modifications described above
take place, it's necessary to check for mis-located fiction.  This can be
done by defining a new SQL report with the following SQL:

    select CONCAT('<a href=\"/cgi-bin/koha/cataloguing/additem.pl?biblionumber=',
                  biblio.biblionumber, '\">', biblio.biblionumber, '</a>' ),
           items.barcode,items.itemcallnumber,items.location,biblio.title,biblio.author
	   from items left join biblio on biblio.biblionumber = items.biblionumber
	   where location = 'FICD' and items.itemcallnumber <= 'FIC COBEN'
	   or location = 'FICU' and items.itemcallnumber > 'FIC COBEN'

This produces a list of mis-located fiction, with a link to the page for
editing each item.

Define a new SQL report at Reports / Guided Reports / Create from SQL.
Run your new reports at Reports / Guided Reports / Use Saved.
	
### Preferences

Koha has a very large range of preference settings that fine-tune its appearance and features.
To find these, select Administration / Global System Preferences.  You can then find
a particular preference by name in the System Preference Search entry field at
the top of the screen.

Here is a list of some preferences that we modified:

**LibraryName**: set this to the name of the library to be shown in the OPAC.

**AdvancedSearchTypes**: this preference allows you to add tabs for collection
codes and shelving locations to the Advanced Search web page in both the OPAC and the staff
client.  This is useful
for narrowing down search results to a specific book audience and physical location.
To add these tabs, set the value to "itemtypes|ccode|loc" (without the quotes).

**AudioAlerts**: setting this to "Enable" causes Koha to emit beeps ("audio alerts")
in the staff client for things like checkouts, checkins, etc.  You can enable or disable specific
alerts by visiting Administration / Item circulation alerts (under "Patrons
and Circulation").

**OPACShelfBrowser**: setting this to Show enables the "Shelf browser" feature
of the OPAC.

**OPACShowBarcode**: set this to "Show" to show an item's barcode on the holdings tab.

**OPACBaseURL**, **staffClientBaseURL**: these should be set to the URLs
of the OPAC and staff clients, once you have a proper doman name for
your installation.

**itemBarcodeFallbackSearch**: setting this to "Enable" allows you to use a keyword search
instead of a barcode when checking out books.

**maxreserves**: this sets the limit on the number of holds a patron may place.

**AllowRenewalLimitOverride**: setting this to "Enable" allows staff to manually override
the limit on number of renewals on an item.

**AllowTooManyOverride**:  setting this to "Enable" allows staff to manually override
the limit on number of checkouts per patron.

**OpacNav**: set this to HTML that you'd like to see on the left side of the OPAC,
typically navigation links (e.g., links to searches for new books, etc.).

**EnhancedMessagingPreferences**: set this to "Allow" to allow patrons to
opt in or out of specific notices (holds, checkouts, items due, etc.).  Notices
(such as overdues) that are controlled by per-library rules will still be in effect.
 
**OPACAmazonCoverImages**: set this to "Show" to display book cover images from
Amazon in OPAC search results and item details.

**RequestOnOpac**: set this to "Don't allow" to prevent patrons from placing
holds on books in the OPAC.

**reviewson**: set this to "Don't allow" to prevent patrons from making
comments on items in the OPAC.

**AllowHoldPolicyOverride**: set this to "Allow" to allow staff to override
hold policies.

**IntranetUserJS**: this preferences contains Javascript that will be included
in every staff web page.  JQuery can be used to modify web pages (see
[JQuery Library](https://wiki.koha-community.org/wiki/JQuery_Library) for details).
The example below modifies the message that is displayed when attempting
to check out to a patron that has the "Gone no address" flag set:

    $(document).ready(function(){
      $("#circmessages li:contains('doubt')").html(
        "<span class=\"circ-hlt\">Address:</span>Patron's address,
        email, and phone must be verified first.");
    });

**QueryFuzzy**: this preference controls whether searching should use
"fuzzy" matches, which is useful for handling misspelled words.  But
it causes searching by an item's unique barcode to return many results, so
we disabled it.

**RenewalPeriodBase**: this preference controls the starting date for
a renewall.  We set it to "the current date" so that patrons will
get a full renewal period when visit the library and renew an overdue book.

**todaysIssuesDefaultSortOrder**: this preference affects the order that
today's issues are displayed when checking out books to a patron.  It's
counter-intuitive, but setting this to "earliest to latest" causes the
most recent checkouts to appear at the top of the list.  This is desirable
because it means you don't have to scroll down to see the most recent
of a long series of checkouts.

**BorrowerMandatoryField**: add "|email|phone" to this preference to
require that an email address and phone number be filled in when creating
or editing a patron record.

**DisplayClearScreenButton**: setting this to "Show" causes an "X" button
to be displayed on the checkout screen; pressing this button clears the patron
information (which is useful for privacy).

**OPACBaseURL**: set this to the base URL of the OPAC (without a trailing slash).

**intranetreadinghistory**: setting this to "don't allow" prevents staff
from looking at a patron's checkout history.

**AllowFineOverride**: setting this to "Allow" allows staff to override
Koha when it blocks checkouts to a patron due to excessive fees or charges.
This is useful when you have a special patron for Interlibrary Loans
that may have numerous overdue checkouts.

### Calendar

The calendar (Tools / Additional Tools / Calendar) allows you to
define days when the library is closed.  This affects overdue notices
(which can skip the closed days), fines (if any), and due dates.  Our
library is closed on Sunday, Monday, Wednesday, and Friday, so we
defined holidays for those days with the type "Holiday repeated every
same day of the week".  The calendar can also be used to define normal
holidays, such as Christmas and Thanksgiving.

### Custom audio alerts

It's possible to customize audio alerts in Koha.  For example, you can
have the "Search the catalog" feature play a single beep for available items,
or a double beep for non-available items.  This is useful for simulating
the "Status" feature of Mandarin, but with the helpful addition of audible
signals.  Here's how:

First, go to Administration / Additional Parameters / Audio alerts.
Then create the following new alerts, in this order:

| Selector | Sound |
|----------|-------|
| `#catalog_detail td.status:contains('Available')` | beep.ogg |
| `#catalog_detail td.status:contains('Not for loan')` | beep.ogg |
| `#catalog_detail td.status` | critical.ogg |
| `#catalog_results h3:contains('No results')` | critical.ogg |

### Receipt printing

Appendix C ("Configuring receipt printers") in the Koha manual
describes the procedure for customizing Firefox so that receipts
(checkout slips) are printed correctly.  This involves removing
headers and footers from the printed output for the receipt printer.

Appendix C also recommends configuring Firefox so that the print
dialog is not displayed.  This saves time when checking out out
patrons, but may not be a good idea if you intend to use other
printers from the same computer.  One solution is to use a separate
user account for Koha administration only.  Another solution is to use
the same user account, but with a separate [Firefox profile](https://support.mozilla.org/en-US/kb/profile-manager-create-and-remove-firefox-profiles)
for Koha.  Yet another solution is to use Firefox for Koha,
and Chrome for other web browsing when printing might be needed.

### Custom SQL reports

There is a large catalog of SQL reports [here](https://wiki.koha-community.org/wiki/SQL_Reports_Library).
Here are the ones I have modified:

#### Loan list by patron

This report lists all loans by patron and gives a link to each loaned item:

    SELECT CONCAT('<a href=\"/cgi-bin/koha/catalogue/detail.pl?biblionumber=', biblio.biblionumber, '\">',
         biblio.biblionumber, '</a>' ) AS biblionumber,
         biblio.title, author, surname, firstname, borrowers.sort1, 
         items.itemcallnumber, items.barcode, issues.issuedate, issues.lastreneweddate 
      FROM issues 
      LEFT JOIN borrowers ON borrowers.borrowernumber=issues.borrowernumber 
      LEFT JOIN items ON issues.itemnumber=items.itemnumber 
      LEFT JOIN biblio ON items.biblionumber=biblio.biblionumber 
      WHERE issues.branchcode=<<Checked out at|branches>>
      ORDER BY issues.branchcode, borrowers.sort1, borrowers.surname, issues.issuedate, biblio.title

#### Checkout by Shelving Location

    SELECT c.lib AS collection, l.lib AS shelving_location, t.description as item_type,
           count(s.datetime) AS count 
    FROM items i
    LEFT JOIN itemtypes t on t.itemtype = i.itype
    LEFT JOIN statistics s USING (itemnumber)
    LEFT JOIN authorised_values l ON l.authorised_value = i.location AND l.category = 'LOC'
    LEFT JOIN authorised_values c ON c.authorised_value = i.ccode AND c.category = 'CCODE' 
    WHERE date(s.datetime) BETWEEN <<Date BETWEEN (yyyy-mm-dd)|date>> AND <<and (yyyy-mm-dd)|date>> 
          AND s.type='issue'
    GROUP BY i.ccode, i.location 
    ORDER BY i.itype, i.ccode, i.location ASC

#### Checkout by Item Type

    SELECT t.description as item_type, count(s.datetime) AS count
       FROM items i LEFT JOIN statistics s USING (itemnumber)
       LEFT JOIN itemtypes t ON t.itemtype = i.itype
       WHERE date(s.datetime) BETWEEN <<Date BETWEEN (yyyy-mm-dd)|date>> AND <<and (yyyy-mm-dd)|date>>
       AND s.type='issue' GROUP BY item_type  ORDER BY item_type ASC
