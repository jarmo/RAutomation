#include "StdAfx.h"
#include "ExpandCollapseHelper.h"


void ExpandCollapseHelper::ExpandByValue(const HWND windowHandle, const char* whichItem)
{
	Expand(ExpandableItem(windowHandle, whichItem));
}

void ExpandCollapseHelper::ExpandByIndex(const HWND windowHandle, const int whichItemIndex)
{
	auto expandableItem = ExpandableItems(windowHandle)[whichItemIndex];
	Expand(expandableItem);
}

void ExpandCollapseHelper::CollapseByValue(const HWND windowHandle, const char* whichItem)
{
	Collapse(ExpandableItem(windowHandle, whichItem));
}

void ExpandCollapseHelper::CollapseByIndex(const HWND windowHandle, const int whichItemIndex)
{
	auto expandableItem = ExpandableItems(windowHandle)[whichItemIndex];
	Collapse(expandableItem);
}

AutomationElementCollection^ ExpandCollapseHelper::ExpandableItems(const HWND windowHandle)
{
	auto automationElement = AutomationElement::FromHandle(IntPtr(windowHandle));
	return automationElement->FindAll(System::Windows::Automation::TreeScope::Subtree, IsExpandable);
}

AutomationElement^ ExpandCollapseHelper::ExpandableItem(const HWND windowHandle, const char* whichItem)
{
	auto automationElement = AutomationElement::FromHandle(IntPtr(windowHandle));
	auto andTheNameMatches = gcnew PropertyCondition(AutomationElement::NameProperty, gcnew String(whichItem));
	return automationElement->FindFirst(System::Windows::Automation::TreeScope::Subtree, gcnew AndCondition(IsExpandable, andTheNameMatches));
}

void ExpandCollapseHelper::Expand(AutomationElement^ automationElement)
{
	dynamic_cast<ExpandCollapsePattern^>(automationElement->GetCurrentPattern(ExpandCollapsePattern::Pattern))->Expand();
}

void ExpandCollapseHelper::Collapse(AutomationElement^ automationElement)
{
	dynamic_cast<ExpandCollapsePattern^>(automationElement->GetCurrentPattern(ExpandCollapsePattern::Pattern))->Collapse();
}

PropertyCondition^ ExpandCollapseHelper::IsExpandable::get()
{
	return gcnew PropertyCondition(AutomationElement::IsExpandCollapsePatternAvailableProperty, true);
}