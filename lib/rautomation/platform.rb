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
      RUBY_PLATFORM.include?('32')
   end
end
