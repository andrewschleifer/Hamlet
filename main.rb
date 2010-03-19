require 'osx/cocoa'
require 'pathname'

def log(*args)
	args.each do |m|
		OSX.NSLog m.inspect
	end
end

path = Pathname.new OSX::NSBundle.mainBundle.resourcePath.fileSystemRepresentation

Pathname.glob(path + '*.rb') do |file|
	next if file.to_s == __FILE__
	require(file)
end

OSX::NSApplication.sharedApplication
OSX.NSApplicationMain(0, nil)
