class MainForm

  def initialize
    @window = RAutomation::Window.new(:title => "MainFormWindow")
  end

  def visible?
    @window.visible?
  end

  def open_about_dialog
    button = @window.button(:value => "&About")
    button.click { RAutomation::Window.new(:title => "About").exists? }
  end

  def select_checkbox
    @window.checkbox(:value => "checkBox").click
  end

  def checkbox_label_text
    # index => 3 is really a bad way to find the element. I had to guess the index number
    @window.text_field(:class => /STATIC/i, :index => 3).value
  end

  def checkbox_ticked?
    @window.checkbox(:value => "checkBox").checked?
  end

end
