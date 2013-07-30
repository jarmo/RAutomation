#include "stdafx.h"
#include "Locator.h"
#include "StringHelper.h"

using namespace RAutomation::UIA::Extensions;

extern "C" {
	__declspec ( dllexport ) void Control_GetValue(const FindInformation& findInformation, char* theValue, const int maximumLength) {
		auto value = Element::Value(Locator::FindFor(findInformation));
		StringHelper::CopyToUnmanagedString(value, theValue, maximumLength);
	}

	__declspec ( dllexport ) void Control_SetValue(const FindInformation& findInformation, const char* theValue) {
		Element::SetValue(Locator::FindFor(findInformation), gcnew String(theValue));
	}
}