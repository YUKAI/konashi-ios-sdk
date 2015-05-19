require "versionomy"
require "cocoapods"

# steps to release an update on cocoapods
# % rake increment:tiny
# % pod trunk push

[:major,:minor,:tiny].each { |part|
  desc "increment #{part} part of version"
  task "increment:#{part}" do |task|
    old_version=Versionomy.parse(podspec_version())
    new_version=old_version.bump(part)
    podspec_replace_version(old_version.to_s(), new_version.to_s())

    sh "git commit -av -m\"version++\""
    sh "git tag v#{new_version}"

    print "version upgraded and tagged to v#{new_version}\n"
  end
}

def podspec_version
  spec = Pod::Specification.from_file(podspec_path())
  spec.version.to_s
end

def podspec_path
  podspecs = Dir.glob('*.podspec')
  if podspecs.count == 1
    podspecs.first
  else
    fail 'Could not select a podspec'
  end
end

def podspec_replace_version(old_version,new_version)
  text = File.read(podspec_path())
  text.gsub!("#{old_version}", "#{new_version}")
  File.open(podspec_path(), 'w') { |file| file.puts text }
end
