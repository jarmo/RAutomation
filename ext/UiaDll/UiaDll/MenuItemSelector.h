#pragma once
using namespace System::Windows::Automation;

public ref class MenuItemSelector
{
public:
	void SelectMenuPath(const HWND windowHandle, std::list<const char*>& menuItems);

private:
	PropertyCondition^ NameConditionFor(String^ name);
	AutomationElement^ GetNextMenuItem(AutomationElement^ foundMenuItem, String^ nextMenu);
	ExpandCollapsePattern^ AsExpandCollapse(AutomationElement^ foundMenuItem);
	void TryToExpand(ExpandCollapsePattern^ expandCollapsePattern);

	property PropertyCondition^ MenuItemControlType {
private:
	PropertyCondition^ get() { return gcnew PropertyCondition(AutomationElement::ControlTypeProperty, ControlType::MenuItem); }
	}
};

