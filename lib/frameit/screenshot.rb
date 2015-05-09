module Frameit
  # Represents one screenshot
  class Screenshot
    attr_accessor :path # path to the screenshot
    attr_accessor :size # size in px array of 2 elements: height and width
    attr_accessor :screen_size # deliver screen size type, is unique per device type, used in device_name
    attr_accessor :color # the color to use for the frame

    # path: Path to screenshot
    # color: Color to use for the frame
    def initialize(path, color)
      raise "Couldn't find file at path '#{path}'".red unless File.exists?path
      @color = color
      @path = path
      @size = FastImage.size(path)
      @screen_size = Deliver::AppScreenshot.calculate_screen_size(path) 
    end

    # Device name for a given screen size. Used to use the correct template
    def device_name
      sizes = Deliver::AppScreenshot::ScreenSize
      case @screen_size
        when sizes::IOS_55
          return 'iPhone_6_Plus'
        when sizes::IOS_47
          return 'iPhone_6'
        when sizes::IOS_40
          return 'iPhone_5s'
        when sizes::IOS_35
          return 'iPhone_4'
        when sizes::IOS_IPAD
          return 'iPad_mini'
      end
    end

    # The name of the orientation of a screenshot. Used to find the correct template
    def orientation_name
      return Orientation::PORTRAIT if size[0] < size[1]
      return Orientation::LANDSCAPE
    end

    def to_s
      self.path
    end

    # Add the device frame, this will also call the method that adds the background + title
    def frame!
      Editor.new.frame!(self)
    end
  end
end