#include "StdAfx.h"
#include "AutomationFinder.h"

AutomationFinder::AutomationFinder(AutomationElement^ automationElement)
{
	_automationElement = automationElement;
}

AutomationElementCollection^ AutomationFinder::Find(...array<Condition^>^ conditions)
{
	return _automationElement->FindAll(System::Windows::Automation::TreeScope::Subtree, SomethingOrEverything(conditions));
}

AutomationElement^ AutomationFinder::FindFirst(...array<Condition^>^ conditions)
{
	return _automationElement->FindFirst(System::Windows::Automation::TreeScope::Subtree, SomethingOrEverything(conditions));
}

AutomationElement^ AutomationFinder::Find(const FindInformation& findInformation)
{
  switch(findInformation.how) {
    case FindMethod::Id:
		{
      auto searchCondition = gcnew PropertyCondition(AutomationElement::AutomationIdProperty, gcnew String(findInformation.data.stringData));
      return FindAt(findInformation.index, searchCondition);
		}
    case FindMethod::Value:
		{
      auto searchCondition = gcnew PropertyCondition(AutomationElement::NameProperty, gcnew String(findInformation.data.stringData));
      return FindAt(findInformation.index, searchCondition);
		}
    case FindMethod::Focus:
      return AutomationElement::FocusedElement;
    case FindMethod::ScreenPoint:
			return AutomationElement::FromPoint(Point(findInformation.data.pointData[0], findInformation.data.pointData[1]));
	}

  return nullptr;
}

AutomationElement^ AutomationFinder::FindAt(const int whichItem, ...array<Condition^>^ conditions)
{
	return Find(conditions)[whichItem];
}

Condition^ AutomationFinder::SomethingOrEverything(...array<Condition^>^ conditions)
{
	if( conditions->Length == 0 ) {
		return Condition::TrueCondition;
	} else if( conditions->Length == 1 ) {
		return conditions[0];
	}

	return gcnew AndCondition(conditions);
}