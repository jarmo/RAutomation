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
	return _tableControl->FindFirst(System::Windows::Automation::TreeScope::Subtree, gcnew AndCondition(IsTableItem, indexProperty, columnProperty));
}

bool AutomatedTable::Exists(Condition^ condition)
{
	return Find(IsTableItem, condition)->Count > 0;
}

AutomationElementCollection^ AutomatedTable::Find(...array<Condition^>^	conditions)
{
	auto numberOfConditions = conditions->Length;
	Array::Resize(conditions, numberOfConditions + 1);
	conditions[numberOfConditions] = Condition::TrueCondition;
	return _tableControl->FindAll(System::Windows::Automation::TreeScope::Subtree, gcnew AndCondition(conditions));
}

void AutomatedTable::Select(const int dataItemIndex)
{
	try {
		Select(Find(IsDataItem)[dataItemIndex]);
	} catch(IndexOutOfRangeException^ e) {
		throw gcnew ArgumentException(String::Format("Table item at index {0} does not exist", dataItemIndex));
	}
}

bool AutomatedTable::IsSelected(const int dataItemIndex) {
	auto automationElement = _tableControl->FindAll(System::Windows::Automation::TreeScope::Subtree, IsSelectionItem)[dataItemIndex
 ];
	return AsSelectionItem(automationElement)->Current.IsSelected;
}

void AutomatedTable::Select(const char* dataItemValue)
{
	try {
		auto nameCondition = gcnew PropertyCondition(AutomationElement::NameProperty, gcnew String(dataItemValue));
		Select(Find(IsDataItem, nameCondition)[0]);
	} catch(IndexOutOfRangeException^ e) {
		throw gcnew ArgumentException(String::Format("Table item with the value \"{0}\" was not found", gcnew String(dataItemValue)));
	}
}

void AutomatedTable::Select(AutomationElement^ dataItem)
{
	auto selectionItemPattern = dynamic_cast<SelectionItemPattern^>(dataItem->GetCurrentPattern(SelectionItemPattern::Pattern));
	selectionItemPattern->Select();
}