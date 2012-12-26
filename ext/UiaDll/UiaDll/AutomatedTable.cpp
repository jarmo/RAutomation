#include "StdAfx.h"
#include "AutomatedTable.h"

AutomatedTable::AutomatedTable(const HWND windowHandle)
{
	_tableControl = AutomationElement::FromHandle(IntPtr(windowHandle));
}

int AutomatedTable::RowCount::get()
{
	auto tablePattern = dynamic_cast<TablePattern^>(_tableControl->GetCurrentPattern(TablePattern::Pattern));
	return tablePattern->Current.RowCount;
}

bool AutomatedTable::Exists(const int whichItemIndex, const char* whichItem)
{
	try {
		return nullptr != FindDataItem(gcnew PropertyCondition(AutomationElement::NameProperty, gcnew String(whichItem)))[whichItemIndex];
	} catch(Exception^ e) {
	}

	return false;
}

bool AutomatedTable::Exists(const int whichItemIndex, const int whichColumnIndex)
{
	return nullptr != DataItemAt(whichItemIndex, whichColumnIndex);
}

String^ AutomatedTable::ValueAt(const int whichItemIndex, const int whichItemColumn)
{
	return DataItemAt(whichItemIndex, whichItemColumn)->Current.Name;
}

AutomationElement^ AutomatedTable::DataItemAt(const int whichItemIndex, const int whichItemColumn)
{
	auto dataItemProperty = gcnew PropertyCondition(AutomationElement::IsTableItemPatternAvailableProperty, true);
	auto indexProperty = gcnew PropertyCondition(TableItemPattern::RowProperty, whichItemIndex);
	auto columnProperty = gcnew PropertyCondition(TableItemPattern::ColumnProperty, whichItemColumn);
	return _tableControl->FindFirst(System::Windows::Automation::TreeScope::Subtree, gcnew AndCondition(dataItemProperty, indexProperty, columnProperty));
}

bool AutomatedTable::Exists(Condition^ condition)
{
	return FindTableItem(condition)->Count > 0;
}

AutomationElementCollection^ AutomatedTable::FindTableItem(Condition^ condition)
{
	auto tableItemProperty = gcnew PropertyCondition(AutomationElement::IsTableItemPatternAvailableProperty, true);
	return _tableControl->FindAll(System::Windows::Automation::TreeScope::Subtree, gcnew AndCondition(tableItemProperty, condition));
}

AutomationElementCollection^ AutomatedTable::FindDataItem()
{
	return FindDataItem(Condition::TrueCondition);
}

AutomationElementCollection^ AutomatedTable::FindDataItem(Condition^ condition)
{
	auto dataItemProperty = gcnew PropertyCondition(AutomationElement::ControlTypeProperty, ControlType::DataItem);
	return _tableControl->FindAll(System::Windows::Automation::TreeScope::Subtree, gcnew AndCondition(dataItemProperty, condition));
}

void AutomatedTable::Select(const int dataItemIndex)
{
	try {
		Select(FindDataItem()[dataItemIndex]);
	} catch(IndexOutOfRangeException^ e) {
		throw gcnew ArgumentException(String::Format("Table item at index {0} does not exist", dataItemIndex));
	}
}

void AutomatedTable::Select(const char* dataItemValue)
{
	try {
		auto nameCondition = gcnew PropertyCondition(AutomationElement::NameProperty, gcnew String(dataItemValue));
		Select(FindDataItem(nameCondition)[0]);
	} catch(IndexOutOfRangeException^ e) {
		throw gcnew ArgumentException(String::Format("Table item with the value \"{0}\" was not found", gcnew String(dataItemValue)));
	}
}

void AutomatedTable::Select(AutomationElement^ dataItem)
{
	auto selectionItemPattern = dynamic_cast<SelectionItemPattern^>(dataItem->GetCurrentPattern(SelectionItemPattern::Pattern));
	selectionItemPattern->Select();
}