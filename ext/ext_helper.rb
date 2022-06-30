require 'fileutils'

module Platform
   def self.architecture
      ['foo'].pack('p').size == 8 ? 'x64' : 'x86'
   end
end

module ExternalBinaries
   extend self

   def move_files(externals)
      puts "Using #{Platform.architecture} externals"

      externals.each do |dest_path|
         dll_path = dest_path.gsub('Release', "#{Platform.architecture}Release")
         next if File.exists?(dest_path)
         FileUtils.cp(dll_path, dest_path)
      end

      externals
   end
end
