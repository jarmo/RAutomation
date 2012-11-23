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
public:
	int get() { return SelectionItems->Count; }
	}

private:
	AutomationElement^	_comboControl;
	void Select(AutomationElement^ itemToSelect);

	property AutomationElementCollection^ SelectionItems {
private:
	AutomationElementCollection^ get() { return _comboControl->FindAll(System::Windows::Automation::TreeScope::Subtree, SelectionCondition); }
	}

	property PropertyCondition^ SelectionCondition {
private:
	PropertyCondition^ get() { return gcnew PropertyCondition(AutomationElement::IsSelectionItemPatternAvailableProperty, true); }
	}
};

