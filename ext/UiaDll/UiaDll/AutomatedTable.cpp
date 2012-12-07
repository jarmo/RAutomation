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

bool AutomatedTable::Exists(const char* whichItem)
{
	return Exists(gcnew PropertyCondition(AutomationElement::NameProperty, gcnew String(whichItem)));
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
	auto dataItemProperty = gcnew PropertyCondition(AutomationElement::IsTableItemPatternAvailableProperty, true);
	return _tableControl->FindAll(System::Windows::Automation::TreeScope::Subtree, gcnew AndCondition(dataItemProperty, condition))->Count > 0;
}

void AutomatedTable::Select(const int dataItemIndex)
{
	auto dataItemProperty = gcnew PropertyCondition(AutomationElement::ControlTypeProperty, ControlType::DataItem);
	auto dataItem = _tableControl->FindAll(System::Windows::Automation::TreeScope::Subtree, dataItemProperty)[dataItemIndex];
	auto selectionItemPattern = dynamic_cast<SelectionItemPattern^>(dataItem->GetCurrentPattern(SelectionItemPattern::Pattern));
	selectionItemPattern->Select();
}