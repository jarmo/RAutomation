#include "stdafx.h"
#include "AutomatedTabControl.h"

extern "C" {
	__declspec(dllexport) int TabControl_Items(const FindInformation& findInformation, const char* options[]) {
		auto tabControl = gcnew AutomatedTabControl(findInformation);
		return tabControl->GetTabItems(options);
	}

	__declspec(dllexport) void TabControl_Selection(const FindInformation& findInformation, char* selection, const int selectionLength) {
		auto tabControl = gcnew AutomatedTabControl(findInformation);
		StringHelper::CopyToUnmanagedString(tabControl->Selection, selection, selectionLength);
	}

	__declspec(dllexport) void TabControl_SelectByIndex(const FindInformation& findInformation, const int index, char* errorInfo, const int errorInfoLength) {
		try {
			auto tabControl = gcnew AutomatedTabControl(findInformation);
			tabControl->SelectedIndex = index;
		} catch(Exception^) {
			_snprintf(errorInfo, errorInfoLength, "A tab with index %d was not found", index);
		}
	}

	__declspec(dllexport) int TabControl_SelectedIndex(const FindInformation& findInformation) {
		auto tabControl = gcnew AutomatedTabControl(findInformation);
		return tabControl->SelectedIndex;
	}

	__declspec(dllexport) void TabControl_SelectByValue(const FindInformation& findInformation, const char* value, char* errorInfo, const int errorInfoLength) {
		try {
			auto tabControl = gcnew AutomatedTabControl(findInformation);
			tabControl->Selection = gcnew String(value);
		} catch(Exception^) {
			_snprintf(errorInfo, errorInfoLength, "A tab with the value %s was not found", value);
		}
	}
}
