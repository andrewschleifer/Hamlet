require 'osx/cocoa'

DEFAULT_RATE = 3.0

class Book < OSX::NSDocument
  ib_action :change_speed
  ib_action :start_stop
  ib_outlet :button, :slider, :word_view
  kvc_accessor :index, :playing, :rate, :timer, :words

  def awakeFromNib
    @index = 0
    @playing = false
    @rate = DEFAULT_RATE
    @timer = nil
    @words ||= File.read(File.join(
      OSX::NSBundle.mainBundle.resourcePath.fileSystemRepresentation,
      'Hamlet.txt')).scan(/\S+/)

    @button.setTitle ">"
    @slider.minValue = -5
    @slider.maxValue = 10
    @slider.numberOfTickMarks = @slider.maxValue - @slider.minValue + 1
    @slider.floatValue = @rate
    @word_view.stringValue = @words[@index]
  end

  def readFromURL_ofType_error(url, type, errorPtr)
    @words = File.read(url.path).scan(/\S+/)
    return true
  end

  def windowNibName
    return "book"
  end

  def start_stop
    if @playing
      @timer.invalidate
      @button.setTitle ">"
    else
      start_a_timer
  		@button.setTitle "||"
    end
    @playing = ! @playing
  end

  def change_speed
    @rate = @slider.floatValue
    start_a_timer
  end

  def advance
    if @playing
      @index += @rate / @rate.abs
      @word_view.stringValue = @words[@index]
    end
  end

  def start_a_timer
    if @timer
      @timer.invalidate
    end
    @timer = OSX::NSTimer.objc_send(
      :scheduledTimerWithTimeInterval, 1 / @rate.abs,
      :target, self,
      :selector, 'advance',
      :userInfo, nil,
      :repeats, true)
  end
end
