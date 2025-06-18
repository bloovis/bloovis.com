---
title: Tweet Generator for Corona Prayer
description: Express your gratitude automatically
date: '2022-09-20 09:09:00 +0000'

tags:
- covid19
---

Greetings, jab-happy social media addicts!  Here at the the Ministry
of Truthiness, we want to make sure that when you inevitably get the
Worst Disease Ever, despite being jabbed up the wazoo, you will
properly demonstrate your virtue by tweeting correctly about it in
accordance with our Corona Prayer guidelines.  Since you might have to do this more
than once, and because typing is such a pain on "smart" phones, we've
written a program for you that can generate the tweets automatically.
To make it seem like you're being original, the program selects random
phrases for you.  Enjoy!

<!-- more -->
```ruby
#!/usr/bin/env ruby

# This program creates a virtuous tweet expressing my gratitude for getting
# Covid despite being "vaccinated".

# Select some phrases randomly so it seems like I'm being original.

today = ["Today",
        "This morning",
	"This evening"][rand(3)]
symptoms = ["a mild cough",
            "no symptoms",
	    "very mild symptoms"][rand(3)]
grateful = ["thankful",
            "grateful"][rand(2)]
vaxxed = ["vaccinated and boosted",
          "fully vaccinated",
	  "three-times vaccinated"][rand(3)]
treatment = ["isolating at home",
             "following CDC guidance",
	     "taking Paxlovid"][rand(3)]

# Output my virtuous tweet.

puts <<EOM
#{today} I tested positive for COVID.

I am experiencing #{symptoms}.

I am #{grateful} for the protection I received from my being #{vaxxed}.

I am #{treatment} until I no longer test positive.

Please get vaccinated and boosted if you have not already done so!
EOM
```

