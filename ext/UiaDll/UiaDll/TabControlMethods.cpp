#include "stdafx.h"
#include "AutomationFinder.h"
#include "StringHelper.h"

using namespace RAutomation::UIA::Controls;

extern "C" {
	__declspec(dllexport) int TabControl_Items(const FindInformation& findInformation, const char* options[]) {
		auto tabControl = gcnew TabControl(AutomationFinder::FindFor(findInformation));
		return StringHelper::Copy(tabControl->TabNames, options);
	}

	__declspec(dllexport) void TabControl_Selection(const FindInformation& findInformation, char* selection, const int selectionLength) {
		auto tabControl = gcnew TabControl(AutomationFinder::FindFor(findInformation));
		StringHelper::CopyToUnmanagedString(tabControl->Selection, selection, selectionLength);
	}

	__declspec(dllexport) void TabControl_SelectByIndex(const FindInformation& findInformation, const int index, char* errorInfo, const int errorInfoLength) {
		try {
      auto tabControl = gcnew TabControl(AutomationFinder::FindFor(findInformation));
      return tabControl->SelectedIndex = index;
		} catch(Exception^) {
			_snprintf(errorInfo, errorInfoLength, "A tab with index %d was not found", index);
		}
	}

	__declspec(dllexport) int TabControl_SelectedIndex(const FindInformation& findInformation) {
		auto tabControl = gcnew TabControl(AutomationFinder::FindFor(findInformation));
		return tabControl->SelectedIndex;
	}

	__declspec(dllexport) void TabControl_SelectByValue(const FindInformation& findInformation, const char* value, char* errorInfo, const int errorInfoLength) {
		try {
      auto tabControl = gcnew TabControl(AutomationFinder::FindFor(findInformation));
			tabControl->Selection = gcnew String(value);
		} catch(Exception^) {
			_snprintf(errorInfo, errorInfoLength, "A tab with the value %s was not found", value);
		}
	}
}
