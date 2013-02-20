#include "StdAfx.h"
#include "AutomationControl.h"


AutomationControl::AutomationControl(const HWND windowHandle)
{
	_control = AutomationElement::FromHandle(IntPtr(windowHandle));
}

void AutomationControl::Value::set(String^ value) {
	dynamic_cast<ValuePattern^>(_control->GetCurrentPattern(ValuePattern::Pattern))->SetValue(value);
}

String^ AutomationControl::Value::get() {
	return dynamic_cast<ValuePattern^>(_control->GetCurrentPattern(ValuePattern::Pattern))->Current.Value;
}