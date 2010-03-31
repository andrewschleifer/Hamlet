require 'rake'
require 'rake/clean'
require 'erb'
require 'yaml'

begin
  app = YAML.load_file('app.yml')
rescue LoadError
end

unless defined? app['name']
  raise "I have no identity. You should define a 'name', probably in 'app.yml'."
end

app['bundle_id'] ||= "org.example.#{app['name']}"
app['ruby_files'] ||= ['main.rb']
app['objc_files'] ||= ['main.m']
app['frameworks'] ||= ['RubyCocoa']
app['bundle'] = "#{app['name']}.app"
CLEAN.include ['a.out', '*.nib', 'Info.plist']
CLOBBER.include [app['bundle']]

task :default => :build

desc 'Build the application'
task :build => [app['bundle']]

desc 'Launch the application'
task :launch => [app['bundle']] do
  sh "open '#{app['bundle']}'"
end

file app['bundle'] => ['a.out', 'Info.plist'] + app['ruby_files'] + app['resources'] do
  begin
    version = YAML.load_file('version.yml')
  rescue Errno::ENOENT
    version = {'release' => 0.1, 'build' => 0.01}
  end

  version['build'] += 0.01
  File.open('version.yml', 'w') {|f| f.write(YAML::dump(version)) }

  mkdir_p File.join(app['bundle'], 'Contents', 'MacOS')
  mkdir_p File.join(app['bundle'], 'Contents', 'Resources')

  cp 'a.out', File.join(app['bundle'], 'Contents', 'MacOS', app['name'])
  cp 'Info.plist', File.join(app['bundle'], 'Contents')
  cp app['ruby_files'] + app['resources'], File.join(app['bundle'], 'Contents', 'Resources')
end

file 'a.out' => app['objc_files'] do
  sh 'gcc -arch ppc -arch i386 -Wall -lobjc -framework ' +
    app['frameworks'].join(' -framework ') + ' ' + app['objc_files'].join(' ')
end

file 'Info.plist' => 'Info.plist.erb' do
  File.open('Info.plist', 'w') do |f|
    f.puts ERB.new(File.read('Info.plist.erb')).result
  end
end

rule '.nib' => '.xib' do |nib|
  sh "ibtool --errors --warnings --notices --output-format human-readable-text --compile '#{nib.name}' '#{nib.source}'"
end
