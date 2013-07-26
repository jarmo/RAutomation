#pragma once
#include "AutomationControl.h"
#include "StringHelper.h"

namespace UIA = System::Windows::Automation;

ref class AutomatedTabControl : AutomationControl 
{
public:
	AutomatedTabControl(const FindInformation& findInformation);
  
  int GetTabItems(const char* options[]);

  property String^ Selection {
      String^ get();
  }

private:
	property AutomationElementCollection^ TabItems {
		AutomationElementCollection^ get() { return _control->FindAll(UIA::TreeScope::Subtree, TabItemCondition); }
	}

  property Condition^ TabItemCondition {
	  Condition^ get() { return gcnew PropertyCondition(AutomationElement::ControlTypeProperty, UIA::ControlType::TabItem); }
  }
};

