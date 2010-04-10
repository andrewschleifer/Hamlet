require 'osx/cocoa'

class HBook < OSX::NSDocument
  ib_action :changeSpeed
  ib_action :startStop
  ib_outlet :button, :slider, :wordView
  kvc_accessor :index, :playing, :rate, :timer, :words

  def initialize
    @index = 0
    @playing = false
    @rate = 3.0
    @timer = nil
    @words = []
  end

  def awakeFromNib
    @slider.floatValue = @rate
    @wordView.stringValue = @words[@index]
  end

  def readFromURL_ofType_error(url, type, errorPtr)
    begin
      @words = File.read(url.path).scan(/\S+/)
      true
    rescue SystemCallError => e
  	  errorPtr.assign(
    	  OSX::NSError.errorWithDomain_code_userInfo("NSErrorDomain",
          case e.errno
            when 1 # Errno::EPERM
              OSX::NSFileReadNoPermissionError
    	      when 2 # Errno::ENOENT
    	        OSX::NSFileNoSuchFileError
            when 27 # Errno::EFBIG
              OSX::NSFileReadTooLargeError
            when 36 # Errno::ENAMETOOLONG
              OSX::NSFileReadInvalidFileNameError
            when 37 # Errno::ENOLCK
              OSX::NSFileLockingError
            else
             OSX::NSFileReadUnknownError 
          end, nil))
      false
    end
  end

  def windowNibName
    "book"
  end

  def startStop
    @playing = ! @playing

    if @playing
      @button.image = OSX::NSImage.imageNamed("pause.png")
      start_the_timer
    else
      @button.image = OSX::NSImage.imageNamed("play.png")
      @timer.invalidate
    end
  end

  def changeSpeed
    @rate = @slider.floatValue
    if @playing
      @timer.invalidate
      start_the_timer
    end
  end

  def advance
    @index += @rate / @rate.abs if @index < @words.length - 1
    @wordView.stringValue = @words[@index]
    if @playing && @index == @words.length - 1
      self.startStop
    end
  end

  def retreat
    @index -= @rate / @rate.abs if @index > 0
    @wordView.stringValue = @words[@index]
  end

  def start_the_timer
    @timer = OSX::NSTimer.objc_send(
      :scheduledTimerWithTimeInterval, 1 / @rate.abs,
      :target, self,
      :selector, 'advance',
      :userInfo, nil,
      :repeats, true)
  end

end
