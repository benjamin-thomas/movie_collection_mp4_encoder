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

        FakeMovie.new.create_in(sandbox.root) do |fm|
          fm.name = "Hugo"
          fm.extensions = [:mkv, :srt]
        end

        FakeMovie.new.create_in(sandbox.root) do |fm|
          fm.name = "Up"
          fm.extensions = [:mkv, :srt]
        end

        FakeMovie.new.create_in(sandbox.root) do |fm|
          fm.name = "Battleship"
          fm.extra_files = ["Battleship, the movie.mkv"]
        end

        FakeMovie.new.create_in(sandbox.root) do |fm|
          fm.name = "Bambi"
          fm.extensions = [:avi]
        end

        assert_equal 4, MovieFinder.all_movies.count
      end
    end
  end

  def test_it_doesnt_count_samples_as_a_movie
    SandboxEnvironment.new do |sandbox|
      MovieFinder.stub(:movies_root, sandbox.root) do

        FakeMovie.new.create_in(sandbox.root) do |fm|
          fm.name = "Batman"
          fm.extensions = [:mkv, :srt]
          fm.extra_files = ["Batman-sample.mkv", "Batman SAMPLE.mkv"]
        end

        assert_equal 1, MovieFinder.all_movies.count
      end
    end
  end

end
