#pragma once

#include "AutomationControl.h"

using namespace System::Windows::Automation;

ref class ExpandCollapseHelper
{
public:
	void ExpandByValue(const FindInformation& findInformation, const char* whichItem);
	void ExpandByIndex(const FindInformation& findInformation, const int whichItemIndex);
	void CollapseByValue(const FindInformation& findInformation, const char* whichItem);
	void CollapseByIndex(const FindInformation& findInformation, const int whichItemIndex);

private:
	AutomationElementCollection^ ExpandableItems(const FindInformation& findInformation);
	AutomationElement^ ExpandableItem(const FindInformation& findInformation, const char* whichItem);
	void Expand(AutomationElement^ automationElement);
	void Collapse(AutomationElement^ automationElement);

	property PropertyCondition^ IsExpandable {
		PropertyCondition^ get();
	}
};

