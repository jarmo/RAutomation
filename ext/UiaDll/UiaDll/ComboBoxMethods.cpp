#include "stdafx.h"
#include "AutomatedComboBox.h"

extern "C" {

	__declspec ( dllexport ) int RA_GetComboOptionsCount(const HWND windowHandle) {
		auto autoComboBox = gcnew AutomatedComboBox(windowHandle);
		return autoComboBox->Count;
	}

	__declspec ( dllexport ) int RA_GetSelectedComboIndex(const HWND windowHandle) {
		auto autoComboBox = gcnew AutomatedComboBox(windowHandle);
		return autoComboBox->SelectedIndex;
	}

	__declspec ( dllexport ) bool RA_GetComboValueByIndex(const HWND windowHandle, const int whichItem, char* comboValue, const int comboValueSize) {
		auto autoComboBox = gcnew AutomatedComboBox(windowHandle);
		return autoComboBox->GetValueByIndex(whichItem, comboValue, comboValueSize);
	}

	__declspec ( dllexport ) bool RA_SelectComboByIndex(const HWND windowHandle, const int whichItem) {
		auto autoComboBox = gcnew AutomatedComboBox(windowHandle);
		return autoComboBox->SelectByIndex(whichItem);
	}

	__declspec ( dllexport ) int RA_SelectComboByValue(IUIAutomationElement *pElement, char *pValue) {
		UIA_HWND windowHandle = 0;
		pElement->get_CurrentNativeWindowHandle(&windowHandle);

		auto autoComboBox = gcnew AutomatedComboBox((const HWND) windowHandle);
		return autoComboBox->SelectByValue(pValue);
	}
}