require 'osx/cocoa'

class HWindow < OSX::NSWindow
  kvc_accessor :book

  def initialize
    @book = nil
  end

  def keyDown(event)
    case event.characters.characterAtIndex(0)
      when 32 then @book.startStop # space
      when OSX::NSRightArrowFunctionKey then @book.move(1)
      when OSX::NSLeftArrowFunctionKey then @book.move(-1)
    end
  end
end
