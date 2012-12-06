#pragma once
using namespace System::Windows::Automation;

ref class ExpandCollapseHelper
{
public:
	void ExpandByValue(const HWND windowHandle, const char* whichItem);
	void ExpandByIndex(const HWND windowHandle, const int whichItemIndex);
	void CollapseByValue(const HWND windowHandle, const char* whichItem);
	void CollapseByIndex(const HWND windowHandle, const int whichItemIndex);

private:
	AutomationElementCollection^ ExpandableItems(const HWND windowHandle);
	AutomationElement^ ExpandableItem(const HWND windowHandle, const char* whichItem);
	void Expand(AutomationElement^ automationElement);
	void Collapse(AutomationElement^ automationElement);

	property PropertyCondition^ IsExpandable {
		PropertyCondition^ get();
	}
};

