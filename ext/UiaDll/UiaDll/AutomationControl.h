#pragma once

using namespace System::Windows::Automation;

ref class AutomationControl
{
public:
	AutomationControl(const HWND windowHandle);

	property String^ Name {
		String^ get() { return _control->Current.Name; }
	}

private:
	AutomationElement^ _control;
};

