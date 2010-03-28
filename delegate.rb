require 'osx/cocoa'

class HDelegate < OSX::NSObject 
  ib_action :show_preferences

  def show_preferences(sender)
    unless @wc 
      @wc = OSX::NSWindowController.alloc.initWithWindowNibName("preferences") 
    end 
    @wc.showWindow(self) 
    @wc.window.makeKeyWindow
  end 

end 
