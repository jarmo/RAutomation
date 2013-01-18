// UiaDll.cpp : Defines the exported functions for the DLL application.
//

#include "stdafx.h"
#include "AutomationClicker.h"
#include "AutomationControl.h"
#include "ExpandCollapseHelper.h"
#include "StringHelper.h"
#include "ToggleStateHelper.h"

IUIAutomation* getGlobalIUIAutomation() ;

extern "C" {
	__declspec( dllexport ) IUIAutomationElement *RA_FindWindow(char *pszAutomationId) {
		IUIAutomationElement *pRootElement ;

		HRESULT hr = getGlobalIUIAutomation()->GetRootElement(&pRootElement) ;
		if (SUCCEEDED(hr)) {
			IUIAutomationCondition *pCondition ;
			VARIANT varProperty ;

			VariantInit(&varProperty) ;
			varProperty.vt = VT_BSTR ;
			varProperty.bstrVal = _bstr_t(pszAutomationId) ;

			hr = getGlobalIUIAutomation()->CreatePropertyCondition(UIA_AutomationIdPropertyId, varProperty, &pCondition) ;
			if (SUCCEEDED(hr)) {
				IUIAutomationElement *pFound ;

				hr = pRootElement->FindFirst(TreeScope_Children, pCondition, &pFound) ;
				if (SUCCEEDED(hr)) {
					return pFound ;
				}
			}
		}
		return NULL ;
	}

	//This doesn't work
	__declspec( dllexport ) int RA_FindWindowByPID(int processId, IUIAutomationElement *pElement) {
		IUIAutomationElement *pRootElement;

		HRESULT hr = getGlobalIUIAutomation()->GetRootElement(&pRootElement);
		if (SUCCEEDED(hr)) {
			IUIAutomationCondition *pCondition;
			VARIANT varProperty;

			VariantInit(&varProperty);
			varProperty.vt = VT_I4;
			varProperty.intVal = (processId);

			hr = getGlobalIUIAutomation()->CreatePropertyCondition(UIA_ProcessIdPropertyId, varProperty, &pCondition);
			if (SUCCEEDED(hr)) {

				hr = pRootElement->FindFirst(TreeScope_Children, pCondition, &pElement);
				if (SUCCEEDED(hr)) {
					return 1;
				}
			}
		}
		return 0;
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

	__declspec ( dllexport ) IUIAutomationElement *RA_GetFocusedElement() {
		IUIAutomationElement *pelement;

		HRESULT hr = getGlobalIUIAutomation()->GetFocusedElement(&pelement);

		if (SUCCEEDED(hr))
			return pelement;
		else {
			printf("RA_GetFocusedElement: Cannot find element from focus. HRESULT was 0x%x\r\n", hr) ;
			return false ;
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

	__declspec ( dllexport ) IUIAutomationElement *RA_FindChildByName(IUIAutomationElement *pElement, char *elementName) {
		IUIAutomationCondition *pCondition ;
		VARIANT varProperty ;

		VariantInit(&varProperty) ;
		varProperty.vt = VT_BSTR ;
		varProperty.bstrVal = _bstr_t(elementName) ;

		HRESULT hr = getGlobalIUIAutomation()->CreatePropertyCondition(UIA_NamePropertyId, varProperty, &pCondition) ;
		if (SUCCEEDED(hr)) {
			IUIAutomationElement *pFound ;

			hr = pElement->FindFirst(TreeScope_Descendants, pCondition, &pFound) ;
			if (SUCCEEDED(hr)) {
				if (pFound == NULL)
					printf("RA_FindChildByName: Element with automation name %s was not found\r\n", elementName) ;
				//printf("RA_FindChildByName: success with value %s\r\n", elementName) ;
				return pFound ;
			} else {
				printf("RA_FindChildByName: FindFirst for children looking for %s failed. hr = 0x%x\r\n", elementName, hr) ;
				return NULL ;
			}
		} else {
			printf("RA_FindChildByName: Cannot create search condition. hr = 0x%x\r\n", hr) ;
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

	__declspec ( dllexport ) int RA_GetCurrentProcessId(IUIAutomationElement *pElement) {
		HRESULT hr;
		int process_id;

		hr = pElement->get_CurrentProcessId(&process_id);

		if  (SUCCEEDED(hr)){
			return process_id;
		}
		else {
			printf("RA_GetCurrentProcessId: get_CurrentProcessId returned 0x%x\r\n", hr) ;
			return 0 ;
		}
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

	__declspec ( dllexport ) long RA_GetDesktopHandle() {
		return (long)GetDesktopWindow();
	}

	__declspec ( dllexport ) int RA_CurrentBoundingRectangle(IUIAutomationElement *pElement, long *rectangle) {
		RECT boundary;

		HRESULT hr = pElement->get_CurrentBoundingRectangle(&boundary) ;
		if (SUCCEEDED(hr)) {

			rectangle[0] = boundary.left;
			rectangle[1] = boundary.top;
			rectangle[2] = boundary.right;
			rectangle[3] = boundary.bottom;

			return 1;
		}
		else {
			printf("RA_CurrentBoundingRectangle: get_CurrentBoundingRectangle failed 0x%x\r\n", hr) ;
			return 0 ;
		}
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

	__declspec ( dllexport ) int RA_GetName(IUIAutomationElement *pElement, char *pName) {
		BSTR bstrName ;
		HRESULT hr = pElement->get_CurrentName(&bstrName) ;

		if (FAILED(hr)) {
			printf("RA_GetName: get_CurrentName failed 0x%x\r\n", hr) ;
			return -1 ;
		}

		char *pszName = _com_util::ConvertBSTRToString(bstrName) ;

		if (pszName != NULL){
			if (pName == NULL) {
				return strlen(pszName) ;
			} else {
				strcpy(pName, pszName) ;
				return strlen(pszName) ;
			}
		} else {
			return -1;
		}
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

	__declspec ( dllexport ) int RA_GetClassName(IUIAutomationElement *pElement, char *pClass) {
		BSTR bstrClass ;
		HRESULT hr = pElement->get_CurrentClassName(&bstrClass) ;

		if (FAILED(hr)) {
			printf("RA_GetName: get_CurrentClassName failed 0x%x\r\n", hr) ;
			return -1 ;
		}

		char *pszClass = _com_util::ConvertBSTRToString(bstrClass) ;

		if (pszClass != NULL){
			if (pClass == NULL) {
				return strlen(pszClass) ;
			} else {
				strcpy(pClass, pszClass) ;
				return strlen(pszClass) ;
			}
		} else {
			return -1;
		}
	}

	__declspec ( dllexport ) BOOL RA_GetIsSet(IUIAutomationElement *pElement) {
		return ToggleStateHelper().IsSet(pElement);
	}

	__declspec ( dllexport ) BOOL RA_GetIsSelected(IUIAutomationElement *pElement) {
		ISelectionItemProvider *pSelectionPattern ;
		HRESULT hr = pElement->GetCurrentPattern(UIA_SelectionItemPatternId, (IUnknown**)&pSelectionPattern) ;

		if (FAILED(hr)) {
			printf("RA_GetIsSelected: getCurrentPattern failed 0x%x\r\n") ;
			return FALSE ;
		}

		BOOL RetVal ;
		hr = pSelectionPattern->get_IsSelected(&RetVal) ;
		if (FAILED(hr)) {
			printf("RA_GetIsSelected: get_IsSelected failed 0x%x\r\n", hr) ;
			return FALSE ;
		} else {
			return RetVal ;
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
