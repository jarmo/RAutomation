#pragma once
#include "AutomationControl.h"
#include "AutomationFinder.h"
#include "StringHelper.h"

using namespace System::Windows::Automation;

ref class AutomatedTable : AutomationControl
{
public:
	AutomatedTable(const HWND windowHandle);
	AutomatedTable(const FindInformation& finderInformation);
	bool Exists(const int whichItemIndex, const int whichColumnIndex);
	String^ ValueAt(const int whichItemIndex, const int whichColumnIndex);
	void Select(const int dataItemIndex);
	void Select(const char* dataItemValue);
	bool IsSelected(const int dataItemIndex);
	int GetHeaders(const char* headers[]);
	int GetValues(const char* values[]);

	property int RowCount {
		int get();
	}

private:
	AutomationFinder^ _finder;
	bool Exists(Condition^ condition);
	AutomationElement^ DataItemAt(const int whichItemIndex, const int whichItemRow);
	void Select(AutomationElement^ dataItem);

	SelectionItemPattern^ AsSelectionItem(AutomationElement^ automationElement) {
		return dynamic_cast<SelectionItemPattern^>(automationElement->GetCurrentPattern(SelectionItemPattern::Pattern));
	}
};

