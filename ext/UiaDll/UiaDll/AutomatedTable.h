#pragma once
#include "AutomationFinder.h"

using namespace System::Windows::Automation;

ref class AutomatedTable
{
public:
	AutomatedTable(const HWND windowHandle);
	bool Exists(const int whichItemIndex, const int whichColumnIndex);
	String^ ValueAt(const int whichItemIndex, const int whichColumnIndex);
	void Select(const int dataItemIndex);
	void Select(const char* dataItemValue);
	bool IsSelected(const int dataItemIndex);
	int GetHeaders(const char* headers[]);

	property int RowCount {
		int get();
	}

private:
	AutomationElement^ _tableControl;
	AutomationFinder^ _finder;
	bool Exists(Condition^ condition);
	AutomationElement^ DataItemAt(const int whichItemIndex, const int whichItemRow);
	void Select(AutomationElement^ dataItem);

	SelectionItemPattern^ AsSelectionItem(AutomationElement^ automationElement) {
		return dynamic_cast<SelectionItemPattern^>(automationElement->GetCurrentPattern(SelectionItemPattern::Pattern));
	}
};

