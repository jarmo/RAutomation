#include "StdAfx.h"
#include "AutomationFinder.h"

AutomationFinder::AutomationFinder(AutomationElement^ automationElement)
{
	_automationElement = automationElement;
}

AutomationElement^ AutomationFinder::FindFor(const FindInformation& findInformation)
{
		auto finder = gcnew AutomationFinder(AutomationElement::FromHandle(IntPtr(findInformation.rootWindow)));
		return finder->Find(findInformation);
}

AutomationElementCollection^ AutomationFinder::Find(...array<Condition^>^ conditions)
{
  return Find(Subtree, conditions);
}

AutomationElementCollection^ AutomationFinder::Find(const UIAutomation::TreeScope scope, ...array<Condition^>^ conditions)
{
	return _automationElement->FindAll(scope, SomethingOrEverything(conditions));
}

AutomationElement^ AutomationFinder::FindFirst(...array<Condition^>^ conditions)
{
  return FindFirst(Subtree, conditions);
}

AutomationElement^ AutomationFinder::FindFirst(const UIAutomation::TreeScope scope, ...array<Condition^>^ conditions)
{
	return _automationElement->FindFirst(scope, SomethingOrEverything(conditions));
}

AutomationElement^ AutomationFinder::Find(const FindInformation& findInformation)
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

AutomationElement^ AutomationFinder::FindAt(const int whichItem, ...array<Condition^>^ conditions)
{
  return FindAt(Subtree, whichItem, conditions);
}

AutomationElement^ AutomationFinder::FindAt(const UIAutomation::TreeScope scope, const int whichItem, ...array<Condition^>^ conditions)
{
	return Find(scope, conditions)[whichItem];
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