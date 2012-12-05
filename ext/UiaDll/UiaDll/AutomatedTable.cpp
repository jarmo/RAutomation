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
	auto dataItemProperty = gcnew PropertyCondition(AutomationElement::ControlTypeProperty, ControlType::DataItem);
	auto dataItem = _tableControl->FindAll(System::Windows::Automation::TreeScope::Subtree, dataItemProperty)[dataItemIndex];
	auto selectionItemPattern = dynamic_cast<SelectionItemPattern^>(dataItem->GetCurrentPattern(SelectionItemPattern::Pattern));
	selectionItemPattern->Select();
}

String^ AutomatedTable::ValueAt(const int dataRow)
{
	auto dataItemProperty = gcnew PropertyCondition(AutomationElement::ControlTypeProperty, ControlType::DataItem);
	auto dataItem = _tableControl->FindAll(System::Windows::Automation::TreeScope::Subtree, dataItemProperty)[dataRow];
	return dataItem->Current.Name;
}

String^ AutomatedTable::CellValueAt(const int dataRow, const int dataColumn)
{
	auto dataItemProperty = gcnew PropertyCondition(AutomationElement::IsTableItemPatternAvailableProperty, true);
	auto rowProperty = gcnew PropertyCondition(TableItemPattern::RowProperty, dataRow);
	auto columnProperty = gcnew PropertyCondition(TableItemPattern::ColumnProperty, dataColumn);
	auto allTogetherNow = gcnew AndCondition(dataItemProperty, rowProperty, columnProperty);

	return _tableControl->FindFirst(System::Windows::Automation::TreeScope::Subtree, allTogetherNow)->Current.Name;
}