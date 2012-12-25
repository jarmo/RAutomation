#pragma once
using namespace System::Windows::Automation;
using namespace System::Windows::Forms;
using namespace System::Drawing;

ref class AutomationClicker
{
public:
	AutomationClicker(const HWND windowHandle);
	void Click();
	void MouseClick();

private:
	AutomationElement^	_automationElement;

	bool CanInvoke();
	void Invoke();

	bool CanToggle();
	void Toggle();

	bool CanSelect();
	void Select();
};