require 'osx/cocoa'
require 'pathname'

path = Pathname.new OSX::NSBundle.mainBundle.resourcePath.fileSystemRepresentation

Pathname.glob(path + '*.rb') do |file|
	next if file.to_s == __FILE__
	require(file)
end

OSX::NSUserDefaults.standardUserDefaults.registerDefaults(
  {
    "fontName" => OSX::NSFont.systemFontOfSize(OSX::NSFont.systemFontSize).familyName,
    "foregroundColor" => OSX::NSArchiver.archivedDataWithRootObject(OSX::NSColor.blackColor),
    "backgroundColor" => OSX::NSArchiver.archivedDataWithRootObject(OSX::NSColor.whiteColor),
  }
)

if OSX::NSFont.fontWithName_size(
    OSX::NSUserDefaults.standardUserDefaults.stringForKey("fontName"), 1.0).nil?
  OSX::NSUserDefaults.standardUserDefaults.setValue_forKey(
    OSX::NSFont.systemFontOfSize(OSX::NSFont.systemFontSize).familyName,
    "fontName")
end

OSX::NSApplication.sharedApplication
OSX.NSApplicationMain(0, nil)
