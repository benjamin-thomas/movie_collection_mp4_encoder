#!/usr/bin/env ruby

require 'fileutils'
require 'colored'
require_relative '../lib/movie_finder'

MovieFinder.candidates_for_encoding do |movie|
  #require 'pry' ; binding.pry ; exit
  puts "Encoding #{movie.path}".blue
  sleep 5
  movie.encode_for_tablet!
end

puts <<-EOF.green
************************************
*  All movies have been encoded!!  *
************************************
EOF

