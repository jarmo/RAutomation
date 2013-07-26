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
      void set(String^);
  }

  property int SelectedIndex {
      int get();
      void set(int);
  }

private:
	property AutomationElementCollection^ TabItems {
		AutomationElementCollection^ get() { return _control->FindAll(UIA::TreeScope::Subtree, TabItemCondition); }
	}

  property Condition^ TabItemCondition {
	  Condition^ get() { return gcnew PropertyCondition(AutomationElement::ControlTypeProperty, UIA::ControlType::TabItem); }
  }

  Condition^ GetNamedTabItemCondition(String^ name) {
	  return gcnew AndCondition(TabItemCondition, gcnew PropertyCondition(AutomationElement::NameProperty, name));
  }

  void Select(AutomationElement^ tabItem) {
    dynamic_cast<SelectionItemPattern^>(tabItem->GetCurrentPattern(SelectionItemPattern::Pattern))->Select();
  }
};

