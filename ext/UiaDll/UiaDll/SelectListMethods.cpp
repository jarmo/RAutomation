#include "stdafx.h"
#include "AutomationFinder.h"
#include "AutomatedSelectList.h"

using namespace RAutomation::UIA::Controls;

extern "C" {

	__declspec ( dllexport ) int SelectList_Count(const FindInformation& findInformation) {
		auto autoSelectList = gcnew AutomatedSelectList(findInformation);
		return autoSelectList->Count;
	}

  __declspec ( dllexport ) int SelectList_Options(const FindInformation& findInformation, const char* options[]) {
    auto selectList = gcnew SelectList(AutomationFinder::FindFor(findInformation));
    return StringHelper::Copy(selectList->Options, options);
  }

	__declspec ( dllexport ) int SelectList_SelectedIndex(const FindInformation& findInformation) {
    auto selectList = gcnew SelectList(AutomationFinder::FindFor(findInformation));
		return selectList->SelectedIndex;
	}

  __declspec ( dllexport ) void SelectList_Selection(const FindInformation& findInformation, char* selection, const int selectionLength) {
    auto selectList = gcnew AutomatedSelectList(findInformation);
    auto currentSelections = selectList->Selection;
    auto firstSelection = currentSelections.Length == 0 ? "" : currentSelections[0];
    StringHelper::CopyToUnmanagedString(firstSelection, selection, selectionLength);
  }

	__declspec ( dllexport ) bool SelectList_ValueAt(const FindInformation& findInformation, const int whichItem, char* comboValue, const int comboValueSize) {
		auto autoSelectList = gcnew AutomatedSelectList(findInformation);
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