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
		} catch(Exception^ e) {
			StringHelper::CopyToUnmanagedString(e->Message + e->StackTrace, errorInfo, errorInfoLength);
		}
	}
}
