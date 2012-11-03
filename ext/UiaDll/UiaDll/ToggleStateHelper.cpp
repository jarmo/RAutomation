#include "StdAfx.h"
#include "ToggleStateHelper.h"


ToggleStateHelper::ToggleStateHelper(void)
{
}


ToggleStateHelper::~ToggleStateHelper(void)
{
}

BOOL ToggleStateHelper::IsSet(IUIAutomationElement*	automationElement)
{
	CComPtr<IToggleProvider> togglePattern;
	HRESULT hr = automationElement->GetCurrentPattern(UIA_TogglePatternId, (IUnknown**)&togglePattern) ;

	if (FAILED(hr)) {
		printf("RA_GetIsSet: getCurrentPattern failed 0x%x\r\n") ;
		return FALSE ;
	}

	ToggleState  RetVal ;
	hr = togglePattern->get_ToggleState(&RetVal) ;
	if (FAILED(hr)) {
		printf("RA_GetIsSet: get_ToggleState failed 0x%x\r\n", hr) ;
		return FALSE ;
	} else {
		return RetVal ;
	}
}