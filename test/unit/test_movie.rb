#!/usr/bin/env ruby

require_relative '../test_helper'
require_relative '../../lib/movie'

describe Movie do

  it "can tell if it has subtitles" do
    SandboxEnvironment.new do |sandbox|

      FakeMovie.new.create_in(sandbox.root) do |fm|
        fm.name = "Batman"
        extensions = [:mkv, :srt]
      end

      movie = Movie.new("#{sandbox.root}/Batman")
      assert movie.has_subtitles?
    end
  end

end
