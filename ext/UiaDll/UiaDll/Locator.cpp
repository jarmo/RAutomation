#include "StdAfx.h"
#include "Locator.h"

Locator::Locator(AutomationElement^ automationElement)
{
	_automationElement = automationElement;
}

AutomationElement^ Locator::FindFor(const FindInformation& findInformation)
{
	try {
		auto finder = gcnew Locator(AutomationElement::FromHandle(IntPtr(findInformation.rootWindow)));
		return finder->Find(findInformation);
	} catch(Exception^) {
		return nullptr;
	}
}

AutomationElementCollection^ Locator::Find(...array<Condition^>^ conditions)
{
  return Find(Subtree, conditions);
}

AutomationElementCollection^ Locator::Find(const UIAutomation::TreeScope scope, ...array<Condition^>^ conditions)
{
	return _automationElement->FindAll(scope, SomethingOrEverything(conditions));
}

AutomationElement^ Locator::FindFirst(...array<Condition^>^ conditions)
{
  return FindFirst(Subtree, conditions);
}

AutomationElement^ Locator::FindFirst(const UIAutomation::TreeScope scope, ...array<Condition^>^ conditions)
{
	return _automationElement->FindFirst(scope, SomethingOrEverything(conditions));
}

AutomationElement^ Locator::Find(const FindInformation& findInformation)
{
  auto scope = findInformation.onlySearchChildren ? Children : Subtree;

  switch(findInformation.how) {
    case Id:
		{
      auto searchCondition = gcnew PropertyCondition(AutomationElement::AutomationIdProperty, gcnew String(findInformation.data.stringData));
      if( 0 == findInformation.index ) {
        return FindFirst(scope, searchCondition);
      }

      return FindAt(scope, findInformation.index, searchCondition);
		}
    case Value:
		{
      auto searchCondition = gcnew PropertyCondition(AutomationElement::NameProperty, gcnew String(findInformation.data.stringData));

      if( 0 == findInformation.index ) {
        return FindFirst(scope, searchCondition);
      }

      return FindAt(scope, findInformation.index, searchCondition);
		}
    case Focus:
      return AutomationElement::FocusedElement;
    case ScreenPoint:
			return AutomationElement::FromPoint(Point(findInformation.data.pointData[0], findInformation.data.pointData[1]));
    case Handle:
      return AutomationElement::FromHandle(IntPtr(findInformation.data.intData));
	}

  return nullptr;
}

AutomationElement^ Locator::FindAt(const int whichItem, ...array<Condition^>^ conditions)
{
  return FindAt(Subtree, whichItem, conditions);
}

AutomationElement^ Locator::FindAt(const UIAutomation::TreeScope scope, const int whichItem, ...array<Condition^>^ conditions)
{
	return Find(scope, conditions)[whichItem];
}

Condition^ Locator::SomethingOrEverything(...array<Condition^>^ conditions)
{
	if( conditions->Length == 0 ) {
		return Condition::TrueCondition;
	} else if( conditions->Length == 1 ) {
		return conditions[0];
	}

	return gcnew AndCondition(conditions);
}