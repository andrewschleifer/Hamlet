require 'osx/cocoa'
require 'pathname'

path = Pathname.new OSX::NSBundle.mainBundle.resourcePath.fileSystemRepresentation

Pathname.glob(path + '*.rb') do |file|
	next if file.to_s == __FILE__
	require(file)
end

{"foregroundColor" => OSX::NSColor.blackColor,
  "backgroundColor" => OSX::NSColor.whiteColor}.each do |name, color|
  unless OSX::NSUserDefaults.standardUserDefaults.dataForKey(name)
    OSX::NSUserDefaults.standardUserDefaults.setObject_forKey(
      OSX::NSArchiver.archivedDataWithRootObject(color), name)
  end
end

OSX::NSApplication.sharedApplication
OSX.NSApplicationMain(0, nil)
