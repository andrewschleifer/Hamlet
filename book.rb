require 'osx/cocoa'

DEFAULT_RATE = 3.0

class Book < OSX::NSDocument
  ib_action :change_speed
  ib_action :start_stop
  ib_outlet :button, :slider, :word_view
  kvc_accessor :index, :playing, :rate, :timer, :words

  def windowControllerDidLoadNib(controller)
    super_windowControllerDidLoadNib(controller)
    @index = 0
    @playing = false
    @rate = DEFAULT_RATE
    @timer = nil
    @words = File.read(File.join(
      OSX::NSBundle.mainBundle.resourcePath.fileSystemRepresentation,
      'Hamlet.txt')).scan(/\S+/)

    @button.setTitle ">"
    @slider.minValue = -5
    @slider.maxValue = 10
    @slider.numberOfTickMarks = @slider.maxValue - @slider.minValue + 1
    @slider.floatValue = @rate
    @word_view.stringValue = @words[@index]
  end

  def start_stop
    if @playing
      @timer.invalidate
      @button.setTitle ">"
    else
      @timer = OSX::NSTimer.objc_send(
        :scheduledTimerWithTimeInterval, 1 / @rate.abs,
        :target, self,
        :selector, 'advance',
        :userInfo, nil,
        :repeats, true)
  		@button.setTitle "||"
    end
    @playing = ! @playing
  end

  def change_speed
    @rate = @slider.floatValue
    start_stop; start_stop # FIXME this is a hack to restart the timer
  end

  def advance
    if @playing
      @index += @rate / @rate.abs
      @word_view.stringValue = @words[@index]
      @word_view.needsDisplay = true # FIXME this is a hack to make the view redraw
    end
  end

  def loadDataRepresentation_ofType(data, type)
    # TODO actually read the file
    #     [self setPlaying:NO];
    # 
    # NSMutableArray * newWords = [NSMutableArray array];
    # NSString *fileContents = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    # NSScanner *fileScanner = [NSScanner scannerWithString:fileContents];
    # [fileContents release];
    # NSCharacterSet *acceptableCharacters = [[NSCharacterSet whitespaceAndNewlineCharacterSet] invertedSet];
    # while ([fileScanner isAtEnd] == NO)
    # {
    #   NSString * nextWord;
    #   [fileScanner scanCharactersFromSet:acceptableCharacters intoString:&nextWord];
    #   [newWords addObject:[nextWord copy]];
    # }
    # [self setWords:newWords];
    # 
    # [self setRate:0.3];
    # 
    #       return YES;
    false
  end

  def windowNibName
    return "book"
  end

  def windowShouldClose
    @timer.invalidate
  end
end
