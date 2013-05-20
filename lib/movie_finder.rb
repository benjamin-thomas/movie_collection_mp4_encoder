require_relative 'movie'

class MovieFinder
  MOVIES_ROOT = "~xbmc/videos/movies"
  MOVIES_DIR = File.expand_path MOVIES_ROOT

  def self.next_candidate
    # Use with a while loop
    all_movies.each do |movie_path|
      movie = Movie.new(movie_path)
      unless movie.has_been_encoded_to_mp4?
        return movie
      end
    end
    nil
  end

  def self.candidates_for_encoding
    # Use with a block
    all_movies.each do |movie_path|
      movie = Movie.new(movie_path)
      yield movie unless movie.has_been_encoded_to_mp4?
    end
    nil
  end

  def self.all_candidates
    # Use with #each
    all_movies.map do |movie_path|
      Movie.new(movie_path)
    end.select do |movie|
      !movie.has_been_encoded_to_mp4?
    end
  end

  private

  def self.all_movies
    #TODO: filter *sample.mkv files"
    Dir.glob(MOVIES_DIR + "/**/*.mkv")
  end
end
