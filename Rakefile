require 'rake'
require 'rake/clean'
require 'erb'
require 'yaml'

begin
  require 'app'
rescue LoadError
end

unless defined? NAME
  raise "I have no identity. You should define a 'NAME', probably in 'app.rb'."
end

BUNDLEID ||= "org.example.#{NAME}"
RUBYFILES ||= ['main.rb']
COMPILED ||= ['main.m']
FRAMEWORKS = ['RubyCocoa']
EXE = "#{NAME}"
APP = "#{NAME}.app"
CLEAN.include [EXE, '*.nib', 'Info.plist']
CLOBBER.include [APP]

task :default => :build

desc 'Build the application'
task :build => [APP]

desc 'Launch the application'
task :launch => [APP] do
  sh "open '#{APP}'"
end

file APP => [EXE, 'Info.plist'] + RUBYFILES + RESOURCES do
  begin
    version = YAML.load_file('version.yml')
  rescue Errno::ENOENT
    version = {'release' => 0.1, 'build' => 0.01}
  end

  version['build'] += 0.01
  File.open('version.yml', 'w') {|f| f.write(YAML::dump(version)) }

  mkdir_p File.join(APP, 'Contents', 'MacOS')
  mkdir_p File.join(APP, 'Contents', 'Resources')

  cp EXE, File.join(APP, 'Contents', 'MacOS')
  cp 'Info.plist', File.join(APP, 'Contents')
  cp RUBYFILES + RESOURCES, File.join(APP, 'Contents', 'Resources')
end

file EXE => COMPILED do
  sh 'gcc -arch ppc -arch i386 -Wall -lobjc -framework ' +
    FRAMEWORKS.join(' -framework ') + ' ' + COMPILED.join(' ') +
    " -o '#{NAME}'"
end

file 'Info.plist' => 'Info.plist.erb' do
  File.open('Info.plist', 'w') do |f|
    f.puts ERB.new(File.read('Info.plist.erb')).result
  end
end

rule '.nib' => '.xib' do |nib|
  sh "ibtool --errors --warnings --notices --output-format human-readable-text --compile '#{nib.name}' '#{nib.source}'"
end
