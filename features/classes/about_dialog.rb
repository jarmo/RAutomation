class AboutDialog

  def initialize
    @window = RAutomation::Window.new(:title => "About")
  end

  def visible?
    @window.visible?
  end

end
