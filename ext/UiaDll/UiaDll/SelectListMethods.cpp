#include "stdafx.h"
#include "Locator.h"
#include "StringHelper.h"

using namespace RAutomation::UIA::Controls;

extern "C" {

	__declspec ( dllexport ) int SelectList_Count(const FindInformation& findInformation) {
		auto selectList = gcnew SelectList(Locator::FindFor(findInformation));
		return selectList->Count;
	}

	__declspec ( dllexport ) int SelectList_Options(const FindInformation& findInformation, const char* options[]) {
		auto selectList = gcnew SelectList(Locator::FindFor(findInformation));
		return StringHelper::Copy(selectList->Options, options);
	}

	__declspec ( dllexport ) int SelectList_SelectedIndex(const FindInformation& findInformation) {
		auto selectList = gcnew SelectList(Locator::FindFor(findInformation));
		return selectList->SelectedIndex;
	}

	__declspec ( dllexport ) void SelectList_Selection(const FindInformation& findInformation, char* selection, const int selectionLength) {
		auto selectList = gcnew SelectList(Locator::FindFor(findInformation));
		StringHelper::CopyToUnmanagedString(selectList->Selection, selection, selectionLength);
	}

  __declspec ( dllexport ) int SelectList_Selections(const FindInformation& findInformation, const char* selections[]) {
		auto selectList = gcnew SelectList(Locator::FindFor(findInformation));
    return StringHelper::Copy(selectList->Selections, selections);
  }

	__declspec ( dllexport ) bool SelectList_ValueAt(const FindInformation& findInformation, const int whichItem, char* comboValue, const int comboValueSize) {
		try {
			auto selectList = gcnew SelectList(Locator::FindFor(findInformation));
			StringHelper::CopyToUnmanagedString(selectList->At(whichItem), comboValue, comboValueSize);
			return true;
		} catch(Exception^ e) {
			Console::WriteLine(e);
			return false;
		}
	}

  __declspec ( dllexport ) void SelectList_AddIndex(const FindInformation& findInformation, const int whichItem, char* errorInfo, const int errorInfoLength) {
    try {
      auto selectList = gcnew SelectList(Locator::FindFor(findInformation));
      selectList->Add(whichItem);
    } catch(Exception^ e) {
        StringHelper::Write(e, errorInfo, errorInfoLength);
    }
  }

  __declspec ( dllexport ) void SelectList_RemoveIndex(const FindInformation& findInformation, const int whichItem, char* errorInfo, const int errorInfoLength) {
    try {
      auto selectList = gcnew SelectList(Locator::FindFor(findInformation));
      selectList->Remove(whichItem);
    } catch(Exception^ e) {
        StringHelper::Write(e, errorInfo, errorInfoLength);
    }
  }

  __declspec ( dllexport ) void SelectList_AddValue(const FindInformation& findInformation, const char* whichItem, char* errorInfo, const int errorInfoLength) {
    try {
      auto selectList = gcnew SelectList(Locator::FindFor(findInformation));
      selectList->Add(gcnew String(whichItem));
    } catch(Exception^ e) {
        StringHelper::Write(e, errorInfo, errorInfoLength);
    }
  }

  __declspec ( dllexport ) void SelectList_RemoveValue(const FindInformation& findInformation, const char* whichItem, char* errorInfo, const int errorInfoLength) {
    try {
      auto selectList = gcnew SelectList(Locator::FindFor(findInformation));
      selectList->Remove(gcnew String(whichItem));
    } catch(Exception^ e) {
        StringHelper::Write(e, errorInfo, errorInfoLength);
    }
  }

	__declspec ( dllexport ) bool SelectList_SelectIndex(const FindInformation& findInformation, const int whichItem) {
		try {
			auto selectList = gcnew SelectList(Locator::FindFor(findInformation));
			selectList->SelectedIndex = whichItem;
			return true;
		} catch(Exception^ e) {
			Console::WriteLine(e);
			return false;
		}
	}

	__declspec ( dllexport ) int SelectList_SelectValue(const FindInformation& findInformation, char *pValue) {
		try {
			auto selectList = gcnew SelectList(Locator::FindFor(findInformation));
			selectList->Selection = gcnew String(pValue);
			return true;
		} catch(Exception^ e) {
			Console::WriteLine(e);
			return false;
		}
	}
}