#include "StdAfx.h"
#include "AutomatedTabControl.h"

AutomatedTabControl::AutomatedTabControl(const FindInformation& findInformation) : AutomationControl(findInformation)
{}

String^ AutomatedTabControl::Selection::get()
{
	auto theSelection = AsSelectionPattern->Current.GetSelection()[0];
	return theSelection->Current.Name;
}

void AutomatedTabControl::Selection::set(String^ value)
{
	Select(_control->FindFirst(UIA::TreeScope::Subtree, GetNamedTabItemCondition(value)));
}

void AutomatedTabControl::SelectedIndex::set(int selectedIndex)
{
	Select(TabItems[selectedIndex]);
}

int AutomatedTabControl::SelectedIndex::get()
{
	int selectedIndex = 0;
	for each(AutomationElement^ selectionItem in TabItems) {
		auto selectionPattern = dynamic_cast<SelectionItemPattern^>(selectionItem->GetCurrentPattern(SelectionItemPattern::Pattern));
		if( selectionPattern->Current.IsSelected ) {
			return selectedIndex;
		}
		++selectedIndex;
	}
	return -1;
}

int AutomatedTabControl::GetTabItems(const char* options[])
{
	auto tabItems = TabItems;

	if( NULL != options ) {
		StringHelper::CopyNames(tabItems, options);
	}

	return tabItems->Count;
}