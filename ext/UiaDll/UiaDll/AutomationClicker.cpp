#include "StdAfx.h"
#include "AutomationClicker.h"

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
	_control->SetFocus();
	auto clickablePoint = _control->GetClickablePoint();
	Cursor::Position = System::Drawing::Point((int)clickablePoint.X, (int)clickablePoint.Y);
	mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
	mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
}

bool AutomationClicker::CanInvoke() {
	return (bool)(_control->GetCurrentPropertyValue(AutomationElement::IsInvokePatternAvailableProperty));
}

void AutomationClicker::Invoke() {
	dynamic_cast<InvokePattern^>(_control->GetCurrentPattern(InvokePattern::Pattern))->Invoke();
}

bool AutomationClicker::CanToggle() {
	return (bool)(_control->GetCurrentPropertyValue(AutomationElement::IsTogglePatternAvailableProperty));
}

void AutomationClicker::Toggle() {
	dynamic_cast<TogglePattern^>(_control->GetCurrentPattern(TogglePattern::Pattern))->Toggle();
}

bool AutomationClicker::CanSelect() {
	return (bool)(_control->GetCurrentPropertyValue(AutomationElement::IsSelectionItemPatternAvailableProperty));
}

void AutomationClicker::Select() {
	dynamic_cast<SelectionItemPattern^>(_control->GetCurrentPattern(SelectionItemPattern::Pattern))->Select();
}