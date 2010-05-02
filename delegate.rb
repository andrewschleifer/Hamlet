require 'osx/cocoa'

class HDelegate < OSX::NSObject
  ib_action :showPreferences
  ib_action :startFrontDocument
  ib_action :stopFrontDocument
  ib_action :nextWordFrontDocument
  ib_action :previousWordFrontDocument
  ib_outlet :frontDocument

  def showPreferences(sender)
    unless @wc
      @wc = OSX::NSWindowController.alloc.initWithWindowNibName("preferences")
    end
    @wc.showWindow(self)
    @wc.window.makeKeyWindow
  end

  def frontDocument
    OSX::NSApplication.sharedApplication.keyWindow
  end

  def startFrontDocument
    OSX::NSApplication.sharedApplication.keyWindow.book.startStop
  end

  def stopFrontDocument
    OSX::NSApplication.sharedApplication.keyWindow.book.startStop
  end

  def nextWordFrontDocument
    OSX::NSApplication.sharedApplication.keyWindow.book.move(1)
  end

  def previousWordFrontDocument
    OSX::NSApplication.sharedApplication.keyWindow.book.move(-1)
  end

  def validateMenuItem(item)
    return false unless frontDocument.respond_to? 'book'
    case item.action
    when 'startFrontDocument:'
      !frontDocument.book.playing
    when 'stopFrontDocument:'
      frontDocument.book.playing
    when 'nextWordFrontDocument:'
    when 'previousWordFrontDocument:'
    else
      puts "Should never get here!"
      false
    end
  end

end
