#pragma once
using namespace System::Windows;
using namespace System::Windows::Automation;

ref class AutomationFinder
{
public:
	static AutomationElement^ FindFor(const FindInformation& findInformation);

	AutomationFinder(AutomationElement^ automationElement);
	AutomationElement^ Find(const FindInformation& findInformation);
	AutomationElementCollection^ Find(...array<Condition^>^ conditions);
	AutomationElementCollection^ Find(const UIAutomation::TreeScope scope, ...array<Condition^>^ conditions);
	AutomationElement^ FindFirst(...array<Condition^>^ conditions);
	AutomationElement^ FindFirst(const UIAutomation::TreeScope scope, ...array<Condition^>^ conditions);
	AutomationElement^ FindAt(const int whichItem, ...array<Condition^>^ conditions);
	AutomationElement^ FindAt(const UIAutomation::TreeScope scope, const int whichItem, ...array<Condition^>^ conditions);

	static property Condition^ IsSelectionItem {
		Condition^ get() {
			return gcnew PropertyCondition(AutomationElement::IsSelectionItemPatternAvailableProperty, true);
		}
	}

	static property Condition^ IsTableItem {
		Condition^ get() {
			return gcnew PropertyCondition(AutomationElement::IsTableItemPatternAvailableProperty, true);
		}
	}

	static property Condition^ IsDataItem {
		Condition^ get() {
			return gcnew PropertyCondition(AutomationElement::ControlTypeProperty, ControlType::DataItem);
		}
	}

	static property Condition^ IsHeaderItem {
		Condition^ get() {
			return gcnew PropertyCondition(AutomationElement::ControlTypeProperty, ControlType::HeaderItem);
		}
	}

	static property Condition^ IsListItem {
		Condition^ get() {
			return gcnew PropertyCondition(AutomationElement::ControlTypeProperty, ControlType::ListItem);
		}
	}

private:
  static UIAutomation::TreeScope Subtree = UIAutomation::TreeScope::Subtree;
  static UIAutomation::TreeScope Children = UIAutomation::TreeScope::Children;
	AutomationElement^ _automationElement;
	Condition^ SomethingOrEverything(...array<Condition^>^ conditions);
};

