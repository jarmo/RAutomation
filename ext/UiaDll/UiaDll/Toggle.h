#pragma once
#include "AutomationControl.h"

ref class Toggle : public AutomationControl
{
public:
  Toggle(const HWND windowHandle) : AutomationControl(windowHandle) {}
  Toggle(const FindInformation& findInformation) : AutomationControl(findInformation) {}

  property bool IsSet {
    bool get() { return AsTogglePattern->Current.ToggleState == System::Windows::Automation::ToggleState::On; }
  }

private:
	property TogglePattern^ AsTogglePattern {
		TogglePattern^ get() {
			return dynamic_cast<TogglePattern^>(_control->GetCurrentPattern(TogglePattern::Pattern));
		}
	}
  
};

