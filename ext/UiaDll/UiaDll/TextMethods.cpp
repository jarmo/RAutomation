#include "stdafx.h"
#include "AutomatedText.h"
#include "StringHelper.h"

extern "C" {
  __declspec ( dllexport ) void Text_GetValue(const FindInformation& findInformation, char* theValue, const int maximumLength) {
    try {
      auto control = gcnew AutomatedText(findInformation);
      StringHelper::CopyToUnmanagedString(control->Text, theValue, maximumLength);
    } catch(Exception^ e) {
      Console::WriteLine("Text_GetValue:  {0}", e->Message);
    }
  }

  __declspec ( dllexport ) void Text_SetValue(const FindInformation& findInformation, const char* theValue) {
    try {
      auto control = gcnew AutomatedText(findInformation);
      control->Text = gcnew String(theValue);
    } catch(Exception^ e) {
      Console::WriteLine("Text_SetValue:  {0}", e->Message);
    }
  }
}