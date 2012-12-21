#pragma once
using namespace System::Windows::Automation;

ref class AutomationClicker
{
public:
	AutomationClicker(const HWND windowHandle);
	void Click();

private:
	AutomationElement^	_automationElement;

	bool CanInvoke();
	void Invoke();

	bool CanToggle();
	void Toggle();

	bool CanSelect();
	void Select();
};