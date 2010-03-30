require 'osx/cocoa'

class HWindow < OSX::NSWindow
  ib_outlet :book

  def keyDown(event)
    case event.characters.characterAtIndex(0)
      when 32 then @book.start_stop # space
      when OSX::NSRightArrowFunctionKey then @book.advance
      when OSX::NSLeftArrowFunctionKey then @book.retreat
    end
  end
end
