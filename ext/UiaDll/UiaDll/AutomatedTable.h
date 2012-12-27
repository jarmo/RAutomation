#pragma once
using namespace System::Windows::Automation;

ref class AutomatedTable
{
public:
	AutomatedTable(const HWND windowHandle);
	bool Exists(const int whichItemIndex, const int whichColumnIndex);
	String^ ValueAt(const int whichItemIndex, const int whichColumnIndex);
	void Select(const int dataItemIndex);
	void Select(const char* dataItemValue);
	bool IsSelected(const int dataItemIndex);

	property int RowCount {
		int get();
	}

private:
	AutomationElement^ _tableControl;
	bool Exists(Condition^ condition);
	AutomationElement^ DataItemAt(const int whichItemIndex, const int whichItemRow);
	AutomationElementCollection^ Find(...array<Condition^>^	conditions);
	void Select(AutomationElement^ dataItem);

	property Condition^ IsSelectionItem {
		Condition^ get() {
			return gcnew PropertyCondition(AutomationElement::IsSelectionItemPatternAvailableProperty, true);
		}
	}

	property Condition^ IsTableItem {
		Condition^ get() {
			return gcnew PropertyCondition(AutomationElement::IsTableItemPatternAvailableProperty, true);
		}
	}

	property Condition^ IsDataItem {
		Condition^ get() {
			return gcnew PropertyCondition(AutomationElement::ControlTypeProperty, ControlType::DataItem);
		}
	}

	SelectionItemPattern^ AsSelectionItem(AutomationElement^ automationElement) {
		return dynamic_cast<SelectionItemPattern^>(automationElement->GetCurrentPattern(SelectionItemPattern::Pattern));
	}
};

