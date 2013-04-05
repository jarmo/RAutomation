// UiaDll.cpp : Defines the exported functions for the DLL application.
//

#include "stdafx.h"
#include "AutomationClicker.h"
#include "AutomationControl.h"
#include "AutomationFinder.h"
#include "ExpandCollapseHelper.h"
#include "StringHelper.h"
#include "SelectionItem.h"
#include "Toggle.h"

IUIAutomation* getGlobalIUIAutomation() ;

extern "C" {

	__declspec ( dllexport ) bool ElementExists(const FindInformation& findInformation) {
        auto automationElement = gcnew AutomationControl(findInformation);
        return automationElement->Exists;
	}

	__declspec ( dllexport ) int BoundingRectangle(const FindInformation& findInformation, long *rectangle) {
    try {
      auto automationElement = gcnew AutomationControl(findInformation);
      auto boundary = automationElement->BoundingRectangle;

      rectangle[0] = boundary.Left;
      rectangle[1] = boundary.Top;
      rectangle[2] = boundary.Right;
      rectangle[3] = boundary.Bottom;
      return 1;
    }
    catch(Exception^ e) {
      Console::WriteLine("BoundingRectangle:  {0}", e->Message);
      return 0;
    }
	}

	__declspec ( dllexport ) int ControlType(const FindInformation& findInformation) {
    try {
      auto automationElement = gcnew AutomationControl(findInformation);
      return automationElement->ControlType->Id;
    } catch(Exception^ e) {
      Console::WriteLine("ControlType:  {0}", e->Message);
      return 0;
    }
	}

  __declspec ( dllexport ) int ProcessId(const FindInformation& findInformation) {
    try {
      auto automationElement = gcnew AutomationControl(findInformation);
      return automationElement->ProcessId;
    } catch(Exception^ e) {
      Console::WriteLine("ProcessId:  {0}", e->Message);
      return 0;
    }
  }

  __declspec ( dllexport ) void Name(const FindInformation& findInformation, char* name, const int nameLength) {
		try {
			auto control = gcnew AutomationControl(findInformation);
			StringHelper::CopyToUnmanagedString(control->Name, name, nameLength);
		} catch(Exception^ e) {
      Console::WriteLine("Name:  {0}", e->Message);
		}
  }

  __declspec ( dllexport ) void ClassName(const FindInformation& findInformation, char* className, const int classNameLength) {
		try {
			auto control = gcnew AutomationControl(findInformation);
			StringHelper::CopyToUnmanagedString(control->ClassName, className, classNameLength);
		} catch(Exception^ e) {
      Console::WriteLine("ClassName:  {0}", e->Message);
		}
  }

  __declspec ( dllexport ) int GetClassNames(const FindInformation& findInformation, const char* classNames[]) {
    auto control = gcnew AutomationControl(findInformation);
    auto finder = gcnew AutomationFinder(control->Element);

    auto allChildren = finder->Find();

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

	__declspec ( dllexport ) IUIAutomationElement *RA_FindChildById(IUIAutomationElement *pElement, char *automationId) {
		IUIAutomationCondition *pCondition ;
		VARIANT varProperty ;

		VariantInit(&varProperty) ;
		varProperty.vt = VT_BSTR ;
		varProperty.bstrVal = _bstr_t(automationId) ;

		HRESULT hr = getGlobalIUIAutomation()->CreatePropertyCondition(UIA_AutomationIdPropertyId, varProperty, &pCondition) ;
		if (SUCCEEDED(hr)) {
			IUIAutomationElement *pFound ;

			hr = pElement->FindFirst(TreeScope_Descendants, pCondition, &pFound) ;
			if (SUCCEEDED(hr)) {
				if (pFound == NULL)
					printf("RA_FindChildById: Element with automation id %s was not found\r\n", automationId) ;

				return pFound ;
			} else {
				printf("RA_FindChildById: FindFirst for children looking for %s failed. hr = 0x%x\r\n", automationId, hr) ;
				return NULL ;
			}
		} else {
			printf("RA_FindChildById: Cannot create search condition. hr = 0x%x\r\n", hr) ;
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

	__declspec ( dllexport ) BOOL RA_SetFocus(IUIAutomationElement *pElement) {
		HRESULT hr = pElement->SetFocus() ;
		if (hr != S_OK)
			printf("RA_SetFocus: SetFocus on element returned 0x%x\r\n", hr) ;

		return SUCCEEDED(hr) ;
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

	__declspec ( dllexport ) bool RA_GetControlName(const HWND windowHandle, char* windowName, const int windowNameLength) {
		try {
			auto control = gcnew AutomationControl(windowHandle);
			StringHelper::CopyToUnmanagedString(control->Name, windowName, windowNameLength);
			return true;
		} catch(Exception^ e) {
			return false;
		}
	}

  __declspec ( dllexport ) bool IsSet(const FindInformation& findInformation) {
    try {
      auto toggle = gcnew Toggle(findInformation);
      return toggle->IsSet;
    } catch(Exception^ e) {
      Debug::WriteLine("IsSet:  {0}", e->Message);
      return false;
    }
  }

  __declspec ( dllexport ) bool IsSelected(const FindInformation& findInformation) {
    try {
      auto selectionItem = gcnew SelectionItem(findInformation);
      return selectionItem->IsSelected;
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

	__declspec ( dllexport ) void RA_Click(const HWND windowHandle, char* errorInfo, const int errorInfoSize) {
		try {
			auto automationClicker = gcnew AutomationClicker(windowHandle);
			automationClicker->Click();
		} catch(Exception^ e) {
			if( errorInfo ) {
				StringHelper::CopyToUnmanagedString(e->ToString(), errorInfo, errorInfoSize);
			}
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

	__declspec ( dllexport ) void RA_ExpandItemByValue(const HWND windowHandle, const char* whichItem) {
		try {
			auto expandCollapseHelper = gcnew ExpandCollapseHelper();
			expandCollapseHelper->ExpandByValue(windowHandle, whichItem);
		} catch(Exception^ e) {
			Console::WriteLine(e->ToString());
		}
	}

	__declspec ( dllexport ) void RA_ExpandItemByIndex(const HWND windowHandle, const int whichItemIndex) {
		try {
			auto expandCollapseHelper = gcnew ExpandCollapseHelper();
			expandCollapseHelper->ExpandByIndex(windowHandle, whichItemIndex);
		} catch(Exception^ e) {
			Console::WriteLine(e->ToString());
		}
	}

	__declspec ( dllexport ) void RA_CollapseItemByValue(const HWND windowHandle, const char* whichItem) {
		try {
			auto expandCollapseHelper = gcnew ExpandCollapseHelper();
			expandCollapseHelper->CollapseByValue(windowHandle, whichItem);
		} catch(Exception^ e) {
			Console::WriteLine(e->ToString());
		}
	}

	__declspec ( dllexport ) void RA_CollapseItemByIndex(const HWND windowHandle, const int whichItemIndex) {
		try {
			auto expandCollapseHelper = gcnew ExpandCollapseHelper();
			expandCollapseHelper->CollapseByIndex(windowHandle, whichItemIndex);
		} catch(Exception^ e) {
			Console::WriteLine(e->ToString());
		}
	}
}
