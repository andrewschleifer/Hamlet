require 'osx/cocoa'

class HView < OSX::NSView
  attr_reader :stringValue
  ib_outlet :controller
  kvc_accessor :fontName, :foregroundColor, :backgroundColor

  def initialize
    OSX::NSNotificationCenter.defaultCenter.objc_send(
      :addObserver, self,
      :selector, 'preferencesChanged',
      :name, OSX::NSUserDefaultsDidChangeNotification,
      :object, nil)
  end

  def dealloc
    OSX::NSNotificationCenter.defaultCenter.removeObserver(self)
  end

  def awakeFromNib
    self.preferencesChanged(self)
  end

  def stringValue=(s)
    @stringValue = s
    self.needsDisplay = true
  end

  def preferencesChanged(note)
    @fontName = OSX::NSUserDefaults.standardUserDefaults.stringForKey("fontName")
    @backgroundColor = OSX::NSUnarchiver.unarchiveObjectWithData(
      OSX::NSUserDefaults.standardUserDefaults.dataForKey("backgroundColor"))
    @foregroundColor = OSX::NSUnarchiver.unarchiveObjectWithData(
      OSX::NSUserDefaults.standardUserDefaults.dataForKey("foregroundColor"))
    self.needsDisplay = true
  end

  def keyDown(event)
    @controller.keyDown(event)
  end

  def enterFullScreen
    self.enterFullScreenMode_withOptions(OSX::NSScreen.mainScreen, nil)
  end

  def exitFullScreen
    self.exitFullScreenModeWithOptions(nil)
  end

  def drawRect(rect)
    @backgroundColor.set
    OSX::NSRectFill(self.bounds)

    baseFontSize = 30.0
    fontName = @fontName

    unless OSX::NSFontManager.sharedFontManager.availableFontFamilies.index(fontName)
      fontName = OSX::NSFont.systemFontOfSize(OSX::NSFont.systemFontSize).familyName
    end

    word = OSX::NSAttributedString.alloc.initWithString_attributes(
      "12CHARACTERS", {
        OSX::NSFontAttributeName => OSX::NSFont.fontWithName_size(fontName,
                                      baseFontSize)})

    biggestRatio = [word.size.width / self.bounds.width,
                    word.size.height / self.bounds.height].max

    word = OSX::NSAttributedString.alloc.initWithString_attributes(
      @stringValue, {
        OSX::NSFontAttributeName => OSX::NSFont.fontWithName_size(
                                      fontName, baseFontSize / biggestRatio),
        OSX::NSForegroundColorAttributeName => @foregroundColor})

    word.drawInRect OSX::NSRect.new(
      (self.bounds.width - word.size.width) / 2,
      (self.bounds.height - word.size.height) / 2 + word.size.height / 15,
      word.size.width,
      word.size.height)
  end

end
