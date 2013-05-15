#!/usr/bin/env ruby

require 'fileutils'
require 'colored'

MOVIES_ROOT = "~xbmc/videos/movies"


############################
#  EncodingPresets module  #
############################

module EncodingPresets
  IPHONE4 = %w( --optimize -e x264 -q 20.0 -r 29.97 --pfr  -a 1 -E faac -B 160 -6 dpl2 -R Auto -D 0.0 -f mp4 -4 -X 960 --loose-anamorphic -m )
  IPAD = %w( --optimize -e x264 -q 20.0 -r 29.97 --pfr  -a 1 -E faac -B 160 -6 dpl2 -R Auto -D 0.0 -f mp4 -4 -X 1024 --loose-anamorphic -m )
  HIGH_PROFILE = %w( --optimize  -e x264 -q 20.0 -a 1,1 -E faac,copy:ac3 -B 160,160 -6 dpl2,auto -R Auto,Auto -D 0.0,0.0 -f mp4 --detelecine --decomb --loose-anamorphic -m -x b-adapt=2:rc-lookahead=50 )
end

#######################
#  MovieFinder class  #
#######################

class MovieFinder
  MOVIES_DIR = File.expand_path MOVIES_ROOT

  def self.next_candidate
    find_all.each do |movie_path|
      movie = Movie.new(movie_path)
      unless movie.has_been_encoded_to_mp4?
        return movie
      end
    end
    nil
  end

  private

  def self.find_all
    Dir.glob(MOVIES_DIR + "/**/*.mkv")
  end
end


#################
#  Movie class  #
#################

class Movie
  def initialize(movie_path)
    @mkv_path = movie_path
    @srt_path = movie_path[0..-4] + "srt"
    @mp4_path = @mkv_path[0..-5] + "-tablet.mp4"
    @wip_path = @mkv_path[0..-5] + "-tablet.mp4.wip"
  end

  def has_been_encoded_to_mp4?
    File.exists?(@mp4_path)
  end

  def has_srt?
    File.exists?(@srt_path)
  end

  def encode_for_tablet!
    # The splat operator converts an Array to String
    system "HandBrakeCLI", *encoding_params
    # TODO: catch control c and don't move
    FileUtils.mv @wip_path, @mp4_path
  end

  private

  def encoding_params
    #TODO See how I handle this
    #raise "missing srt file".red unless has_srt?

    # %W allows interpolation whereas %w does not (See ruby tapas #5)
    input_output_opt = %W( -i #{@mkv_path} -o #{@wip_path} )
    encoding_opt = EncodingPresets::IPAD
    if has_srt?
      srt_opt = %W( --srt-file #{@srt_path} )
      all_opt = input_output_opt + encoding_opt + srt_opt
    else
      all_opt = input_output_opt + encoding_opt
    end
    all_opt
  end

end


##################
#  Script start  #
##################

movie = MovieFinder.next_candidate
#movie.encode_for_tablet!
require 'pry' ; binding.pry
