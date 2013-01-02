#pragma once
using namespace System::Windows::Automation;

ref class AutomationFinder
{
public:
	AutomationFinder(AutomationElement^ automationElement);
	AutomationElementCollection^ Find(...array<Condition^>^ conditions);
	AutomationElement^ FindFirst(...array<Condition^>^ conditions);
	AutomationElement^ FindAt(const int whichItem, ...array<Condition^>^ conditions);

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
	AutomationElement^ _automationElement;
	Condition^ SomethingOrEverything(...array<Condition^>^ conditions);
};

