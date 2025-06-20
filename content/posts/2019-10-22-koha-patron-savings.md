---
title: Calculating patron savings in Koha
date: '2019-10-22 22:22:00 +0000'

tags:
- linux
- software
- debian
- koha
---

At least one [library](http://www.wichitalibrary.org/library-receipts-showing-savings-continue-to-interest-public)
is giving patrons a checkout receipt showing how much they saved by using
the library.  ByWater Solutions has provided a [tutorial](https://bywatersolutions.com/education/show-library-cost-savings-on-your-koha-receipt)
that shows how to do this in Koha, by adding some template code and Javascript
to the HTML for the issue slip.  The code works by adding up the replacement costs
for each item in the checkout list.  For an item that has no replacement cost
in its item record, the code uses the default replacement cost associated
with that item's type.
<!--more-->

This solution works well, but in our library we wanted the default replacement costs
to be associated with shelving locations, not item types.  We have minimized the item
types in order to simplify circulation rules (which are based on item types), but we have many
shelving locations, to reflect the actual layout of the library.

To make our checkout slip use the default replacement costs based on shelving location,
we need a modified version of ByWater's solution.

<!--more-->

The first step is to create a new authorized value category called `COST`.
(Authorized values are found in the Koha staff client, in the Administration section,
under the Basic parameters heading.)
This category will contain the same values as the `LOC` category (which is
used for shelving locations), but with the description field containing
the default replacement cost.

As an example, suppose that one of the authorized values in the `LOC` category
is `NFIC`, for non-fiction books.  In the `COST` category, create an `NFIC` value.
Then fill in the description field with the default replacement cost for
that shelving location.  Don't put in a dollar sign, just use a plain number,
like `20.00`.  Create a similar entry in `COST` category for each shelving location.

Now you can modify the checkout slip.  In Tools / Notices & slips, find
the ISSUESLIP and click on its Edit button.  Expand the Email block
and edit the slip as follows:

Insert the following code at the start of the slip:

    [%- USE date -%]
    [% USE AuthorisedValues %]
    [%- manip = date.manip -%]
    [%- today = manip.ParseDate('<<today>>') -%]
    [%- today_date = manip.UnixDate(today,"%m/%d/%Y") -%] 
    [% FOREACH checkout IN checkouts %]
    [%- issue_time = manip.ParseDate(checkout.issuedate) -%]
    [%- issue_date = manip.UnixDate(issue_time,"%m/%d/%Y") -%]
    [% replacement = (checkout.item.replacementprice) %]
    [% IF replacement == "0.00" || replacement == "" || replacement == NULL %]
    [% replacement = AuthorisedValues.GetByCode('COST', checkout.item.location, 0 ) %]
    [% END %]
    <span 
    [% IF issue_date == today_date %]
    class="price"
    [% ELSE %]
    class="price_prev"
    [% END %]
     style="display:none;">[% replacement %]</span>
    [% END %]

Then add the following code to the end of the slip:

    <p>
    <b>Your savings by using your library:</b><br/>
    Today's checkouts: $<span id="price"></span><br/>
    Previous checkouts: $<span id="price_prev"></span><br/>
    </p>
    <script type="text/javascript">
      var x = document.getElementsByClassName("price");
      var i;
      var total = 0;
      for (i = 0; i < x.length; i++) {
        var cost = parseFloat( x[i].innerHTML );
        if ( ! isNaN( cost ) ) {
          total += cost;
        }
      }
      document.getElementById("price").innerHTML = total.toFixed(2);
      x = document.getElementsByClassName("price_prev");
      var prev_total = 0;
      for (i = 0; i < x.length; i++) {
        var cost = parseFloat( x[i].innerHTML );
        if ( ! isNaN( cost ) ) {
          prev_total += cost;
        }
      }
      document.getElementById("price_prev").innerHTML = prev_total.toFixed(2);
    </script>

You may also want to modify any circulation reports you've created to
use a similar calculation of patron savings.  As an example, here
is a report that displays a count of checkouts per collection code,
along with patron savings for each collection.  (The near-duplication
of the query is needed to produce summary totals at the end of the results.)

    SELECT * from
    (select c.lib AS Collection,
           SUM( IF(s.type = 'issue', 1, 0 )) AS Checkouts,
           SUM( IF(s.type = 'renew', 1, 0 )) AS Renewals,
           SUM (IF(s.type = 'issue',
                   if(i.replacementprice is null or i.replacementprice = '',
                      cast(cost.lib as decimal(8,2)), i.replacementprice),
                   0)) AS Savings
    FROM items i
    LEFT JOIN statistics s USING (itemnumber)
    LEFT JOIN authorised_values c
      ON c.authorised_value = i.ccode AND c.category = 'CCODE' 
    LEFT JOIN authorised_values cost
      ON cost.authorised_value = i.location AND c.category = 'COST'
    WHERE date(s.datetime) BETWEEN <<Date BETWEEN (yyyy-mm-dd)|date>>
      AND <<and (yyyy-mm-dd)|date>> 
      AND s.type in('issue', 'renew')
    GROUP BY i.ccode
    ORDER BY i.ccode) as a
    UNION ALL
    (select 'Total' AS Collection,
           SUM( IF(s.type = 'issue', 1, 0 )) AS Checkouts,
           SUM( IF(s.type = 'renew', 1, 0 )) AS Renewals,
           SUM (IF(s.type = 'issue',
                   if(i.replacementprice is null or i.replacementprice = '',
                      cast(cost.lib as decimal(8,2)), i.replacementprice),
                   0)) AS Savings
    FROM items i
    LEFT JOIN statistics s USING (itemnumber)
    LEFT JOIN authorised_values c
      ON c.authorised_value = i.ccode AND c.category = 'CCODE' 
    LEFT JOIN authorised_values cost
      ON cost.authorised_value = i.location AND c.category = 'COST'
    WHERE date(s.datetime) BETWEEN <<Date BETWEEN (yyyy-mm-dd)|date>>
      AND <<and (yyyy-mm-dd)|date>> 
      AND s.type in('issue', 'renew'))
