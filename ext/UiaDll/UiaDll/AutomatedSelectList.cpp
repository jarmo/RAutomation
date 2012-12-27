#include "StdAfx.h"
#include "AutomatedSelectList.h"

AutomatedSelectList::AutomatedSelectList(const HWND windowHandle)
{
	_comboControl = AutomationElement::FromHandle(IntPtr(windowHandle));
}

bool AutomatedSelectList::SelectByIndex(const int whichItem)
{
	try {
	  auto selectionItems = _comboControl->FindAll(System::Windows::Automation::TreeScope::Subtree, SelectionCondition);
	  Select(selectionItems[whichItem]);
	  return true;
	} catch(Exception^ e) {
		Console::WriteLine(e->ToString());
		return false;
	}
}

bool AutomatedSelectList::SelectByValue(const char* whichItem)
{
	try {
	  auto nameCondition = gcnew PropertyCondition(AutomationElement::NameProperty, gcnew String(whichItem));
	  auto selectionAndNameCondition = gcnew AndCondition(SelectionCondition, nameCondition);

	  Select(_comboControl->FindFirst(System::Windows::Automation::TreeScope::Subtree, selectionAndNameCondition));
	  return true;
	} catch(Exception^ e) {
		Console::WriteLine(e->ToString());
		return false;
	}
}

bool AutomatedSelectList::GetValueByIndex(const int whichItem, char* comboValue, const int comboValueSize)
{
	try {
		auto selectionItem = SelectionItems[whichItem];
		auto nameProperty = dynamic_cast<String^>(selectionItem->GetCurrentPropertyValue(AutomationElement::NameProperty));

		StringHelper::CopyToUnmanagedString(nameProperty, comboValue, comboValueSize);
		return true;
	} catch(Exception^ e) {
		Console::WriteLine(e->ToString());
		return false;
	}
}

int AutomatedSelectList::SelectedIndex::get() {
	int selectedIndex = 0;
	for each(AutomationElement^ selectionItem in SelectionItems) {
	  auto selectionPattern = dynamic_cast<SelectionItemPattern^>(selectionItem->GetCurrentPattern(SelectionItemPattern::Pattern));
	  if( selectionPattern->Current.IsSelected ) {
		  return selectedIndex;
	  }
	  ++selectedIndex;
	}
	return -1;
}


void AutomatedSelectList::Select(AutomationElement^ itemToSelect)
{
	auto selectionPattern = dynamic_cast<SelectionItemPattern^>(itemToSelect->GetCurrentPattern(SelectionItemPattern::Pattern));
	selectionPattern->Select();
}