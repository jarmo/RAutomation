#pragma once
#include "StringHelper.h"

using namespace System::Windows::Automation;

public ref class MenuItemSelector
{
public:
	void SelectMenuPath(const HWND windowHandle, std::list<const char*>& menuItems);
	BOOL MenuItemExists(const HWND windowHandle, std::list<const char*>& menuItems);

private:
	AutomationElement^ FindMenuItem(AutomationElement^ rootElement, std::list<const char*>& menuItems);
	PropertyCondition^ NameConditionFor(String^ name);
	AutomationElement^ GetNextMenuItem(AutomationElement^ foundMenuItem, String^ nextMenu);
	ExpandCollapsePattern^ AsExpandCollapse(AutomationElement^ foundMenuItem);
	void TryToExpand(ExpandCollapsePattern^ expandCollapsePattern);

	property PropertyCondition^ MenuItemControlType {
private:
	PropertyCondition^ get() { return gcnew PropertyCondition(AutomationElement::ControlTypeProperty, ControlType::MenuItem); }
	}
};

