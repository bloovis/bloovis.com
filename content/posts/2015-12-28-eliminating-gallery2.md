---
title: Replacing Gallery2 with nanoc
date: '2015-12-28 17:05:00 +0000'

tags:
- web
- ruby
- nanoc
---
For many years, this site has used [Gallery2](http://galleryproject.org/)
to provide photo albums.  This large piece of PHP works well, but it
has many of the same disadvantages as Wordpress <!--more--> (which this site also
used once upon a time), plus a few more:

* Slower than static HTML
* Requires an SQL database
* Have to use a clunky web interface instead of a text editor to change photo information
* Due to the previous two items, can't use git for version control
* Appearance not consistent with main site
* Interface somewhat cluttered
* Complications due to authentication (e.g., different login than main site)

Furthermore, Gallery2 has gone into hibernation and is no longer being maintained.

I searched for ways to generate photo albums using
[nanoc](http://nanoc.ws/), and found some simple examples, but I
didn't find anything that would support multiple albums.  (It's
possible that I didn't look hard enough.) After some trial and error,
I came up with an album generator that makes for a decent replacement
for Gallery2, at least in my somewhat simple use case.

The first step is to define a new type of content file called an album,
which lists all of the images in the album, along with their titles
and captions.  Here is a simple album file (one that I'm using on this
site), located in `content/albums/Baby Pictures.md`:

    ---
    title: Baby Pictures
    root: ../..
    kind: album
    priority: 1
    highlight: Baby Pictures/02.jpg
    images:
      - image: Baby Pictures/01.jpg
        title: With Mom
        caption: With Mom, around 5 months.  I still have those deep worry-frown creases.
      - image: Baby Pictures/02.jpg
        title: Crib No. 1
        caption: Around 10 months.  I was a very cranky baby.
        ...
    ---
    Some pictures of myself as a youngster.
       
The image files themselves are stored in the `content/gallery/` directory.
So given the above album description, the first picture's file path is
`content/gallery/Baby Pictures/01.jpg`, the second picture's file path is
`content/gallery/Baby Pictures/02.jpg`, and so forth.

Now we must modify `Rules` to read the album information and generate the
pages for each picture:

    preprocess do
      items.select { |i| i[:kind] == 'album' }.each do |album|
        nimages = album[:images].length
        # Create a page for each picture in the album.
        (0..nimages-1).each do |n|
          image = album[:images][n]
          if n == 0
            prev_image = nil
          else
            prev_image = album[:images][n - 1]
          end
          if n == nimages - 1
            next_image = nil
          else
            next_image = album[:images][n + 1]
          end
          id = '/pictures/' + image[:image].gsub(/\.\w+$/, '') + '/'
          # Creating a page for a single picture.
          item = Nanoc::Item.new(image[:caption],
                                 { :image => image,
                                   :next  => next_image,
                                   :prev  => prev_image,
                                   :album => album,
                                   :root  => '../../..' },
                                 id)
          items << item
        end
      end
    end

For each image in the album, a new page is generated that has
the identifier `/pictures/IMG/`, where IMG is the path
to the image file, with the file extension removed.
This page will show a medium sized version of the picture,
along with some navigation links for next and previous
pictures, as we will soon see.

Now we need to tell `Rules` how to process these new picture items.
First, some compilation rules that tell nanoc that albums
and pictures use the kramdown filter and have their own
specific layouts:

    compile '/albums/*/' do
      filter :kramdown
      layout 'album'
    end

    compile '/pictures/*' do
      filter :kramdown
      layout 'picture'
    end

We also need to tell `Rules` how to generate thumbnail and medium sized
versions of the images:

    compile '/gallery/*/', rep: :thumbnail do
      filter :thumbnailize, width: 150
    end

    compile '/gallery/*/', rep: :medium do
      filter :thumbnailize, width: 600
    end

Here we're defining thumbnails to be 150 pixels wide, and medium-sized pictures
to be 600 pixels wide.

We also need to modify `Rules` to tell it how to route the
photos themselves and the "picture" pages:

    route '/gallery/*', rep: :thumbnail do
      item.identifier.chop + '-thumbnail.' + item[:extension]
    end

    route '/gallery/*', rep: :medium do
      item.identifier.chop + '-medium.' + item[:extension]
    end

    route '/pictures/*' do
      # Write item with /pictures/album/image/ to /pictures/album/image.html
      item.identifier.chop + '.html'
    end

These rules tell nanoc how to name the two types of resized images and
the picture pages.

The thumbnail filter code lives in the file `lib/filters/lib/filters/thumbnailize.rb`:

    class Thumbnailize < Nanoc::Filter
      identifier :thumbnailize
      type       :binary

      def run(filename, params = {})
        w,h = image_size(filename)
        if w < params[:width]
          system('cp', filename, output_filename)
        else
          if w > h
            size = params[:width].to_s
          else
            size = "x#{params[:width]}"
          end
          # puts "convert -resize #{size} -auto-orient #{filename} #{output_filename}"
          system(
            'convert',
            '-resize',
            size,
            '-auto-orient',
            filename,
            output_filename
          )
        end
      end
    end

This code uses the ImageMagick "convert" program to resize images.  It checks
for the orientation of the image: if it's portrait (height greater than width),
the passed-in width is treated as a limit on the height instead.

Now we can look at the code that displays the gallery: the list of all albums,
along with a thumbnail "highlight" picture for each album.  This code
lives in `content/gallery.erb`:

    ---
    title: Photo Gallery
    root: ..
    ---

    <h1>Photo Gallery</h1>

    <h4>Choose an album:</h4>

    <% @items.select {|i| i[:kind] == 'album'}.sort_by { |i| i[:priority] || 99 }.
              each do |album| %>
      <div class="thumbnail">
        <div class="photo">
          <a href="<%= item[:root] + album.identifier %>">
            <% thumbnail = album[:highlight].gsub(/\./, '-thumbnail.') %>
            <% filename = "output/gallery/#{thumbnail}" %>
            <% w,h = image_size(filename) %>
            <img src="<%= item[:root] %>/gallery/<%= thumbnail %>"
             width="<%= w %>" height="<%= h %>" />
          </a>
        </div>
        <p><%= album[:title] %></p>
      </div>
    <% end %>

This code extracts the information for each album (which is stored in the files `content/albums/*.md`).
Each album has a priority that defines where it appears in the list (lower numbers appear before
higher numbers).

An album has its own layout, which, like the gallery above, displays a list of the pictures
in the album, using clickable thumbnails.  The code lives in `layouts/album.erb`:

    <% render "default" do %>
      <h1><%= item[:title] %></h1>
      <div class="storycontent">
          <%= yield %>
      </div>
      <p><em>Click on a picture to see a larger version.</em></p>
      <% if item[:images] %>
        <% item[:images].each do |image| %>
          <% thumbnail = image[:image].gsub(/\./, '-thumbnail.') %>
          <% filename = "output/gallery/#{thumbnail}" %>
          <% w,h = image_size(filename) %>
          <div class="thumbnail">
            <div class="photo">
              <a href="<%= item[:root] + '/pictures/' +
                           image[:image].gsub(/\.\w+$/, '.html') %>">
                <img src="<%= item[:root] %>/gallery/<%= thumbnail %>"
                 width="<%= w %>" height="<%= h %>" />
              </a>
            </div>
            <p><%= image[:title] %></p>
          </div>
        <% end %>
      <% end %>
      <div class="clearer"></div>
      <p>Back to <a href="<%= item[:root] %>/gallery/">Photo Gallery</a></p>
    <% end %>

In the code above, clicking on a thumbnail takes you to a page for that photo,
a "picture" item.  The layout for pictures lives in `layouts/picture.erb`:

    <% render "default" do %>
      <% filename = "output/gallery/#{item[:image][:image]}" %>
      <% w,h = image_size(filename) %>
      <h1><%= item[:image][:title] %></h1>
      <div class="storycontent">
        <%= yield %>
        <div class="medium">
          <div class="photo">
            <% if w > 600 %>
              <a href="<%= item[:root] %>/gallery/<%= item[:image][:image] %>">
            <% end %>
            <% medium = item[:image][:image].gsub(/\./, '-medium.') %>
            <% filename = "output/gallery/#{medium}" %>
            <% mw,mh = image_size(filename) %>
            <img src="<%= item[:root] %>/gallery/<%= item[:image][:image].gsub(/\./, '-medium.') %>"
             width="<%= mw %>" height="<%= mh %>"/>
            <% if w > 600 %>
              </a>
            <% end %>
          </div>
          <% if w > 600 %>
            <p><em>Click on the picture to see an even larger version.</em></p>
          <% end %>
          <p>
            <% unless item[:prev].nil? %>
                <a href="<%= '../' + item[:prev][:image].gsub(/\.\w+$/, '.html') %>">
                &laquo;&nbsp;Previous&nbsp;</a>
            <% end %>
            <% unless item[:next].nil? %>
                <a href="<%= '../' + item[:next][:image].gsub(/\.\w+$/, '.html') %>">
                &nbsp;Next&nbsp;&raquo;</a>
            <% end %>
          </p>
          <p>Back to <a href="<%= item[:root] + item[:album].identifier %>">
          <%= item[:album][:title] %></a></p>
          <p>Back to <a href="<%= item[:root] %>/gallery/">Photo Gallery</a></p>
        </div>
      </div>
    <% end %>

The picture layout is a bit more complicated than the album layout, because it must handle
navigation links for the next and previous pictures, as well as the album itself and
the gallery.

Throughout the above code, we used an `image_size` function to determine
the width and height of an image.  We define this function in `lib/image.rb`:

    module ImageHelper

      def image_size(filename)
        `identify -format "%wx%h" "#{filename}"`.chomp.split('x').map{|x| x.to_i}
      end

    end

    include ImageHelper

This function uses the ImageMagick "identify" program to output
the dimensions of the image.  This output is parsed and returned as a
(width, height) integer pair.

The snippets of code above got a couple of my photo albums working, and you can
see them [here](../../../gallery/).  But the process of converting all
of my Gallery2 albums to nanoc looked like it was going to take a lot
of typing.  So the next step was to write a script in Ruby (using
ActiveRecord) to read the Gallery2 database and output nanoc album
descriptions in the format I described above.  This script will be the
subject of a subsequent post. 
