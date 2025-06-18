---
title: License plates and prime numbers
date: '2014-06-10 10:52:25 +0000'

tags:
- ruby
- software
---
When I received a new license plate three years ago, I was delighted to learn that its numeric portion, 827, was a prime number that was also the sum of consecutive primes (103 + 107 + 109 +113 + 127 + 131 + 137).  Then a couple of days ago, while staring at a friend's license plate and wondering if it was also a prime (it wasn't), I decided to find out if there were other license plates that had the same property as my 827.  Without Googling the answer, I wrote the little program below.  The results were quite interesting, especially for 863, which can be summed four different ways.

<pre class="brush: plain">
#!/usr/bin/ruby

# Prints primes that are sums of consecutive primes.

require 'prime'

if ARGV[0]
  max = ARGV[0].to_i
else
  max = 999
end

primes = []
Prime.each(max) {|n| primes << n}
nprimes = primes.length
maxprime = primes[nprimes - 1]

list = []
(0 .. nprimes - 1).each do |low|
  sum = primes[low]
  min = [low + 1, nprimes - 1].min
  c = [sum]
  (min .. nprimes - 1).each do |high|
    sum += primes[high]
    if sum > maxprime
      break
    end
    c << primes[high]
    if Prime.prime?(sum)
      copy = []
      c.each {|x| copy << x }
      list << [sum, copy]
    end
  end
end

list.sort! {|a,b| a[0] == b[0] ? a[1].length <=> b[1].length : a[0] <=> b[0] }

list.each do |x|
  print "#{x[0]} is sum of consecutive primes:"
  x[1].each {|n| print " #{n}" }
  puts ""
end
</pre>
