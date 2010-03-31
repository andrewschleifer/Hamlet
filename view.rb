require 'osx/cocoa'

class HView < OSX::NSView
  attr_reader :stringValue
  kvc_accessor :foregroundColor, :backgroundColor

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
    self.preferencesChanged(nil)
  end

  def stringValue=(s)
    @stringValue = s
    self.needsDisplay = true
  end

  def preferencesChanged(note)
    @backgroundColor = OSX::NSUnarchiver.unarchiveObjectWithData(
      OSX::NSUserDefaults.standardUserDefaults.dataForKey("backgroundColor"))
    @foregroundColor = OSX::NSUnarchiver.unarchiveObjectWithData(
      OSX::NSUserDefaults.standardUserDefaults.dataForKey("foregroundColor"))
    self.needsDisplay = true
  end

  def drawRect(rect)
    fontSizeRatio = 1.2
    @backgroundColor.set
    OSX::NSRectFill(self.bounds)
    baseFontSize = 30.0
    fontName = "Times New Roman"

    attributedString = OSX::NSAttributedString.alloc.objc_send(
      :initWithString, "12CHARACTERS",
      :attributes, {OSX::NSFontAttributeName => OSX::NSFont.fontWithName_size(fontName, baseFontSize)})

    stringSize = attributedString.size

    biggestRatio = [stringSize.width / self.bounds.width, stringSize.height / self.bounds.height].max
    fontSize = (baseFontSize / biggestRatio) / fontSizeRatio;

    attributedString = OSX::NSAttributedString.alloc.objc_send(
      :initWithString, @stringValue,
      :attributes, {
        OSX::NSFontAttributeName => OSX::NSFont.fontWithName_size(fontName, fontSize),
        OSX::NSForegroundColorAttributeName => @foregroundColor})

    stringSize = attributedString.size

    attributedString.drawInRect OSX::NSRect.new(
      (self.bounds.width - stringSize.width) / 2,
      (self.bounds.height - stringSize.height) / 2 + stringSize.height / 15,
      stringSize.width,
      stringSize.height)
  end

end
