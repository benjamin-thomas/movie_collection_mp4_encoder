#!/usr/bin/env ruby

require_relative '../test_helper'
require_relative '../../lib/movie'

describe Movie do

  it "can tell if it has subtitles" do
    Sandbox.new do |sandbox|

      fake_movie = FakeMovie.new("Batman", extensions: [:mkv, :srt])
      sandbox.create_fake_movie(fake_movie)

      movie = Movie.new("#{sandbox.root}/Batman/Batman.mkv")
      require 'pry' ; binding.pry
      assert movie.has_subtitles?
    end
  end

end
