class DataEntryForm
  # To change this template use File | Settings | File Templates.
  def initialize()
   @window = RAutomation::Window.new(:title => 'DataEntryForm')
  end

  def my_data_table
    @table = @window.table(:class => /SysListView32/i)
    @table.strings
  end
end
