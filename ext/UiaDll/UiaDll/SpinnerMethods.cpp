#include "stdafx.h"
#include "Locator.h"
#include "StringHelper.h"

using namespace RAutomation::UIA::Controls;

extern "C" {
	__declspec (dllexport) double Spinner_GetValue(const FindInformation& findInformation, char* errorInfo, const int errorInfoLength) {
		try {
			auto spinner = gcnew Spinner(Locator::FindFor(findInformation));
      return spinner->Value;
		} catch(Exception^ e) {
			StringHelper::CopyToUnmanagedString(e->Message, errorInfo, errorInfoLength);
		}
	}

	__declspec (dllexport) void Spinner_SetValue(const FindInformation& findInformation, double theValue, char* errorInfo, const int errorInfoLength) {
		try {
			auto spinner = gcnew Spinner(Locator::FindFor(findInformation));
      spinner->Value = theValue;
		} catch(Exception^ e) {
			StringHelper::CopyToUnmanagedString(e->Message, errorInfo, errorInfoLength);
		}
	}

	__declspec (dllexport) double Spinner_Increment(const FindInformation& findInformation, char* errorInfo, const int errorInfoLength) {
		try {
			auto spinner = gcnew Spinner(Locator::FindFor(findInformation));
      return spinner->Increment();
		} catch(Exception^ e) {
			StringHelper::CopyToUnmanagedString(e->Message, errorInfo, errorInfoLength);
		}
	}

	__declspec (dllexport) double Spinner_Decrement(const FindInformation& findInformation, char* errorInfo, const int errorInfoLength) {
		try {
			auto spinner = gcnew Spinner(Locator::FindFor(findInformation));
      return spinner->Decrement();
		} catch(Exception^ e) {
			StringHelper::CopyToUnmanagedString(e->Message, errorInfo, errorInfoLength);
		}
	}
}