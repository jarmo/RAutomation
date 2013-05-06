#include "StdAfx.h"
#include "AutomationClicker.h"

bool AutomationClicker::Click() {
  try {
    if( CanInvoke() ) {
      Invoke();
    } else if( CanToggle() ) {
      Toggle();
    } else if( CanSelect() ) {
      Select();
    }

    return true;
  } catch(Exception^ e) {
    Console::WriteLine("AutomationClicker::Click - {0}", e->Message);
    return false;
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