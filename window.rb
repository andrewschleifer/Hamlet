require 'osx/cocoa'

class Window < OSX::NSWindow
  ib_outlet :book

  def keyDown(event)
    case event.characters.characterAtIndex(0)
      when 32 then @book.start_stop # space
    end
  end
end
