#!/usr/bin/env ruby

require_relative '../test_helper'
require_relative '../../lib/movie'

describe Movie do

  it "can tell if it has subtitles" do
    SandboxEnvironment.new do |sandbox|
      sandbox.create_bogus_movie("Batman", extensions: [:mkv, :srt])

      movie = Movie.new("#{sandbox.root}/Batman")
      assert movie.has_subtitles?
    end
  end

end
