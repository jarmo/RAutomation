#include "StdAfx.h"
#include "AutomationControl.h"


AutomationControl::AutomationControl(const HWND windowHandle)
{
	_control = AutomationElement::FromHandle(IntPtr(windowHandle));
}

void AutomationControl::Value::set(String^ value) {
	AsValuePattern->SetValue(value);
}

String^ AutomationControl::Value::get() {
	return AsValuePattern->Current.Value;
}