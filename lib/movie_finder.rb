require_relative 'movie'
require_relative 'app_config'

class MovieFinder
  # This construct allows to define private class methods without having to
  # declare them with 'private_class_method'
  class << self

    def candidates_for_encoding
      # Makes method chaining possible
      return to_enum(__callee__) unless block_given?

      # select won't return all_movies array at the end of block like each
      all_movies.select do |movie_path|
        movie = Movie.new(movie_path)
        yield movie unless movie.has_been_encoded_to_mp4?
      end
    end

    #private

    def all_movies
      movies_dir = File.expand_path AppConfig.movies_root

      #TODO: filter *sample.mkv files"
      Dir.glob(movies_dir + "/**/*.mkv")
    end

  end
end
