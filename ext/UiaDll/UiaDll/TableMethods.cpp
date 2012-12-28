#include "stdafx.h"
#include "AutomatedTable.h"

extern "C" {

	__declspec ( dllexport ) int Table_GetHeaders(const HWND windowHandle, const char* headers[]) {
		auto tableControl = gcnew AutomatedTable(windowHandle);
		return tableControl->GetHeaders(headers);
	}

	__declspec ( dllexport ) int Table_GetValues(const HWND windowHandle, const char* values[]) {
		auto tableControl = gcnew AutomatedTable(windowHandle);
		return tableControl->GetValues(values);
	}

	__declspec ( dllexport ) int Table_RowCount(const HWND windowHandle) {
		try {
			auto tableControl = gcnew AutomatedTable(windowHandle);
			return tableControl->RowCount;
		} catch(Exception^ e) {
			Console::WriteLine(e->ToString());
		}
	}

	__declspec ( dllexport ) bool Table_CoordinateIsValid(const HWND windowHandle, const int whichItemIndex, const int whichColumnIndex) {
		try {
			auto tableControl = gcnew AutomatedTable(windowHandle);
			return tableControl->Exists(whichItemIndex, whichColumnIndex);
		} catch(Exception^ e) {
			Console::WriteLine(e->ToString());
			return false;
		}
	}

	__declspec ( dllexport ) void Table_ValueAt(const HWND windowHandle, const int row, const int column, char *foundValue, const int foundValueLength) {
		try {
			auto tableControl = gcnew AutomatedTable(windowHandle);
			auto rowValue = tableControl->ValueAt(row, column);
			StringHelper::CopyToUnmanagedString(rowValue, foundValue, foundValueLength);
		} catch(Exception^ e) {
			Console::WriteLine(e->ToString());
		}
	}

	__declspec ( dllexport ) void Table_SelectByIndex(const HWND windowHandle, const int dataItemIndex) {
		try {
			auto tableControl = gcnew AutomatedTable(windowHandle);
			tableControl->Select(dataItemIndex);
		} catch(Exception^ e) {
			Console::WriteLine(e->ToString());
		}
	}

	__declspec ( dllexport ) bool Table_IsSelectedByIndex(const HWND windowHandle, const int dataItemIndex) {
		try {
			auto tableControl = gcnew AutomatedTable(windowHandle);
			return tableControl->IsSelected(dataItemIndex);
		} catch(Exception^ e) {
			Console::WriteLine(e->ToString());
		}
	}

	__declspec ( dllexport ) void Table_SelectByValue(const HWND windowHandle, const char* dataItemValue) {
		try {
			auto tableControl = gcnew AutomatedTable(windowHandle);
			tableControl->Select(dataItemValue);
		} catch(Exception^ e) {
			Console::WriteLine(e->ToString());
		}
	}
}