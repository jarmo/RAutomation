#include "StdAfx.h"
#include "ExpandCollapseHelper.h"


void ExpandCollapseHelper::ExpandByValue(const FindInformation& findInformation, const char* whichItem)
{
	Expand(ExpandableItem(findInformation, whichItem));
}

void ExpandCollapseHelper::ExpandByIndex(const FindInformation& findInformation, const int whichItemIndex)
{
	auto expandableItem = ExpandableItems(findInformation)[whichItemIndex];
	Expand(expandableItem);
}

void ExpandCollapseHelper::CollapseByValue(const FindInformation& findInformation, const char* whichItem)
{
	Collapse(ExpandableItem(findInformation, whichItem));
}

void ExpandCollapseHelper::CollapseByIndex(const FindInformation& findInformation, const int whichItemIndex)
{
	auto expandableItem = ExpandableItems(findInformation)[whichItemIndex];
	Collapse(expandableItem);
}

AutomationElementCollection^ ExpandCollapseHelper::ExpandableItems(const FindInformation& findInformation)
{
	auto automationElement = (gcnew AutomationControl(findInformation))->Element;
	return automationElement->FindAll(System::Windows::Automation::TreeScope::Subtree, IsExpandable);
}

AutomationElement^ ExpandCollapseHelper::ExpandableItem(const FindInformation& findInformation, const char* whichItem)
{
	auto automationElement = (gcnew AutomationControl(findInformation))->Element;
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