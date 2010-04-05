require 'osx/cocoa'

class HPreferences < OSX::NSObject
  kvc_accessor :fontList, :selectedFontIndex

  def initialize
    @fontList = OSX::NSFontManager.sharedFontManager.availableFontFamilies.sort
    @selectedFontIndex = @fontList.index(
      OSX::NSUserDefaults.standardUserDefaults.stringForKey("fontName"))
  end

  def selectedFontIndex=(i)
    OSX::NSUserDefaults.standardUserDefaults.setValue_forKey(
      @fontList[i], "fontName")
    @selectedFontIndex = i
  end

end
