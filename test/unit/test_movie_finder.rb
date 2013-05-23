#!/usr/bin/env ruby

require_relative '../test_helper'
require_relative '../../lib/movie_finder'

class TestMovieFinder < MiniTest::Unit::TestCase

  def setup
  end

  def test_it_has_somewhere_to_look
    SandboxEnvironment.new do |sandbox|
      MovieFinder.stub(:movies_root, sandbox.root) do
        assert File.directory?(MovieFinder.movies_root)
      end
    end
  end

  def test_it_can_detect_valid_movies_via_path
    assert MovieFinder.is_valid_movie?("/bogus/movie.mkv")
    assert MovieFinder.is_valid_movie?("/bogus/movie.avi")
    refute MovieFinder.is_valid_movie?("/bogus/movie-sample.srt")
    refute MovieFinder.is_valid_movie?("/bogus/movie-SAMPLE.mkv")
    refute MovieFinder.is_valid_movie?("/bogus/movie-SAMPLE.mkv")
    refute MovieFinder.is_valid_movie?("/bogus/sample-movie.mkv")
    refute MovieFinder.is_valid_movie?("/bogus/movie.srt")
  end


  def test_it_finds_all_movies
    SandboxEnvironment.new do |sandbox|
      MovieFinder.stub(:movies_root, sandbox.root) do
        sandbox.create_bogus_movie("Hugo", extensions: [:mkv, :srt])
        sandbox.create_bogus_movie("Up", extensions: [:mkv, :srt])
        sandbox.create_bogus_movie("Battleship", extra_files: ["Battleship, the movie.mkv"])
        sandbox.create_bogus_movie("Bambi", extensions: [:avi])

        assert_equal 4, MovieFinder.all_movies.count
      end
    end
  end

  def test_it_doesnt_count_samples_as_a_movie
    SandboxEnvironment.new do |sandbox|
      MovieFinder.stub(:movies_root, sandbox.root) do
        sandbox.create_bogus_movie( "Batman", extensions: [:mkv, :srt], extra_files: ["Batman-sample.mkv", "Batman SAMPLE.mkv"])

        assert_equal 1, MovieFinder.all_movies.count
      end
    end
  end

end
