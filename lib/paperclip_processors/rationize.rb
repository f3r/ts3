module Paperclip
  class Rationize < Processor
    # Plan is to crop to 3:2 ratio first then watermark processor would resize and watermark
    attr_accessor :current_geometry, :target_geometry, :format
    
    def initialize(file, options = {}, attachment = nil)
      super
      geometry            = options[:geometry]
      @file               = file
      @target_geometry    = Geometry.parse(geometry)
      @current_geometry   = Geometry.from_file(@file)

      @format             = options[:format]
      @current_format     = File.extname(@file.path)
      @basename           = File.basename(@file.path, @current_format)
    end

    def make
      dst = Tempfile.new([@basename, @format].compact.join("."))
      dst.binmode

      puts @current_geometry.height
      puts @current_geometry.width

      if @current_geometry.vertical?
        new_height = @current_geometry.height
        new_width = (@current_geometry.width / @current_geometry.height) * new_height
        puts "New width : #{new_width.inspect}"
        puts "New height : #{new_height.inspect}"
      elsif @current_geometry.horizontal?
        new_width = @current_geometry.width
        new_height = (@current_geometry.height / @current_geometry.width) * new_width

        puts "New width : #{new_width.inspect}"
        puts "New height : #{new_height.inspect}"

      end

      @file
    end
  end
end
