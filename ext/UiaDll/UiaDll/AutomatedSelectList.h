#pragma once
#include "AutomationControl.h"
#include "AutomationClicker.h"
#include "StringHelper.h"

using namespace System::Windows::Automation;

ref class AutomatedSelectList : public AutomationControl
{
public:
	AutomatedSelectList(const HWND windowHandle);
	AutomatedSelectList(const FindInformation& findInformation);
	bool SelectByIndex(const int whichItem);
	bool SelectByValue(const char* whichItem);
	bool GetValueByIndex(const int whichItem, char* comboValue, const int comboValueSize);
  int GetOptions(const char* options[]);

  property array<String^>^ Selection {
    array<String^>^ get();
  }

	property int Count {
		int get() { return SelectionItems->Count; }
	}

	property int SelectedIndex {
		int get();
	}

private:
	void Select(AutomationElement^ itemToSelect);

	property SelectionPattern^ AsSelectionPattern {
		SelectionPattern^ get() {
			return dynamic_cast<SelectionPattern^>(_control->GetCurrentPattern(SelectionPattern::Pattern));
		}
	}

	property AutomationElementCollection^ SelectionItems {
	  AutomationElementCollection^ get() { return _control->FindAll(System::Windows::Automation::TreeScope::Subtree, SelectionCondition); }
	}

	property PropertyCondition^ SelectionCondition {
	  PropertyCondition^ get() { return gcnew PropertyCondition(AutomationElement::IsSelectionItemPatternAvailableProperty, true); }
	}
};

