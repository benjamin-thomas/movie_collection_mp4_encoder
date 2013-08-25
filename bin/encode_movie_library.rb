#!/usr/bin/env ruby

require 'fileutils'
require 'colored'
require_relative '../lib/movie_finder'

MovieFinder.candidates_for_encoding do |movie|

  priority_mode = false
  tmp_priority_file = "/tmp/encode_this_movie"

  if File.exist?(tmp_priority_file)
    priority_mode = true
    priority_name = File.readlines(tmp_priority_file)[0].chomp
    puts "Priority mode: on"

    if movie.path.include?(priority_name)
      puts "Honoring priority".blue
      puts "Chosen candidate: #{File.basename(movie.path)}"
      File.unlink(tmp_priority_file)
    else
      puts "(skipping #{File.basename(movie.path)})"
      next
    end
  end

  puts "Encoding #{movie.path}".blue
  sleep 5
  movie.encode_for_tablet!
end

puts <<-EOF.green
************************************
*  All movies have been encoded!!  *
************************************
EOF

