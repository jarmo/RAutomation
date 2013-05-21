#pragma once

using namespace System::Windows::Automation;
using namespace System::Windows;
using namespace System::Windows::Forms;
using namespace System::Diagnostics;

ref class AutomationControl
{
public:
	AutomationControl(const HWND windowHandle);
  AutomationControl(const FindInformation& findInformation);

  property AutomationElement^ Element {
    AutomationElement^ get() { return _control; }
  }

	property String^ Name {
		String^ get() { return _control->Current.Name; }
	}

	property String^ ClassName {
		String^ get() { return _control->Current.ClassName; }
	}

  property bool IsEnabled {
    bool get() { return _control->Current.IsEnabled; }
  }

  property bool IsFocused {
    bool get() { return _control->Current.HasKeyboardFocus; }
  }

  property Rect BoundingRectangle {
    Rect get() { return _control->Current.BoundingRectangle; }
  }

  property System::Windows::Automation::ControlType^ ControlType {
    System::Windows::Automation::ControlType^ get() { return _control->Current.ControlType; }
  }

  property int ProcessId {
    int get() { return _control->Current.ProcessId; }
  }

	property String^ Value {
		String^ get();
		void set(String^ value);
	}

  property bool Exists {
	  bool get() { return nullptr != _control; }
  }

  property bool IsValuePattern {
    bool get();
  }

  void SendKeys(String^ theKeys) {
    _control->SetFocus();
    SendKeys::SendWait(theKeys);
  }

protected:
	AutomationElement^ _control;

private:
	property ValuePattern^ AsValuePattern {
		ValuePattern^ get() {
			return dynamic_cast<ValuePattern^>(_control->GetCurrentPattern(ValuePattern::Pattern));
		}
	}
};

