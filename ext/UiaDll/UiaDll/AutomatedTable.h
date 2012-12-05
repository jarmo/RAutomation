#pragma once
using namespace System::Windows::Automation;

ref class AutomatedTable
{
public:
	AutomatedTable(const HWND windowHandle);

	void Select(const int dataItemIndex);
	String^ ValueAt(const int dataRow);
	String^ CellValueAt(const int dataRow, const int dataColumn);

	property int RowCount {
		int get();
	}

	property int ColumnCount {
		int get();
	}

private:
	AutomationElement^ _tableControl;

	AutomationElement^ DataItemAt(const int row);
};

