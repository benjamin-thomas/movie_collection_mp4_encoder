#!/usr/bin/env ruby

require 'minitest/autorun'
require 'minitest/pride'

require_relative '../../lib/movie'

describe Movie do

  it "can tell if it instanciated a valid movie" do
    assert Movie.new("/bogus/movie.mkv").valid?
    assert Movie.new("/bogus/movie.MKV").valid?
    assert Movie.new("/bogus/movie.avi").valid?
    refute Movie.new("/bogus/movie.srt").valid?
  end

  it "can tell if it has subtitles" do
    assert Movie.new("/bogus/movie").respond_to?(:has_subtitles?)
  end

end
