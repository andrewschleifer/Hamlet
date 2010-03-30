require 'osx/cocoa'
require 'pathname'

path = Pathname.new OSX::NSBundle.mainBundle.resourcePath.fileSystemRepresentation

Pathname.glob(path + '*.rb') do |file|
	next if file.to_s == __FILE__
	require(file)
end

OSX::NSUserDefaults.standardUserDefaults.registerDefaults(
  {
    "foregroundColor" => OSX::NSArchiver.archivedDataWithRootObject(OSX::NSColor.blackColor),
    "backgroundColor" => OSX::NSArchiver.archivedDataWithRootObject(OSX::NSColor.whiteColor),
  }
)

OSX::NSApplication.sharedApplication
OSX.NSApplicationMain(0, nil)
