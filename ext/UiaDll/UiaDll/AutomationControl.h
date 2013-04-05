#pragma once

using namespace System::Windows::Automation;
using namespace System::Windows;
using namespace System::Diagnostics;

ref class AutomationControl
{
public:
	AutomationControl(const HWND windowHandle);
  AutomationControl(const FindInformation& findInformation);

	property String^ Name {
		String^ get() { return _control->Current.Name; }
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

protected:
	AutomationElement^ _control;

private:
	property ValuePattern^ AsValuePattern {
		ValuePattern^ get() {
			return dynamic_cast<ValuePattern^>(_control->GetCurrentPattern(ValuePattern::Pattern));
		}
	}
};

