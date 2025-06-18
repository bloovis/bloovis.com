---
title: Converting Gallery2 albums
date: '2015-12-30 09:23:00 +0000'

tags:
- web
- ruby
- nanoc
---
As mentioned [earlier](../28/eliminating-gallery2.html), converting Gallery2
albums to nanoc-based albums involves a great deal of error-prone typing.  To save
some of this effort, I wrote a Ruby script that reads a Gallery2 database and outputs
album descriptions in the format that I defined for use with nanoc.<!--more-->

The first step was to copy the database from the BSD host to my local
Linux machine.  I did this by using `mysqldump` on the BSD host to create a dump
of the database, then read the dump into mysql on the Linux machine to 
create the "gallery2" database.

Then I wrote a following script to read the database and output the album descriptions.
I was aided in this by the description of the [Gallery2 schema](http://codex.galleryproject.org/Database_Schema_%28G2%29).
It wasn't obvious from the schema description how to determine's an album's highlight picture,
but I found some code in [this Perl script](https://github.com/dschwen/g2piwigo/blob/master/convertcomments.pl) that showed how.

    #!/usr/bin/env ruby

    require 'rubygems'
    require 'active_record'

    class Gallery < ActiveRecord::Base
       self.abstract_class = true
       establish_connection(
         :adapter  => "mysql",
         :host     => "localhost",
         :username => "bloovis",
    #     :password => "secret",
         :database => "gallery2"
       )
    end

    class AlbumItem <  Gallery
      self.table_name = "g2_AlbumItem"
    end

    class Item < Gallery
      self.table_name = "g2_Item"
    end

    class ChildEntity < Gallery
      self.table_name = "g2_ChildEntity"
    end

    def get_albums
      AlbumItem.all.map {|album| album.g_id}
    end

    def get_item_info(id)
      results = Item.select("g_pathComponent as image, g_title as title, " +
                            "g_summary as caption").
                     joins("inner join g2_FileSystemEntity " +
                           "on g2_FileSystemEntity.g_id=g2_Item.g_id").
                     where("g2_Item.g_id = ?", id)
      results.length > 0 ? results[0] : nil
    end

    def get_highlight(id)
      results = ChildEntity.select("d2.g_derivativeSourceId").
                            joins("inner join g2_Derivative d1 " +
                                  "on g2_ChildEntity.g_id = d1.g_id " +
                                  "inner join g2_Derivative d2 " +
                                  "on d1.g_derivativeSourceId=d2.g_id").
                            where("g2_ChildEntity.g_parentId = ?", id)
      results.length > 0 ? get_item_info(results[0].g_derivativeSourceId) : nil
    end

    def main
      ids = get_albums
      ids.each do |id|
        album_info = get_item_info(id)
        puts "---"
        puts "title: #{album_info.title}"
        puts "root: ../.."
        puts "kind: album"
        puts "priority: 0"

        highlight = get_highlight(id)
        unless highlight.nil?
          puts "highlight: #{album_info.title}/#{highlight.image}"
        end

        results = Item.select("g2_Item.g_id").
                       joins("inner join g2_ChildEntity " +
                             "on g2_ChildEntity.g_id=g2_Item.g_id").
                       where("g_parentId = ?", id)
        puts "images:"
        results.each do |result|
           item_id = result.g_id
           item_info = get_item_info(item_id)
           puts "  - image: #{album_info.title}/#{item_info.image}"
           puts "    title: #{item_info.title}"
           puts "    caption: #{item_info.caption}"
        end

        puts "---"
        puts "#{album_info.caption}"
        puts "==================="

      end
    end

    main

You'll need to supply different arguments to the `establish_connection` function,
according to your actual user, host, and database names.

The script outputs the album descriptions separated by rows of equal signs.
Use an editor or a sed script to separate these into separate album descriptions,
which will live in `content/albums`.  You'll probably want to change the `priority`
fields, according to how you want the album list to be sorted in the top-level gallery.

The script also makes the assumption that the album photos live in a
subdirectory of `content/gallery` that has the same name as the album
title.
