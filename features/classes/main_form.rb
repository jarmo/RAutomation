class MainForm

  def initialize
    @window = RAutomation::Window.new(:title => "MainFormWindow")
  end

  def visible?
    @window.visible?
  end

  def open_about_dialog
    button = @window.button(:value => "&About")
    button.click
  end

end
