require 'minitest/autorun'
require 'minitest/pride'

require 'tempfile'

class SandboxEnvironment

  # SandboxEnvironment.new do |sandbox|
  #   sandbox.create_bogus_movie("Batman", extensions: [:mkv, :mp4])
  # end
  attr_reader :root

  def initialize
    setup_sandbox
    yield(self)
    destroy_sandbox
  end

  private

  def setup_sandbox
    @root = Dir.mktmpdir "LibraryEncodingSandbox"
  end

  def destroy_sandbox
    FileUtils.rm_r @root
  end

end


class FakeMovie
  attr_accessor :name, :extensions, :extra_files

  def create_in(temp_folder)
    @temp_folder = temp_folder
    yield(self)
    create_fake_files
  end


  private

  def create_fake_files
    create_movie_dir
    create_movie_extensions
    create_movie_extra_files
  end

  def create_movie_dir
    Dir.mkdir "#{@temp_folder}/#{@name}"
  end

  def create_movie_extensions
    return if @extensions.nil?

    @extensions.each do |ext|
      FileUtils.touch "#{@temp_folder}/#{@name}/#{@name}.#{ext}"
    end
  end

  def create_movie_extra_files
    return if @extra_files.nil?

    @extra_files.each do |file|
      FileUtils.touch "#{@temp_folder}/#{@name}/#{file}"
    end
  end

end
