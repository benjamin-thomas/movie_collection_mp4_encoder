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
      AppConfig.stub(:movies_root, tmp_dir) do
        yield(tmp_dir)
      end
    end
  end

  def create_bogus_movie(movie_dir, *movie_files)
    Dir.mkdir movie_dir
    movie_files.each do |movie_file|
      FileUtils.touch "#{movie_dir}/#{movie_file}"
    end
  end

  def test_it_finds_all_movies
    skip "refactoring"
    enter_sandbox do |dir|
      Dir.mkdir "#{dir}/movie1"
      FileUtils.touch "#{dir}/movie1/movie.mkv"
      FileUtils.touch "#{dir}/movie1/movie.srt"

      assert_equal 1, MovieFinder.all_movies.size
    end
  end

  def test_it_doesnt_return_samples
    enter_sandbox do |sandbox_dir|
      create_bogus_movie(
        "#{sandbox_dir}/movie1",
        "movie1.mkv",
        "movie1-sample.mkv",
        "movie1.srt"
      )

      assert_equal 1, MovieFinder.all_movies.size
    end
  end

end
