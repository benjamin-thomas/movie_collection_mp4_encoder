module AppConfig
  #MOVIES_ROOT = "~xbmc/videos/movies"
  def self.movies_root
    "~xbmc/videos/movies"
  end
end

#require 'ostruct'
#
#AppConfig = OpenStruct.new(
#  movies_root: "~xbmc/videos/movies"
#)

#class AppConfig
#  class <<
#    def movies_root
#      "~xbmc/videos/movies"
#    end
#  end
#end
