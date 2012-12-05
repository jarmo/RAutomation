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

int AutomatedTable::ColumnCount::get()
{
	auto tablePattern = dynamic_cast<TablePattern^>(_tableControl->GetCurrentPattern(TablePattern::Pattern));
	return tablePattern->Current.ColumnCount;
}

void AutomatedTable::Select(const int dataItemIndex)
{
	auto selectionItemPattern = dynamic_cast<SelectionItemPattern^>(DataItemAt(dataItemIndex)->GetCurrentPattern(SelectionItemPattern::Pattern));
	selectionItemPattern->Select();
}

String^ AutomatedTable::ValueAt(const int dataRow)
{
	return DataItemAt(dataRow)->Current.Name;
}

String^ AutomatedTable::CellValueAt(const int dataRow, const int dataColumn)
{
	auto dataItemProperty = gcnew PropertyCondition(AutomationElement::IsTableItemPatternAvailableProperty, true);
	auto rowProperty = gcnew PropertyCondition(TableItemPattern::RowProperty, dataRow);
	auto columnProperty = gcnew PropertyCondition(TableItemPattern::ColumnProperty, dataColumn);
	auto allTogetherNow = gcnew AndCondition(dataItemProperty, rowProperty, columnProperty);

	return _tableControl->FindFirst(System::Windows::Automation::TreeScope::Subtree, allTogetherNow)->Current.Name;
}

AutomationElement^ AutomatedTable::DataItemAt(const int row)
{
	auto dataItemProperty = gcnew PropertyCondition(AutomationElement::ControlTypeProperty, ControlType::DataItem);
	return _tableControl->FindAll(System::Windows::Automation::TreeScope::Subtree, dataItemProperty)[row];
}