// UiaDll.cpp : Defines the exported functions for the DLL application.
//

#include "stdafx.h"
#include "AutomationClicker.h"
#include "AutomationControl.h"
#include "AutomationFinder.h"
#include "DynamicAssemblyResolver.h"
#include "StringHelper.h"

IUIAutomation* getGlobalIUIAutomation() ;

using namespace RAutomation::UIA;
using namespace RAutomation::UIA::Extensions;

extern "C" {
	__declspec(dllexport) void initialize(char* privateAssemblyDirectory) {
		DynamicAssemblyResolver::PrivatePath = gcnew String(privateAssemblyDirectory);
	}

	__declspec ( dllexport ) bool ElementExists(const FindInformation& findInformation) {
    return Element::Exists(AutomationFinder::FindFor(findInformation));
	}

	__declspec ( dllexport ) int NativeWindowHandle(const FindInformation& findInformation) { 
    return Element::NativeWindowHandle(AutomationFinder::FindFor(findInformation));
	}

	__declspec ( dllexport ) int BoundingRectangle(const FindInformation& findInformation, long *rectangle) {
		try {
			auto boundary = Element::BoundingRectangle(AutomationFinder::FindFor(findInformation));

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
      return Element::ControlType(AutomationFinder::FindFor(findInformation))->Id;
		} catch(Exception^ e) {
			Console::WriteLine("ControlType:  {0}", e->Message);
			return 0;
		}
	}

	__declspec ( dllexport ) int ProcessId(const FindInformation& findInformation) {
		try {
      return Element::ProcessId(AutomationFinder::FindFor(findInformation));
		} catch(Exception^ e) {
			Console::WriteLine("ProcessId:  {0}", e->Message);
			return 0;
		}
	}

	__declspec ( dllexport ) void Name(const FindInformation& findInformation, char* name, const int nameLength) {
		try {
      auto currentName = Element::Name(AutomationFinder::FindFor(findInformation));
	  StringHelper::CopyToUnmanagedString(currentName, name, nameLength);
		} catch(Exception^ e) {
			Console::WriteLine("Name:  {0}", e->Message);
		}
	}

	__declspec ( dllexport ) void ClassName(const FindInformation& findInformation, char* className, const int classNameLength) {
		try {
      auto currentClassName = Element::ClassName(AutomationFinder::FindFor(findInformation));
			StringHelper::CopyToUnmanagedString(currentClassName, className, classNameLength);
		} catch(Exception^ e) {
			Console::WriteLine("ClassName:  {0}", e->Message);
		}
	}

	__declspec ( dllexport ) bool IsEnabled(const FindInformation& findInformation) {
		try {
			return Element::IsEnabled(AutomationFinder::FindFor(findInformation));
		} catch(Exception^ e) {
			Console::WriteLine("IsEnabled:  {0}", e->Message);
			return false;
		}
	}

	__declspec ( dllexport ) bool IsFocused(const FindInformation& findInformation) {
		try {
			return Element::IsFocused(AutomationFinder::FindFor(findInformation));
		} catch(Exception^ e) {
			Console::WriteLine("IsFocused:  {0}", e->Message);
			return false;
		}
	}

	__declspec ( dllexport ) bool SetControlFocus(const FindInformation& findInformation) {
		try {
			AutomationFinder::FindFor(findInformation)->SetFocus();
			return true;
		} catch(Exception^ e) {
			Console::WriteLine("IsFocused:  {0}", e->Message);
			return false;
		}
	}

	__declspec ( dllexport ) int GetClassNames(const FindInformation& findInformation, const char* classNames[]) {
		auto allChildren = AutomationFinder::FindFor(findInformation)->FindAll(System::Windows::Automation::TreeScope::Subtree, Condition::TrueCondition);

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

	__declspec ( dllexport ) IUIAutomationElement *RA_ElementFromPoint(int xCoord, int yCoord) {
		IUIAutomationElement *pElement ;
		POINT point;

		point.x = xCoord;
		point.y = yCoord;

		HRESULT hr = getGlobalIUIAutomation()->ElementFromPoint(point, &pElement) ;
		if (SUCCEEDED(hr))
			return pElement ;
		else {
			printf("RA_ElementFromPoint: Cannot find element from point %d , %d. HRESULT was 0x%x\r\n", xCoord, yCoord, hr) ;
			return NULL ;
		}
	}

	__declspec ( dllexport ) HWND RA_CurrentNativeWindowHandle(IUIAutomationElement *pElement) {
		UIA_HWND uia_hwnd ;

		if (pElement == NULL) {
			printf("RA_CurrentNativeWindowHandle: Cannot operate on NULL element\r\n") ;
			return (HWND)0 ;
		}

		pElement->get_CurrentNativeWindowHandle(&uia_hwnd) ;
		return (HWND)uia_hwnd ;
	}

	__declspec ( dllexport ) int RA_GetCurrentControlType(IUIAutomationElement *pElement) {
		CONTROLTYPEID control_type ;

		HRESULT hr = pElement->get_CurrentControlType(&control_type) ;
		if (SUCCEEDED(hr))
			return control_type ;
		else {
			printf("RA_GetCurrentControlType: CurrentControlType returned 0x%x\r\n", hr) ;
			return 0 ;
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

	__declspec ( dllexport ) int RA_FindChildren(IUIAutomationElement *pElement, IUIAutomationElement *pChildren[]) {
		IUIAutomationCondition *pTrueCondition ;
		IUIAutomationElementArray *pElementArray ;
		int element_count ;

		HRESULT hr = getGlobalIUIAutomation()->CreateTrueCondition(&pTrueCondition) ;
		if (FAILED(hr)) {
			printf("RA_FindChildren: Could not create true condition 0x%x\r\n", hr) ;
			return 0 ;
		}

		hr = pElement->FindAll(TreeScope_Children, pTrueCondition, &pElementArray) ;
		if (FAILED(hr)) {
			printf("RA_FindChildren: FindAll failed 0x%x\r\n", hr) ;
			return 0 ;
		}

		hr = pElementArray->get_Length(&element_count) ;
		if (FAILED(hr)) {
			printf("RA_FindChildren: get_length failed 0x%x\r\n", hr) ;
			return 0 ;
		}

		if (pChildren != NULL) {
			// given some memory get the details
			for (int index = 0; index < element_count; index++) {
				IUIAutomationElement *pElement ;

				hr = pElementArray->GetElement(index, &pElement) ;
				if (FAILED(hr)) {
					printf("RA_FindChildren: GetElement failed 0x%x\r\n", hr) ;
				} else {
					pChildren[index] = pElement ;
				}
			}
		}

		return element_count ;
	}

	__declspec ( dllexport ) bool IsSet(const FindInformation& findInformation) {
		try {
			return Element::IsToggled(AutomationFinder::FindFor(findInformation));
		} catch(Exception^ e) {
			Debug::WriteLine("IsSet:  {0}", e->Message);
			return false;
		}
	}

	__declspec ( dllexport ) bool IsSelected(const FindInformation& findInformation) {
		try {
			return Element::IsSelected(AutomationFinder::FindFor(findInformation));
		} catch(Exception^ e) {
			Debug::WriteLine("IsSelected:  {0}", e->Message);
			return false;
		}
	}

	__declspec ( dllexport ) int RA_Select(IUIAutomationElement *pElement) {
		ISelectionItemProvider *pSelectionPattern ;
		HRESULT hr = pElement->GetCurrentPattern(UIA_SelectionItemPatternId, (IUnknown**)&pSelectionPattern) ;
		if (FAILED(hr)) {
			printf("RA_GetIsSelected: getCurrentPattern failed 0x%x\r\n") ;
			return FALSE ;
		}

		hr = pSelectionPattern->Select();
		if (FAILED(hr)) {
			printf("RA_Select: Select failed 0x%x\r\n", hr) ;
			return 0 ;
		}

		return 1;
	}

	__declspec ( dllexport ) bool RA_Click(const FindInformation& findInformation, char* errorInfo, const int errorInfoSize) {
		try {
			auto automationClicker = gcnew AutomationClicker(findInformation);
			return automationClicker->Click();
		} catch(Exception^ e) {
			if( errorInfo ) {
				StringHelper::CopyToUnmanagedString(e->ToString(), errorInfo, errorInfoSize);
			}

      return false;
		}
	}

	__declspec ( dllexport ) void RA_PointAndClick(const HWND windowHandle, char* errorInfo, const int errorInfoSize) {
		try {
			auto automationClicker = gcnew AutomationClicker(windowHandle);
			automationClicker->MouseClick();
		} catch(Exception^ e) {
			if( errorInfo ) {
				StringHelper::CopyToUnmanagedString(e->ToString(), errorInfo, errorInfoSize);
			}
		}
	}

	__declspec ( dllexport ) void RA_ExpandItemByValue(const FindInformation& findInformation, const char* whichItem) {
		try {
			auto expander = gcnew Expander(AutomationFinder::FindFor(findInformation));
      expander->Expand(gcnew String(whichItem));
		} catch(Exception^ e) {
			Console::WriteLine(e->ToString());
		}
	}

	__declspec ( dllexport ) void RA_ExpandItemByIndex(const FindInformation& findInformation, const int whichItemIndex) {
		try {
			auto expander = gcnew Expander(AutomationFinder::FindFor(findInformation));
			expander->Expand(whichItemIndex);
		} catch(Exception^ e) {
			Console::WriteLine(e->ToString());
		}
	}

	__declspec ( dllexport ) void RA_CollapseItemByValue(const FindInformation& findInformation, const char* whichItem) {
		try {
			auto collapser = gcnew Collapser(AutomationFinder::FindFor(findInformation));
			collapser->Collapse(gcnew String(whichItem));
		} catch(Exception^ e) {
			Console::WriteLine(e->ToString());
		}
	}

	__declspec ( dllexport ) void RA_CollapseItemByIndex(const FindInformation& findInformation, const int whichItemIndex) {
		try {
			auto collapser = gcnew Collapser(AutomationFinder::FindFor(findInformation));
			collapser->Collapse(whichItemIndex);
		} catch(Exception^ e) {
			Console::WriteLine(e->ToString());
		}
	}
}
