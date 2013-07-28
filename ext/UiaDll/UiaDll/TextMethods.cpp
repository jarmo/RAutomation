#include "stdafx.h"
#include "AutomationFinder.h"
#include "StringHelper.h"

using namespace RAutomation::UIA::Controls;

extern "C" {
	__declspec ( dllexport ) void Text_GetValue(const FindInformation& findInformation, char* theValue, const int maximumLength) {
		try {
			auto text =  gcnew TextControl(AutomationFinder::FindFor(findInformation));
			StringHelper::CopyToUnmanagedString(text->Value, theValue, maximumLength);
		} catch(Exception^ e) {
			Console::WriteLine("Text_GetValue:  {0}", e->Message);
		}
	}

	__declspec ( dllexport ) void Text_SetValue(const FindInformation& findInformation, const char* theValue) {
		try {
			auto text =  gcnew TextControl(AutomationFinder::FindFor(findInformation));
			text->Value = gcnew String(theValue);
		} catch(Exception^ e) {
			Console::WriteLine("Text_SetValue:  {0}", e->Message);
		}
	}
}