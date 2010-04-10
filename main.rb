require 'osx/cocoa'
require 'pathname'

path = Pathname.new OSX::NSBundle.mainBundle.resourcePath.fileSystemRepresentation

Pathname.glob(path + '*.rb') do |file|
	next if file.to_s == __FILE__
	require(file)
end

OSX::NSUserDefaults.standardUserDefaults.registerDefaults(
  OSX::NSDictionary.dictionaryWithContentsOfFile(
    OSX::NSBundle.mainBundle.pathForResource_ofType("view", "plist")))

unless OSX::NSFontManager.sharedFontManager.availableFonts.index(
    OSX::NSUserDefaults.standardUserDefaults.stringForKey("fontName"))
  OSX::NSUserDefaults.standardUserDefaults.setValue_forKey(
    OSX::NSFont.systemFontOfSize(OSX::NSFont.systemFontSize).familyName,
    "fontName")
end

OSX::NSApplication.sharedApplication
OSX.NSApplicationMain(0, nil)
