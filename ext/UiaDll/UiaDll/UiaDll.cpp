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
