#include "stdafx.h"
#include "AutomationControl.h"
#include "StringHelper.h"

extern "C" {
	__declspec ( dllexport ) void Control_GetValue(const HWND windowHandle, char* theValue, const int maximumLength) {
		auto control = gcnew AutomationControl(windowHandle);
		StringHelper::CopyToUnmanagedString(control->Value, theValue, maximumLength);
	}

	__declspec ( dllexport ) void Control_SetValue(const HWND windowHandle, const char* theValue) {
		auto control = gcnew AutomationControl(windowHandle);
		control->Value = gcnew String(theValue);
	}
}