#include "StdAfx.h"
#include "AutomatedTabControl.h"

AutomatedTabControl::AutomatedTabControl(const FindInformation& findInformation) : AutomationControl(findInformation)
{}

String^ AutomatedTabControl::Selection::get()
{
	auto theSelection = AsSelectionPattern->Current.GetSelection()[0];
	return theSelection->Current.Name;
}

int AutomatedTabControl::GetTabItems(const char* options[])
{
	auto tabItems = TabItems;

  if( NULL != options ) {
	  StringHelper::CopyNames(tabItems, options);
  }

  return tabItems->Count;
}