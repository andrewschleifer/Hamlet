require 'osx/cocoa'

class HBook < OSX::NSDocument
  ib_action :change_speed
  ib_action :start_stop
  ib_outlet :button, :slider, :word_view
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
    @word_view.stringValue = @words[@index]
  end

  def readFromURL_ofType_error(url, type, errorPtr)
    begin
      @words = File.read(url.path).scan(/\S+/)
      return true
    rescue SystemCallError
    	errorPtr.assign(
    	  OSX::NSError.errorWithDomain_code_userInfo("NSErrorDomain",
    	    OSX::NSFileReadUnknownError, nil))
      return false
    end
  end

  def windowNibName
    return "book"
  end

  def start_stop
    @playing = ! @playing

    if @playing
      @button.image = OSX::NSImage.imageNamed("pause.png")
      start_the_timer
    else
      @button.image = OSX::NSImage.imageNamed("play.png")
      @timer.invalidate
    end
  end

  def change_speed
    @rate = @slider.floatValue
    if @playing
      @timer.invalidate
      start_the_timer
    end
  end

  def advance
    @index += @rate / @rate.abs if @index < @words.length - 1
    @word_view.stringValue = @words[@index]
    @word_view.needsDisplay = true
  end

  def retreat
    @index -= @rate / @rate.abs if @index > 0
    @word_view.stringValue = @words[@index]
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
