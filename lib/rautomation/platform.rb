module Platform
   extend self

   def architecture
     is_x86? ? 'x86' : 'x64'
   end

   def is_x86?
     ['foo'].pack('p').size == 4
   end
end
