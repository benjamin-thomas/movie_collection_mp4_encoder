#!/usr/bin/env ruby

require_relative '../minitest_helper'
require_relative '../../lib/movie_finder'

require 'tempfile'

class TestMovieFinder < MiniTest::Unit::TestCase

  def setup
    #require 'pry' ; binding.pry
  end

  def enter_sandbox
    Dir.mktmpdir "TestMovieFinder" do |tmp_dir|
      @sandbox_dir = tmp_dir

      MovieFinder.stub(:movies_root, @sandbox_dir) do
        yield
      end
    end
  end

  def create_bogus_movie(movie_name, *movie_files)
    movie_dir = "#{@sandbox_dir}/#{movie_name}"
    Dir.mkdir movie_dir
    movie_files.each do |movie_file|
      FileUtils.touch "#{movie_dir}/#{movie_file}"
    end
  end

  def test_it_has_somewhere_to_look
    assert File.directory?(MovieFinder.movies_root)
  end

  def test_it_finds_all_movies
    enter_sandbox do
      create_bogus_movie("Hugo", "Hugo.mkv", "Hugo.srt")
      create_bogus_movie("Up", "Up.mkv", "Up.srt")
      create_bogus_movie("Battleship", "Battleship, the movie.mkv")
      create_bogus_movie("Bambi", "Bambi.avi")

      assert_equal 4, MovieFinder.all_movies.count
    end
  end

  def test_it_doesnt_count_samples_as_a_movie
    enter_sandbox do
      create_bogus_movie( "Batman", "Batman.mkv", "Batman-sample.mkv", "Batman SAMPLE.mkv", "Batman.srt")

      assert_equal 1, MovieFinder.all_movies.count
    end
  end

end
