require 'osx/cocoa'

class HWindow < OSX::NSWindow
  ib_outlet :book
  kvc_accessor :book

  def initialize
    @book = nil
  end

  def keyDown(event)
    @book.keyDown(event)
  end

end
