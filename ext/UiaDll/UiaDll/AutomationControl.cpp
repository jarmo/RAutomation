#include "StdAfx.h"
#include "AutomationControl.h"
#include "AutomationFinder.h"

AutomationControl::AutomationControl(const HWND windowHandle)
{
	_control = AutomationElement::FromHandle(IntPtr(windowHandle));
}

AutomationControl::AutomationControl(const FindInformation& findInformation)
{
	try {
		auto rootElement = AutomationElement::FromHandle(IntPtr(findInformation.rootWindow));
		auto finder = gcnew AutomationFinder(rootElement);
		_control = finder->Find(findInformation);
	}
	catch(Exception^ e) {
		Debug::WriteLine("AutomationControl error:  {0}", e->Message);
	}
}

void AutomationControl::Value::set(String^ value) {
	AsValuePattern->SetValue(value);
}

String^ AutomationControl::Value::get() {
	return AsValuePattern->Current.Value;
}