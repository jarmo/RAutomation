#include "StdAfx.h"
#include "AutomatedTabControl.h"

AutomatedTabControl::AutomatedTabControl(const FindInformation& findInformation) : AutomationControl(findInformation)
{}

String^ AutomatedTabControl::Selection::get()
{
	auto theSelection = AsSelectionPattern->Current.GetSelection()[0];
	return theSelection->Current.Name;
}

void AutomatedTabControl::SelectedIndex::set(int selectedIndex)
{
	dynamic_cast<SelectionItemPattern^>(TabItems[selectedIndex]->GetCurrentPattern(SelectionItemPattern::Pattern))->Select();
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