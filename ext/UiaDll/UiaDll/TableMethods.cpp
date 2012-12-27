#include "stdafx.h"
#include "AutomatedTable.h"

extern "C" {

	__declspec ( dllexport ) int RA_GetDataItemCount(const HWND windowHandle) {
		try {
			auto tableControl = gcnew AutomatedTable(windowHandle);
			return tableControl->RowCount;
		} catch(Exception^ e) {
			Console::WriteLine(e->ToString());
		}
	}

	__declspec ( dllexport ) bool RA_DataItemExists(const HWND windowHandle, const int whichItemIndex, const int whichColumnIndex) {
		try {
			auto tableControl = gcnew AutomatedTable(windowHandle);
			return tableControl->Exists(whichItemIndex, whichColumnIndex);
		} catch(Exception^ e) {
			Console::WriteLine(e->ToString());
			return false;
		}
	}

	__declspec ( dllexport ) void RA_CellValueAt(const HWND windowHandle, const int row, const int column, char *foundValue, const int foundValueLength) {
		try {
			auto tableControl = gcnew AutomatedTable(windowHandle);
			auto rowValue = tableControl->ValueAt(row, column);
			StringHelper::CopyToUnmanagedString(rowValue, foundValue, foundValueLength);
		} catch(Exception^ e) {
			Console::WriteLine(e->ToString());
		}
	}

	__declspec ( dllexport ) void RA_SelectDataItem(const HWND windowHandle, const int dataItemIndex) {
		try {
			auto tableControl = gcnew AutomatedTable(windowHandle);
			tableControl->Select(dataItemIndex);
		} catch(Exception^ e) {
			Console::WriteLine(e->ToString());
		}
	}

	__declspec ( dllexport ) bool RA_IsDataItemSelected(const HWND windowHandle, const int dataItemIndex) {
		try {
			auto tableControl = gcnew AutomatedTable(windowHandle);
			return tableControl->IsSelected(dataItemIndex);
		} catch(Exception^ e) {
			Console::WriteLine(e->ToString());
		}
	}

	__declspec ( dllexport ) void RA_SelectDataItemByValue(const HWND windowHandle, const char* dataItemValue) {
		try {
			auto tableControl = gcnew AutomatedTable(windowHandle);
			tableControl->Select(dataItemValue);
		} catch(Exception^ e) {
			Console::WriteLine(e->ToString());
		}
	}
}