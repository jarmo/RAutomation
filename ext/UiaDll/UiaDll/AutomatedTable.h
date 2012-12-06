#pragma once
using namespace System::Windows::Automation;

ref class AutomatedTable
{
public:
	AutomatedTable(const HWND windowHandle);
	bool Exists(const char* whichItem);
	bool Exists(const int whichItemIndex);

	void Select(const int dataItemIndex);

	property int RowCount {
		int get();
	}

private:
	AutomationElement^ _tableControl;
	bool Exists(Condition^ condition);
};

