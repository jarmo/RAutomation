module Platform
   extend self

   def architecture
      if is_x86?
         'x86'
      else
         'x64'
      end
   end

   def is_x86?
      %w[x86 i386].any? { |p| RUBY_PLATFORM =~ /#{p}/i }
   end
end
