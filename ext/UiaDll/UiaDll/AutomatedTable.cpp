#include "StdAfx.h"
#include "AutomatedTable.h"

AutomatedTable::AutomatedTable(const HWND windowHandle) : AutomationControl(windowHandle)
{
	_finder = gcnew AutomationFinder(_control);
}

AutomatedTable::AutomatedTable(const FindInformation& finderInformation) : AutomationControl(finderInformation)
{
	_finder = gcnew AutomationFinder(_control);
}

int AutomatedTable::GetHeaders(const char* headers[])
{
	auto headerItems = _finder->Find(AutomationFinder::IsHeaderItem);

	if( NULL != headers ) {
		StringHelper::CopyNames(headerItems, headers);
	}

	return headerItems->Count;
}

int AutomatedTable::GetValues(const char* values[])
{
	auto tableItems = _finder->Find(gcnew OrCondition(AutomationFinder::IsTableItem, AutomationFinder::IsListItem));

	if( NULL != values ) {
		StringHelper::CopyNames(tableItems, values);
	}

	return tableItems->Count;
}

int AutomatedTable::RowCount::get()
{
	auto tablePattern = dynamic_cast<TablePattern^>(_control->GetCurrentPattern(TablePattern::Pattern));
	return tablePattern->Current.RowCount;
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
	auto indexProperty = gcnew PropertyCondition(TableItemPattern::RowProperty, whichItemIndex);
	auto columnProperty = gcnew PropertyCondition(TableItemPattern::ColumnProperty, whichItemColumn);
	return _finder->FindFirst(AutomationFinder::IsTableItem, indexProperty, columnProperty);
}

bool AutomatedTable::Exists(Condition^ condition)
{
	return _finder->Find(AutomationFinder::IsTableItem, condition)->Count > 0;
}

void AutomatedTable::Select(const int dataItemIndex)
{
	try {
		Select(_finder->Find(AutomationFinder::IsDataItem)[dataItemIndex]);
	} catch(IndexOutOfRangeException^) {
		throw gcnew ArgumentException(String::Format("Table item at index {0} does not exist", dataItemIndex));
	}
}

bool AutomatedTable::IsSelected(const int dataItemIndex) {
	
	return AsSelectionItem(_finder->FindAt(dataItemIndex, AutomationFinder::IsSelectionItem))->Current.IsSelected;
}

void AutomatedTable::Select(const char* dataItemValue)
{
	try {
		auto nameCondition = gcnew PropertyCondition(AutomationElement::NameProperty, gcnew String(dataItemValue));
		Select(_finder->Find(AutomationFinder::IsDataItem, nameCondition)[0]);
	} catch(IndexOutOfRangeException^) {
		throw gcnew ArgumentException(String::Format("Table item with the value \"{0}\" was not found", gcnew String(dataItemValue)));
	}
}

void AutomatedTable::Select(AutomationElement^ dataItem)
{
	auto selectionItemPattern = dynamic_cast<SelectionItemPattern^>(dataItem->GetCurrentPattern(SelectionItemPattern::Pattern));
	selectionItemPattern->Select();
}