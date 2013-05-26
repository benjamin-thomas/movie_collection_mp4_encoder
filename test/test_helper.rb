require 'minitest/autorun'
require 'minitest/pride'

require 'tempfile'

class Sandbox

  def initialize
    setup_sandbox
    yield(self)
    destroy_sandbox
  end

  def create_fake_movie(fake_movie)
    @fake_movie = fake_movie
    create_movie_dir
    create_movie_files
  end

  def root
    @sandbox_root
  end

  private

  def create_movie_dir
    Dir.mkdir "#{@sandbox_root}/#{@fake_movie.name}"
  end

  def create_movie_files
    @fake_movie.relative_paths.each do |fm_relative_path|
      FileUtils.touch "#{@sandbox_root}/#{fm_relative_path}"
    end
  end

  def setup_sandbox
    @sandbox_root = Dir.mktmpdir "LibraryEncodingSandbox"
  end

  def destroy_sandbox
    FileUtils.rm_r @sandbox_root
  end

end


class FakeMovie

  attr_reader :name

  def initialize(name, extensions: [], extra_files: [])
    @name = name
    @extensions = extensions
    @extra_files = extra_files
  end

  def relative_paths
    movie_related_files + extra_files
  end

  private

  def movie_related_files
    @extensions.map do |ext|
      "#{@name}/#{@name}.#{ext}"
    end
  end

  def extra_files
    @extra_files.map do |filename|
      "#{@name}/#{filename}"
    end
  end

end
