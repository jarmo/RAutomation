#pragma once
#include "automationcontrol.h"
ref class SelectionItem :
public AutomationControl
{
public:
  SelectionItem(const HWND windowHandle);
  SelectionItem(const FindInformation& findInformation);

  property bool IsSelected {
    bool get() { return AsSelectionItemPattern->Current.IsSelected; }
  }

private:
	property SelectionItemPattern^ AsSelectionItemPattern {
		SelectionItemPattern^ get() {
			return dynamic_cast<SelectionItemPattern^>(_control->GetCurrentPattern(SelectionItemPattern::Pattern));
		}
	}
};

