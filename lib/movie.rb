require_relative 'encoding_presets'

class Movie
  attr_reader :mkv_path
  alias :path :mkv_path

  def initialize(movie_path)
    @filepath = movie_path
    @filename = File.basename(movie_path)
    @mkv_path = movie_path
    @srt_path = movie_path[0..-4] + "srt"
    @mp4_path = @mkv_path[0..-5] + "-tablet.mp4"
    @wip_path = @mkv_path[0..-5] + "-tablet.mp4.wip"
  end

  def has_been_encoded_to_mp4?
    File.exists?(@mp4_path)
  end

  def has_subtitles?
    File.exists?(@srt_path)
  end

  def encode_for_tablet!
    # The splat operator converts an Array to String
    # TODO: delegate to object Encoder.encode(self)
    system "echo HandBrakeCLI", *encoding_params
    # TODO: catch control c and don't move
    #FileUtils.mv @wip_path, @mp4_path
  end

  private

  def encoding_params
    #TODO See how I handle this
    #raise "missing srt file".red unless has_subtitles?

    # %W allows interpolation whereas %w does not (See ruby tapas #5)
    input_output_opt = %W( -i #{@mkv_path} -o #{@wip_path} )
    encoding_opt = EncodingPresets::IPAD
    if has_subtitles?
      # TODO: handle different languages (*en.srt, *fr.srt, etc.)
      srt_opt = %W( --srt-file #{@srt_path} --srt-lang en )
      all_opt = input_output_opt + encoding_opt + srt_opt
    else
      all_opt = input_output_opt + encoding_opt
    end
    all_opt
  end

end
