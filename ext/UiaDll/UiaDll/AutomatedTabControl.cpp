#include "StdAfx.h"
#include "AutomatedTabControl.h"

AutomatedTabControl::AutomatedTabControl(const FindInformation& findInformation) : AutomationControl(findInformation)
{}


int AutomatedTabControl::GetTabItems(const char* options[])
{
	auto tabItems = TabItems;

  if( NULL != options ) {
	  StringHelper::CopyNames(tabItems, options);
  }

  return tabItems->Count;
}