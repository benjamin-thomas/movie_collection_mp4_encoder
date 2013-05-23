require 'minitest/autorun'
require 'minitest/pride'

require 'tempfile'

class MovieFinder
  def self.movies_root
    "/will/be/stubbed/with/sandbox/dir"
  end
end

class Sandbox

  class << self

    def enter
      Dir.mktmpdir "TestMovieFinder" do |sandbox_dir|
        @@sandbox_dir = sandbox_dir
        MovieFinder.stub(:movies_root, sandbox_dir) do
          yield
        end
      end
    end

    def create_bogus_movie(movie_name, *movie_files)
      movie_dir = "#{@@sandbox_dir}/#{movie_name}"
      Dir.mkdir movie_dir
      movie_files.each do |movie_file|
        FileUtils.touch "#{movie_dir}/#{movie_file}"
      end
    end

  end

end

class SandboxEnvironment

  # Use like this
  # SandboxEnvironment.new do |sandbox|
  #   sandbox.create_bogus_movie("Batman", extensions: [:mkv, :mp4])
  # end
  attr_reader :root

  def initialize
    #MovieFinder.stub(:movies_root, @root) do
    setup_sandbox
    yield(self)
    destroy_sandbox
    #end
  end

  def create_bogus_movie(movie_name, extensions: [], extra_files: [])
    movie_dir = "#{@root}/#{movie_name}"

    Dir.mkdir movie_dir

    extensions.each do |ext|
      FileUtils.touch "#{movie_dir}/#{movie_name}.#{ext}"
    end

    extra_files.each do |file|
      FileUtils.touch "#{movie_dir}/#{file}"
    end
  end

  private

  def setup_sandbox
    @root = Dir.mktmpdir "LibraryEncodingSandbox"
  end

  def destroy_sandbox
    FileUtils.rm_r @root
  end

end
