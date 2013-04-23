#include "stdafx.h"
#include "AutomationControl.h"
#include "StringHelper.h"

extern "C" {
	__declspec ( dllexport ) void Control_GetValue(const FindInformation& findInformation, char* theValue, const int maximumLength) {
		auto control = gcnew AutomationControl(findInformation);
		StringHelper::CopyToUnmanagedString(control->Value, theValue, maximumLength);
	}

	__declspec ( dllexport ) void Control_SetValue(const FindInformation& findInformation, const char* theValue) {
		auto control = gcnew AutomationControl(findInformation);
		control->Value = gcnew String(theValue);
	}
}