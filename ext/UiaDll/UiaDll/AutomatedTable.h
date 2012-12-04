#pragma once
using namespace System::Windows::Automation;

ref class AutomatedTable
{
public:
	AutomatedTable(const HWND windowHandle);

	void Select(const int dataItemIndex);
	String^ ValueAt(const int dataRow, const int dataColumn);

	property int RowCount {
		int get();
	}

private:
	AutomationElement^ _tableControl;
};

