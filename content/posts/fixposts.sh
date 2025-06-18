#!/bin/sh
perl -pi \
  -e 's/kind: article//;' \
  -e 's/.*img src="([^"]+)".*caption="([^"]+)".*/![$2]($1)/;' \
  -e 's/<code>([^<]+)<\/code>/\`$1\`/g;' \
  -e "s/<\/?pre.*>/\`\`\`/;" \
"$@"
