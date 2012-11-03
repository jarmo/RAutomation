#pragma once
using namespace System::Windows::Automation;

public ref class AutomatedComboBox
{
public:
	AutomatedComboBox(const HWND windowHandle);
	bool SelectByIndex(const int whichItem);
	bool SelectByValue(const char* whichItem);

private:
	AutomationElement^	_comboControl;
	void Select(AutomationElement^ itemToSelect);

	property PropertyCondition^ SelectionCondition {
private:
	PropertyCondition^ get() { return gcnew PropertyCondition(AutomationElement::IsSelectionItemPatternAvailableProperty, true); }
	}
};

