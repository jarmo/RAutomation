#include "StdAfx.h"
#include "SelectionItem.h"

SelectionItem::SelectionItem(const HWND windowHandle) : AutomationControl(windowHandle)
{
}

SelectionItem::SelectionItem(const FindInformation& findInformation) : AutomationControl(findInformation)
{
}