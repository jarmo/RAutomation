#include "StdAfx.h"
#include "AutomatedText.h"

String^ AutomatedText::Text::get() {
  if( IsValuePattern ) {
    return Value;
  } else {
    return AsTextPattern->DocumentRange->GetText(-1);
  }
}

void AutomatedText::Text::set(String^ value) {
  if( IsValuePattern ) {
    Value = value;
  } else {
    _control->SetFocus();
    SendKeys::SendWait("^{HOME}");   // Move to start of control
    SendKeys::SendWait("^+{END}");   // Select everything
    SendKeys::SendWait("{DEL}");     // Delete selection
    SendKeys::SendWait(value);
  }
}