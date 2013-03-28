#pragma once

using namespace System::Windows::Automation;

ref class AutomationControl
{
public:
	AutomationControl(const HWND windowHandle);
  AutomationControl(const FindInformation& findInformation);

	property String^ Name {
		String^ get() { return _control->Current.Name; }
	}

	property String^ Value {
		String^ get();
		void set(String^ value);
	}

  property bool Exists {
	  bool get() { return nullptr != _control; }
  }

private:
	AutomationElement^ _control;

	property ValuePattern^ AsValuePattern {
		ValuePattern^ get() {
			return dynamic_cast<ValuePattern^>(_control->GetCurrentPattern(ValuePattern::Pattern));
		}
	}
};

