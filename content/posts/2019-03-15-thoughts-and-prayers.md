---
title: Thoughts and Prayers
date: '2019-03-15 14:00:00 +0000'

tags:
- rants
---

Here's a little program to generate a very sincere, heartfelt public
response to a tragedy.
<!--more-->

    #include <signal.h>
    #include <stdio.h>
    #include <unistd.h>

    #define MASS_MURDER SIGINT

    void knee_jerk(int sig)
    {
      printf("\nOur thoughts and prayers are with the families "
             "of the victims.\n");
    }

    int do_nothing(void)
    {
      printf("La-di-da...\n");
      sleep(5);
      return 1;
    }

    int main(int argc, const char *argv[])
    {
      printf("Hit Control-C whenever a mass murder occurs.\n");
      signal(MASS_MURDER, knee_jerk);
      while (do_nothing())
        ;
      return 0;
    }
