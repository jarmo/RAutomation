#pragma once
using namespace System::Windows::Automation;

public ref class AutomatedComboBox
{
public:
	AutomatedComboBox(const HWND windowHandle);
	bool SelectByIndex(const int whichItem);
	bool SelectByValue(const char* whichItem);
	bool GetValueByIndex(const int whichItem, char* comboValue, const int comboValueSize);

	property int Count {
		int get() { return SelectionItems->Count; }
	}

	property int SelectedIndex {
		int get();
	}

private:
	AutomationElement^	_comboControl;
	void Select(AutomationElement^ itemToSelect);

	property AutomationElementCollection^ SelectionItems {
	  AutomationElementCollection^ get() { return _comboControl->FindAll(System::Windows::Automation::TreeScope::Subtree, SelectionCondition); }
	}

	property PropertyCondition^ SelectionCondition {
	  PropertyCondition^ get() { return gcnew PropertyCondition(AutomationElement::IsSelectionItemPatternAvailableProperty, true); }
	}
};

