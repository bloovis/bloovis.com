---
title: Disabling the send cart button in Koha
date: '2020-05-23 12:24:00 +0000'

tags:
- linux
- software
- debian
- koha
---

Our library has enabled the cart feature in the Koha OPAC, which allows patrons
to create a list of books they're interested in.  Some patrons have used
the "Send" feature of the cart, which allows them to send the cart
to an arbitrary email address.  But there have been several problems with this,
such as bad email addresses causing the emails to be redirected to the sysadmin (me).

I decided to suppress the ability to send the cart by hiding the "Send" button.
In Administration / Global system preferences, edit the OPACUserJS preference
to look like this:

```
$(document).ready(function(){
    $('#userbasket .toolbar a.send').hide();
});
```

If there already is a "ready" function in OPACUserJS, add the "hide" line shown above
to that function.
