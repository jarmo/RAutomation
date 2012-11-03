#include "StdAfx.h"
#include "AutomatedComboBox.h"

AutomatedComboBox::AutomatedComboBox(const HWND windowHandle)
{
	_comboControl = AutomationElement::FromHandle(IntPtr(windowHandle));
}

bool AutomatedComboBox::SelectByIndex(const int whichItem)
{
	try {
	  auto selectionItems = _comboControl->FindAll(System::Windows::Automation::TreeScope::Subtree, gcnew PropertyCondition(AutomationElement::IsSelectionItemPatternAvailableProperty, true));
	  auto selectionPattern = dynamic_cast<SelectionItemPattern^>(selectionItems[whichItem]->GetCurrentPattern(SelectionItemPattern::Pattern));
	  selectionPattern->Select();
	  return true;
	} catch(Exception^ e) {
		Console::WriteLine(e->ToString());
		return false;
	}
}

bool AutomatedComboBox::SelectByValue(const char* whichItem)
{
	try {
	  auto selectionCondition = gcnew PropertyCondition(AutomationElement::IsSelectionItemPatternAvailableProperty, true);
	  auto nameCondition = gcnew PropertyCondition(AutomationElement::NameProperty, gcnew String(whichItem));
	  auto selectionAndNameCondition = gcnew AndCondition(selectionCondition, nameCondition);

	  auto foundItem = _comboControl->FindFirst(System::Windows::Automation::TreeScope::Subtree, selectionAndNameCondition);
	  auto selectionPattern = dynamic_cast<SelectionItemPattern^>(foundItem->GetCurrentPattern(SelectionItemPattern::Pattern));
	  selectionPattern->Select();
	  return true;
	} catch(Exception^ e) {
		Console::WriteLine(e->ToString());
		return false;
	}
}