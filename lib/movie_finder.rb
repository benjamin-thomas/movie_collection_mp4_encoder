require_relative 'movie'

class MovieFinder
  MOVIES_ROOT = "~xbmc/videos/movies"
  MOVIES_DIR = File.expand_path MOVIES_ROOT

  def self.next_candidate
    find_all.each do |movie_path|
      movie = Movie.new(movie_path)
      # try with if movie.has_encoded_version; next --- and then return the movie object
      unless movie.has_been_encoded_to_mp4?
        return movie
      end
    end
    nil
  end

  private

  def self.find_all
    Dir.glob(MOVIES_DIR + "/**/*.mkv")
  end
end
