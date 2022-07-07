module Platform
   extend self

   def architecture(arg)
      case arg.include?('x86')
      when true
         'x86'
      when false
         'x64'
      else
         raise ArgumentError, "Unable to resolve architecture based on arg : #{arg}"
      end
   end

   def is_x86?
     ['foo'].pack('p').size == 4
   end
end
