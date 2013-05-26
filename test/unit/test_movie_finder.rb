#!/usr/bin/env ruby

require_relative '../test_helper'
require_relative '../../lib/movie_finder'

class TestMovieFinder < MiniTest::Unit::TestCase

  def setup
  end

  def test_it_has_somewhere_to_look
    assert MovieFinder.respond_to? :movies_root
  end

  def test_it_raises_an_error_if_cant_look_in_a_directory
    skip "don't know how to test this"
    #MovieFinder.stub(:movies_root, "/bogus/filepath/") do
      #assert_raises(RuntimeError) do
        #MovieFinder.movies_root
      #end
    #end
  end

  def test_it_can_detect_valid_movie_paths
    assert MovieFinder.is_valid_movie_path?("/bogus/movie.mkv")
    assert MovieFinder.is_valid_movie_path?("/bogus/movie.avi")

    refute MovieFinder.is_valid_movie_path?("/bogus/movie-sample.srt")
    refute MovieFinder.is_valid_movie_path?("/bogus/movie-SAMPLE.mkv")
    refute MovieFinder.is_valid_movie_path?("/bogus/movie-SAMPLE.mkv")
    refute MovieFinder.is_valid_movie_path?("/bogus/sample-movie.mkv")
    refute MovieFinder.is_valid_movie_path?("/bogus/movie.srt")
  end


  def test_it_finds_all_movies
    Sandbox.new do |sandbox|
      MovieFinder.stub(:movies_root, sandbox.root) do

        hugo = FakeMovie.new("Hugo", extensions: [:mkv, :srt], extra_files: ["subsearch-results.txt"])
        up = FakeMovie.new("Up", extensions: [:mkv, :srt])
        battleship = FakeMovie.new("Battleship", extra_files: ["Battleship, the movie.mkv"])
        bambi = FakeMovie.new("Bambi", extensions: [:avi])

        fake_movies = [hugo, up, battleship, bambi]

        fake_movies.each do |fm|
          sandbox.create_fake_movie(fm)
        end

        assert_equal 4, MovieFinder.all_movies.count
      end
    end
  end

  def test_it_doesnt_count_samples_as_a_movie
    Sandbox.new do |sandbox|
      MovieFinder.stub(:movies_root, sandbox.root) do

        batman = FakeMovie.new("Batman", extensions: [:mkv, :srt],
                                         extra_files: ["Batman-sample.mkv", "Batman SAMPLE.mkv"])

        sandbox.create_fake_movie(batman)

        assert_equal 1, MovieFinder.all_movies.count
      end
    end
  end

end
