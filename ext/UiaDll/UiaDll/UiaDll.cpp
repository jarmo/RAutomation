// UiaDll.cpp : Defines the exported functions for the DLL application.
//

#include "stdafx.h"
#include "Locator.h"
#include "DynamicAssemblyResolver.h"
#include "StringHelper.h"

IUIAutomation* getGlobalIUIAutomation() ;

using namespace RAutomation::UIA;
using namespace RAutomation::UIA::Controls;
using namespace RAutomation::UIA::Extensions;

using namespace System::Diagnostics;

extern "C" {
	__declspec(dllexport) void initialize(char* privateAssemblyDirectory) {
		DynamicAssemblyResolver::PrivatePath = gcnew String(privateAssemblyDirectory);
	}

	__declspec ( dllexport ) bool ElementExists(const FindInformation& findInformation) {
    return Element::Exists(Locator::FindFor(findInformation));
	}

	__declspec ( dllexport ) int NativeWindowHandle(const FindInformation& findInformation) { 
    return Element::NativeWindowHandle(Locator::FindFor(findInformation));
	}

	__declspec ( dllexport ) int HandleFromPoint(int xCoord, int yCoord) {
		auto element = AutomationElement::FromPoint(Point((double)xCoord, (double)yCoord));
		return Element::NativeWindowHandle(element);
	}

	__declspec ( dllexport ) int BoundingRectangle(const FindInformation& findInformation, long *rectangle) {
		try {
			auto boundary = Element::BoundingRectangle(Locator::FindFor(findInformation));

			rectangle[0] = (long)boundary.Left;
			rectangle[1] = (long)boundary.Top;
			rectangle[2] = (long)boundary.Right;
			rectangle[3] = (long)boundary.Bottom;
			return 1;
		}
		catch(Exception^ e) {
			Console::WriteLine("BoundingRectangle:  {0}", e->Message);
			return 0;
		}
	}

	__declspec ( dllexport ) int ControlType(const FindInformation& findInformation) {
		try {
      return Element::ControlType(Locator::FindFor(findInformation))->Id;
		} catch(Exception^ e) {
			Console::WriteLine("ControlType:  {0}", e->Message);
			return 0;
		}
	}

	__declspec ( dllexport ) int ProcessId(const FindInformation& findInformation) {
		try {
      return Element::ProcessId(Locator::FindFor(findInformation));
		} catch(Exception^ e) {
			Console::WriteLine("ProcessId:  {0}", e->Message);
			return 0;
		}
	}

	__declspec ( dllexport ) void Name(const FindInformation& findInformation, char* name, const int nameLength) {
		try {
      auto currentName = Element::Name(Locator::FindFor(findInformation));
	  StringHelper::CopyToUnmanagedString(currentName, name, nameLength);
		} catch(Exception^ e) {
			Console::WriteLine("Name:  {0}", e->Message);
		}
	}

	__declspec ( dllexport ) void ClassName(const FindInformation& findInformation, char* className, const int classNameLength) {
		try {
      auto currentClassName = Element::ClassName(Locator::FindFor(findInformation));
			StringHelper::CopyToUnmanagedString(currentClassName, className, classNameLength);
		} catch(Exception^ e) {
			Console::WriteLine("ClassName:  {0}", e->Message);
		}
	}

	__declspec ( dllexport ) bool IsEnabled(const FindInformation& findInformation) {
		try {
			return Element::IsEnabled(Locator::FindFor(findInformation));
		} catch(Exception^ e) {
			Console::WriteLine("IsEnabled:  {0}", e->Message);
			return false;
		}
	}

	__declspec ( dllexport ) bool IsFocused(const FindInformation& findInformation) {
		try {
			return Element::IsFocused(Locator::FindFor(findInformation));
		} catch(Exception^ e) {
			Console::WriteLine("IsFocused:  {0}", e->Message);
			return false;
		}
	}

	__declspec ( dllexport ) bool SetControlFocus(const FindInformation& findInformation) {
		try {
			Locator::FindFor(findInformation)->SetFocus();
			return true;
		} catch(Exception^ e) {
			Console::WriteLine("IsFocused:  {0}", e->Message);
			return false;
		}
	}

	__declspec ( dllexport ) int GetClassNames(const FindInformation& findInformation, const char* classNames[]) {
		auto allChildren = Locator::FindFor(findInformation)->FindAll(System::Windows::Automation::TreeScope::Subtree, Condition::TrueCondition);

		if( NULL != classNames ) {
			StringHelper::CopyClassNames(allChildren, classNames);
		}

		return allChildren->Count;
	}

	__declspec ( dllexport ) IUIAutomationElement *RA_ElementFromHandle(HWND hwnd) {
		IUIAutomationElement *pElement ;

		HRESULT hr = getGlobalIUIAutomation()->ElementFromHandle(hwnd, &pElement) ;
		if (SUCCEEDED(hr))
			return pElement ;
		else {
			printf("RA_ElementFromHandle: Cannot find element from handle 0x%x. HRESULT was 0x%x\r\n", hwnd, hr) ;
			return NULL ;
		}
	}

	__declspec ( dllexport ) long RA_ClickMouse() {
		mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
		mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
		return 0;
	}

	__declspec ( dllexport ) long RA_MoveMouse(int x, int y) {
		return SetCursorPos(x,y);
	}

	__declspec ( dllexport ) int RA_CurrentIsOffscreen(IUIAutomationElement *pElement, int *visible) {
		BOOL offscreen;

		HRESULT hr = pElement->get_CurrentIsOffscreen(&offscreen) ;
		if (SUCCEEDED(hr)) {
			if(offscreen){
				*visible = 1;
			}
			else
			{
				*visible = 0;
			}
			return 1;
		}
		else {
			printf("RA_CurrentIsOffscreen: get_CurrentIsOffscreen failed 0x%x\r\n", hr) ;
			return 0 ;
		}
	}

	__declspec ( dllexport ) bool IsSet(const FindInformation& findInformation) {
		try {
			return Element::IsToggled(Locator::FindFor(findInformation));
		} catch(Exception^ e) {
			Debug::WriteLine("IsSet:  {0}", e->Message);
			return false;
		}
	}

	__declspec ( dllexport ) bool IsSelected(const FindInformation& findInformation) {
		try {
			return Element::IsSelected(Locator::FindFor(findInformation));
		} catch(Exception^ e) {
			Debug::WriteLine("IsSelected:  {0}", e->Message);
			return false;
		}
	}

	__declspec ( dllexport ) bool RA_Click(const FindInformation& findInformation, char* errorInfo, const int errorInfoSize) {
		try {
			return Clicker::Click(Locator::FindFor(findInformation));
		} catch(Exception^ e) {
			if( errorInfo ) {
				StringHelper::CopyToUnmanagedString(e->ToString(), errorInfo, errorInfoSize);
			}

      return false;
		}
	}

	__declspec ( dllexport ) void RA_ExpandItemByValue(const FindInformation& findInformation, const char* whichItem) {
		try {
			auto expander = gcnew Expander(Locator::FindFor(findInformation));
      expander->Expand(gcnew String(whichItem));
		} catch(Exception^ e) {
			Console::WriteLine(e->ToString());
		}
	}

	__declspec ( dllexport ) void RA_ExpandItemByIndex(const FindInformation& findInformation, const int whichItemIndex) {
		try {
			auto expander = gcnew Expander(Locator::FindFor(findInformation));
			expander->Expand(whichItemIndex);
		} catch(Exception^ e) {
			Console::WriteLine(e->ToString());
		}
	}

	__declspec ( dllexport ) void RA_CollapseItemByValue(const FindInformation& findInformation, const char* whichItem) {
		try {
			auto collapser = gcnew Collapser(Locator::FindFor(findInformation));
			collapser->Collapse(gcnew String(whichItem));
		} catch(Exception^ e) {
			Console::WriteLine(e->ToString());
		}
	}

	__declspec ( dllexport ) void RA_CollapseItemByIndex(const FindInformation& findInformation, const int whichItemIndex) {
		try {
			auto collapser = gcnew Collapser(Locator::FindFor(findInformation));
			collapser->Collapse(whichItemIndex);
		} catch(Exception^ e) {
			Console::WriteLine(e->ToString());
		}
	}
}
