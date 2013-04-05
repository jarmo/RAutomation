#include "stdafx.h"
#include "AutomatedSelectList.h"

extern "C" {

	__declspec ( dllexport ) int SelectList_Count(const FindInformation& findInformation) {
		auto autoSelectList = gcnew AutomatedSelectList(findInformation);
		return autoSelectList->Count;
	}

	__declspec ( dllexport ) int SelectList_SelectedIndex(const HWND windowHandle) {
		auto autoSelectList = gcnew AutomatedSelectList(windowHandle);
		return autoSelectList->SelectedIndex;
	}

	__declspec ( dllexport ) bool SelectList_ValueAt(const HWND windowHandle, const int whichItem, char* comboValue, const int comboValueSize) {
		auto autoSelectList = gcnew AutomatedSelectList(windowHandle);
		return autoSelectList->GetValueByIndex(whichItem, comboValue, comboValueSize);
	}

	__declspec ( dllexport ) bool SelectList_SelectIndex(const FindInformation& findInformation, const int whichItem) {
		auto autoSelectList = gcnew AutomatedSelectList(findInformation);
		return autoSelectList->SelectByIndex(whichItem);
	}

	__declspec ( dllexport ) int SelectList_SelectValue(const FindInformation& findInformation, char *pValue) {
		auto autoSelectList = gcnew AutomatedSelectList(findInformation);
		return autoSelectList->SelectByValue(pValue);
	}
}