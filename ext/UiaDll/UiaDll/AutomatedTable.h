#pragma once
using namespace System::Windows::Automation;

ref class AutomatedTable
{
public:
	AutomatedTable(const HWND windowHandle);
	bool Exists(const int whichItemIndex, const char* whichItem);
	bool Exists(const int whichItemIndex, const int whichColumnIndex);
	String^ ValueAt(const int whichItemIndex, const int whichColumnIndex);
	void Select(const int dataItemIndex);
	void Select(const char* dataItemValue);

	property int RowCount {
		int get();
	}

private:
	AutomationElement^ _tableControl;
	bool Exists(Condition^ condition);
	AutomationElement^ DataItemAt(const int whichItemIndex, const int whichItemRow);
	AutomationElementCollection^ FindTableItem(Condition^ condition);
	AutomationElementCollection^ FindDataItem();
	AutomationElementCollection^ FindDataItem(Condition^ condition);
	void Select(AutomationElement^ dataItem);
};

