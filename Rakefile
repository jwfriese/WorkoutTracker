desc "Clears derived data and opens Xcode"
task :swiffer do
  success = system('rm -rf ~/Library/Developer/Xcode/DerivedData/*')
  if success
    puts 'Derived data deleted'
    system('open -a "Xcode" WorkoutTracker.xcodeproj/')
  else 
    puts 'Failed to delete derived data'
  end
end

desc "Run the unit tests (specify platform by setting PLATFORM env variable)"
task :specs, [:phone_version, :ios_version]  do |t, args|
  args.with_defaults(:phone_version => '6', :ios_version => '9.2')
  platform = ENV["PLATFORM"] || "iPhone #{args.phone_version},OS=#{args.ios_version}"
  success = system("xcodebuild -scheme Tests -sdk iphonesimulator test -destination 'platform=iOS Simulator,name=#{platform}' | xcpretty --color --test")
  unless  success
    exit 1
  end
end

desc "Run the unit tests with a verbose build"
task :verbose_specs, [:phone_version, :ios_version]  do |t, args|
  args.with_defaults(:phone_version => '6', :ios_version => '9.2')
  platform = ENV["PLATFORM"] || "iPhone #{args.phone_version},OS=#{args.ios_version}"
  success = system("xcodebuild -verbose -scheme Tests -sdk iphonesimulator test -destination 'platform=iOS Simulator,name=#{platform}'")
  unless  success
    exit 1
  end
end

desc "Clean out all provisioning profiles"
task :wipe do
  Dir["#{ENV['HOME']}/Library/MobileDevice/Provisioning Profiles/*.mobileprovision"].each {|f|  File.delete(f) }
end

desc "Find focused elements in Cedar specs"
task :findfocus do
  system("grep -r -E 'fdescribe|fit|fcontext' --include \*Spec.swift --exclude-dir=External .")
end

