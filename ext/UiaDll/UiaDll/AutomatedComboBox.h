#pragma once
using namespace System::Windows::Automation;

public ref class AutomatedComboBox
{
public:
	AutomatedComboBox(const HWND windowHandle);
	bool SelectByIndex(const int whichItem);

private:
	AutomationElement^	_comboControl;
};

