#include "stdafx.h"
#include "AutomatedSelectList.h"

extern "C" {

	__declspec ( dllexport ) int RA_GetComboOptionsCount(const HWND windowHandle) {
		auto autoSelectList = gcnew AutomatedSelectList(windowHandle);
		return autoSelectList->Count;
	}

	__declspec ( dllexport ) int RA_GetSelectedComboIndex(const HWND windowHandle) {
		auto autoSelectList = gcnew AutomatedSelectList(windowHandle);
		return autoSelectList->SelectedIndex;
	}

	__declspec ( dllexport ) bool RA_GetComboValueByIndex(const HWND windowHandle, const int whichItem, char* comboValue, const int comboValueSize) {
		auto autoSelectList = gcnew AutomatedSelectList(windowHandle);
		return autoSelectList->GetValueByIndex(whichItem, comboValue, comboValueSize);
	}

	__declspec ( dllexport ) bool RA_SelectComboByIndex(const HWND windowHandle, const int whichItem) {
		auto autoSelectList = gcnew AutomatedSelectList(windowHandle);
		return autoSelectList->SelectByIndex(whichItem);
	}

	__declspec ( dllexport ) int RA_SelectComboByValue(IUIAutomationElement *pElement, char *pValue) {
		UIA_HWND windowHandle = 0;
		pElement->get_CurrentNativeWindowHandle(&windowHandle);

		auto autoSelectList = gcnew AutomatedSelectList((const HWND) windowHandle);
		return autoSelectList->SelectByValue(pValue);
	}
}