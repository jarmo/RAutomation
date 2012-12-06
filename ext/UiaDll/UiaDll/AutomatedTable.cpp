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

bool AutomatedTable::Exists(const int whichItemIndex)
{
	return Exists(gcnew PropertyCondition(TableItemPattern::RowProperty, whichItemIndex));
}

String^ AutomatedTable::ValueAt(const int dataRow)
{
	return DataItemAt(dataRow)->Current.Name;
}

AutomationElement^ AutomatedTable::DataItemAt(const int whichItemIndex)
{
	auto dataItemProperty = gcnew PropertyCondition(AutomationElement::IsTableItemPatternAvailableProperty, true);
	auto indexProperty = gcnew PropertyCondition(TableItemPattern::RowProperty, whichItemIndex);
	return _tableControl->FindFirst(System::Windows::Automation::TreeScope::Subtree, gcnew AndCondition(dataItemProperty, indexProperty));
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