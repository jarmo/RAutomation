module RAutomation
  # @private
  module ElementCollections
    # Creates collection classes and methods for elements.
    # @param [Array<Symbol>] elements for which to create collection classes
    #   and methods.
    def has_many(*elements)
      elements.each do |element|
        class_name = element.to_s.split("_").map {|e| e.capitalize}.join
        RAutomation.class_eval %Q{
            class #{class_name}
              include Enumerable

              def initialize(window, locators)
                @window = window
                @locators = locators
              end

              def each
                i = -1 
                while true
                  args = [@window, @locators.merge(:index => i += 1)].compact
                  object = RAutomation::#{class_name.chop}.new(*args)
                  break unless object.exists?
                  yield object
                end
              end

              def method_missing(name, *args)
                ary = self.to_a
                ary.respond_to?(name) ? ary.send(name, *args) : super
              end
            end
        }

        class_eval %Q{
            def #{element}(locators = {})
              #{class_name}.new(@window, locators)
            end
        }
      end
    end
  end
end
