#pragma once

#include "automationcontrol.h"

using namespace System::Windows::Automation;
using namespace System::Windows::Forms;

ref class AutomatedText : public AutomationControl
{
public:
  AutomatedText(const HWND windowHandle) : AutomationControl(windowHandle) {}
  AutomatedText(const FindInformation& finderInformation) : AutomationControl(finderInformation) {}

  property String^ Text {
    String^ get();
    void set(String^ value);
  }

private:
	property TextPattern^ AsTextPattern {
		TextPattern^ get() {
			return dynamic_cast<TextPattern^>(_control->GetCurrentPattern(TextPattern::Pattern));
		}
	}
};

