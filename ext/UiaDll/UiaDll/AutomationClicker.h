#pragma once
using namespace System::Windows::Automation;
using namespace System::Windows::Forms;
using namespace System::Drawing;

#include "AutomationControl.h"

ref class AutomationClicker : AutomationControl
{
public:
  AutomationClicker(const HWND windowHandle) : AutomationControl(windowHandle) {}
  AutomationClicker(const FindInformation& findInformation) : AutomationControl(findInformation) {}
  AutomationClicker(AutomationElement^ automationElement) : AutomationControl(automationElement) {}
	bool Click();
	void MouseClick();

  static void MouseClickOn(AutomationElement^ automationElement) {
    (gcnew AutomationClicker(automationElement))->MouseClick();
  }

private:
	bool CanInvoke();
	void Invoke();

	bool CanToggle();
	void Toggle();

	bool CanSelect();
	void Select();
};