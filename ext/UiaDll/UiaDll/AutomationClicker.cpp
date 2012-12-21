#include "StdAfx.h"
#include "AutomationClicker.h"

AutomationClicker::AutomationClicker(const HWND windowHandle) {
	_automationElement = AutomationElement::FromHandle(IntPtr(windowHandle));
}

void AutomationClicker::Click() {
	if( CanInvoke() ) {
		return Invoke();
	} else if( CanToggle() ) {
		return Toggle();
	} else if( CanSelect() ) {
		return Select();
	}

	throw gcnew Exception(gcnew String("AutomationElement did not support the InvokePattern, TogglePattern or the SelectionItemPattern"));
}

void AutomationClicker::MouseClick() {
	_automationElement->SetFocus();
	auto clickablePoint = _automationElement->GetClickablePoint();
	Cursor::Position = Point((int)clickablePoint.X, (int)clickablePoint.Y);
	mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
	mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
}

bool AutomationClicker::CanInvoke() {
	return (bool)(_automationElement->GetCurrentPropertyValue(AutomationElement::IsInvokePatternAvailableProperty));
}

void AutomationClicker::Invoke() {
	dynamic_cast<InvokePattern^>(_automationElement->GetCurrentPattern(InvokePattern::Pattern))->Invoke();
}

bool AutomationClicker::CanToggle() {
	return (bool)(_automationElement->GetCurrentPropertyValue(AutomationElement::IsTogglePatternAvailableProperty));
}

void AutomationClicker::Toggle() {
	dynamic_cast<TogglePattern^>(_automationElement->GetCurrentPattern(TogglePattern::Pattern))->Toggle();
}

bool AutomationClicker::CanSelect() {
	return (bool)(_automationElement->GetCurrentPropertyValue(AutomationElement::IsSelectionItemPatternAvailableProperty));
}

void AutomationClicker::Select() {
	dynamic_cast<SelectionItemPattern^>(_automationElement->GetCurrentPattern(SelectionItemPattern::Pattern))->Select();
}