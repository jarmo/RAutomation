// UiaDll.cpp : Defines the exported functions for the DLL application.
//

#include "stdafx.h"

extern "C"
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

extern "C"
__declspec( dllexport ) BOOL RA_IsOffscreen(IUIAutomationElement *pElement) {
	BOOL isOffscreen ;
	pElement->get_CurrentIsOffscreen(&isOffscreen) ;

	return isOffscreen ;
}

extern "C"
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

extern "C" __declspec ( dllexport ) IUIAutomationElement *RA_FindChildById(IUIAutomationElement *pElement, char *automationId) {
	IUIAutomationCondition *pCondition ;
	VARIANT varProperty ;

	VariantInit(&varProperty) ;
	varProperty.vt = VT_BSTR ;
	varProperty.bstrVal = _bstr_t(automationId) ;

	HRESULT hr = getGlobalIUIAutomation()->CreatePropertyCondition(UIA_AutomationIdPropertyId, varProperty, &pCondition) ;
	if (SUCCEEDED(hr)) {
		IUIAutomationElement *pFound ;

		hr = pElement->FindFirst(TreeScope_Children, pCondition, &pFound) ;
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

extern "C" __declspec ( dllexport ) HWND RA_CurrentNativeWindowHandle(IUIAutomationElement *pElement) {
	UIA_HWND uia_hwnd ;

	if (pElement == NULL) {
		printf("RA_CurrentNativeWindowHandle: Cannot operate on NULL element\r\n") ;
		return (HWND)0 ;
	}

	pElement->get_CurrentNativeWindowHandle(&uia_hwnd) ;
	return (HWND)uia_hwnd ;
}
