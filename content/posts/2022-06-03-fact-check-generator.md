---
title: Fact-check Generator
description: Automating propaganda is the wave of the future
date: '2022-06-03 12:42:00 +0000'

tags:
- covid19
---

Greetings, devotees of The Science™!  Here at the the Ministry of
Truthiness, we're making sure that fact checkers in our propaganda
outlets, like Reuters, are using our
[standard template](https://joomi.substack.com/p/anatomy-of-the-reuters-fact-check?s=r)
to ensure the greatest effectiveness of our lies.  You can help us out by creating your own
fact-check articles, using the handy-dandy, super-scientific program
below.  Just change the variables to create an all-new fact-check
article whenever you detect that the proles are starting to distrust
the Standard Narrative about the Worst Disease Ever.

<!--more-->
```ruby
#!/usr/bin/env ruby

# This program creates a Reuters fact-check article about Covid-19,
# using a template described here:
#   https://tinyurl.com/factcheckprogram
# (Link to joomi.substack.com)

# Change the following variables to customize the fact-check article.

symptom         = "myocarditis"
bad_doctor      = "Dr. Peter McCullough"
bad_news_outlet = "Children's Health Defense"
strawman_claim  = "millions of Americans have died of myocarditis\n" +
                  "after receiving the COVID-19 vaccine"
good_expert     = "Dr. Anthony Fauci"
good_org        = "NIAID"
word_salad      = "Experts recommend COVID-19 vaccine boosters\n" +
                  "to protect against illness and hospitalization."

# Output the fact-check article using a standard template.
puts <<EOM
Date: #{Time.now.strftime('%B %-d, %Y')}

There is no evidence that the COVID-19 vaccines cause #{symptom}.

The claim was made by #{bad_doctor} on #{bad_news_outlet},
a far-right news outlet. 

Experts explain that there is no evidence that #{strawman_claim}.

“Further studies will be needed,” said #{good_expert} from
#{good_org}. “But at this time, there is no evidence that
#{symptom} is linked with the vaccines.”

#{good_expert} said it was important to note that any occurrences of
#{symptom} are mild and transient.

"The vaccines are safe and effective,” he said. “Although the vaccine does
not prevent symptomatic disease, from a clinical standpoint vaccination
gives protection to the individual against a severe course of disease and
hospitalization as well as contributing to the reduction of transmission
in society."

#{word_salad}

VERDICT

False. COVID-19 vaccines are safe and there is no evidence that COVID-19
vaccines cause #{symptom}.
EOM
```
