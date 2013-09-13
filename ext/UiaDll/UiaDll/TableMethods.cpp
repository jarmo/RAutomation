#include "stdafx.h"
#include "Locator.h"
#include "StringHelper.h"

using namespace RAutomation::UIA::Controls;

extern "C" {

	__declspec ( dllexport ) int Table_GetHeaders(const FindInformation& findInformation, const char* headers[]) {
		auto tableControl = gcnew TableControl(Locator::FindFor(findInformation));
		return StringHelper::Copy(tableControl->Headers, headers);
	}

	__declspec ( dllexport ) int Table_GetValues(const FindInformation& findInformation, const char* values[]) {
		auto tableControl = gcnew TableControl(Locator::FindFor(findInformation));
		return StringHelper::Copy(tableControl->Values, values);
	}

	__declspec ( dllexport ) int Table_RowCount(const FindInformation& findInformation) {
		try {
			auto tableControl = gcnew TableControl(Locator::FindFor(findInformation));
			return tableControl->RowCount;
		} catch(Exception^ e) {
			Console::WriteLine(e->ToString());
      return 0;
		}
	}

	__declspec ( dllexport ) bool Table_CoordinateIsValid(const FindInformation& findInformation, const int whichItemIndex, const int whichColumnIndex) {
		try {
			auto tableControl = gcnew TableControl(Locator::FindFor(findInformation));
			return tableControl->Exists(whichItemIndex, whichColumnIndex);
		} catch(Exception^ e) {
			Console::WriteLine(e->ToString());
			return false;
		}
	}

	__declspec ( dllexport ) void Table_ValueAt(const FindInformation& findInformation, const int row, const int column, char *foundValue, const int foundValueLength) {
		try {
			auto tableControl = gcnew TableControl(Locator::FindFor(findInformation));
			StringHelper::CopyToUnmanagedString(tableControl->ValueAt(row, column), foundValue, foundValueLength);
		} catch(Exception^ e) {
			Console::WriteLine(e->ToString());
		}
	}

	__declspec ( dllexport ) void Table_SelectByIndex(const FindInformation& findInformation, const int dataItemIndex, char* errorInfo, const int errorInfoLength) {
		try {
			auto tableControl = gcnew TableControl(Locator::FindFor(findInformation));
			tableControl->SelectedIndex = dataItemIndex;
		} catch(Exception^ e) {
      StringHelper::Write(e, errorInfo, errorInfoLength);
		}
	}

  __declspec ( dllexport ) void Table_AddRowByIndex(const FindInformation& findInformation, const int dataItemIndex, char* errorInfo, const int errorInfoLength) {
    try {
      auto tableControl = gcnew TableControl(Locator::FindFor(findInformation));
      tableControl->Add(dataItemIndex);
    } catch(Exception^ e) {
      StringHelper::Write(e, errorInfo, errorInfoLength);
    }
  }

  __declspec ( dllexport ) void Table_AddRowByValue(const FindInformation& findInformation, const char* dataItemValue, char* errorInfo, const int errorInfoLength) {
    try {
      auto tableControl = gcnew TableControl(Locator::FindFor(findInformation));
      tableControl->Add(gcnew String(dataItemValue));
    } catch(Exception^ e) {
      StringHelper::Write(e, errorInfo, errorInfoLength);
    }
  }

  __declspec ( dllexport ) void Table_RemoveRowByIndex(const FindInformation& findInformation, const int dataItemIndex, char* errorInfo, const int errorInfoLength) {
    try {
      auto tableControl = gcnew TableControl(Locator::FindFor(findInformation));
      tableControl->Remove(dataItemIndex);
    } catch(Exception^ e) {
      StringHelper::Write(e, errorInfo, errorInfoLength);
    }
  }

  __declspec ( dllexport ) void Table_RemoveRowByValue(const FindInformation& findInformation, const char* dataItemValue, char* errorInfo, const int errorInfoLength) {
    try {
      auto tableControl = gcnew TableControl(Locator::FindFor(findInformation));
      tableControl->Remove(gcnew String(dataItemValue));
    } catch(Exception^ e) {
      StringHelper::Write(e, errorInfo, errorInfoLength);
    }
  }

	__declspec ( dllexport ) bool Table_IsSelectedByIndex(const FindInformation& findInformation, const int dataItemIndex) {
		try {
			auto tableControl = gcnew TableControl(Locator::FindFor(findInformation));
      return tableControl->IsRowSelected(dataItemIndex);
		} catch(Exception^ e) {
			Console::WriteLine(e->ToString());
      return false;
		}
	}

	__declspec ( dllexport ) void Table_SelectByValue(const FindInformation& findInformation, const char* dataItemValue, char* errorInfo, const int errorInfoLength) {
		try {
			auto tableControl = gcnew TableControl(Locator::FindFor(findInformation));
			tableControl->Value = gcnew String(dataItemValue);
		} catch(Exception^ e) {
      StringHelper::Write(e, errorInfo, errorInfoLength);
		}
	}
}