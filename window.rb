require 'osx/cocoa'

class HWindow < OSX::NSWindow
  ib_outlet :book

  def keyDown(event)
    case event.characters.characterAtIndex(0)
      when 32 then @book.startStop # space
      when OSX::NSRightArrowFunctionKey then @book.move(1)
      when OSX::NSLeftArrowFunctionKey then @book.move(-1)
    end
  end
end
