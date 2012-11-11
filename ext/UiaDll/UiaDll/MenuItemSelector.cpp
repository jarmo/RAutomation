#include "StdAfx.h"
#include "MenuItemSelector.h"

using namespace std;

void MenuItemSelector::SelectMenuPath(const HWND windowHandle, list<const char*>& menuItems)
{
	auto automationElement = AutomationElement::FromHandle(IntPtr(windowHandle));
	auto foundMenuItem = FindMenuItem(automationElement, menuItems);
	auto invokePattern = dynamic_cast<InvokePattern^>(foundMenuItem->GetCurrentPattern(InvokePattern::Pattern));
	invokePattern->Invoke();
}

BOOL MenuItemSelector::MenuItemExists(const HWND windowHandle, list<const char*>& menuItems)
{
	try {
		auto automationElement = AutomationElement::FromHandle(IntPtr(windowHandle));
		return FindMenuItem(automationElement, menuItems) != nullptr;
	} catch(Exception^ e) {
		return FALSE;
	}
}

AutomationElement^ MenuItemSelector::FindMenuItem(AutomationElement^ rootElement, std::list<const char*>& menuItems)
{
	auto foundMenuItem = rootElement;

	for(list<const char*>::iterator menuItem = menuItems.begin(); menuItem != menuItems.end(); ++menuItem) {
		foundMenuItem = GetNextMenuItem(foundMenuItem, gcnew String(*menuItem));
	}

	return foundMenuItem;
}

PropertyCondition^ MenuItemSelector::NameConditionFor(String^ name)
{
	return gcnew PropertyCondition(AutomationElement::NameProperty, name);
}

AutomationElement^ MenuItemSelector::GetNextMenuItem(AutomationElement^ foundMenuItem, String^ nextMenu)
{
	TryToExpand(AsExpandCollapse(foundMenuItem));
	auto nextMenuItem = foundMenuItem->FindFirst(System::Windows::Automation::TreeScope::Subtree,
								   gcnew AndCondition(MenuItemControlType, NameConditionFor(nextMenu)));
	if( nullptr == nextMenuItem ) {
		throw gcnew Exception(String::Format("MenuItem with the text \"{0}\" does not exist", nextMenu));
	}
	return nextMenuItem;
}

ExpandCollapsePattern^ MenuItemSelector::AsExpandCollapse(AutomationElement^ foundMenuItem)
{
	try
	{
		return dynamic_cast<ExpandCollapsePattern^>(foundMenuItem->GetCurrentPattern(ExpandCollapsePattern::Pattern));
	}
	catch(Exception^ e)
	{
		return nullptr;
	}
}

void MenuItemSelector::TryToExpand(ExpandCollapsePattern^ expandCollapsePattern)
{
	if (nullptr == expandCollapsePattern) return;

	try
	{
		expandCollapsePattern->Expand();
	}
	catch(Exception^ e)
	{
		expandCollapsePattern->Expand();
	}
}