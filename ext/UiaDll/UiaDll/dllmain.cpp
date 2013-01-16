// dllmain.cpp : Defines the entry point for the DLL application.
#include "stdafx.h"

IUIAutomation *pAutomation ;

IUIAutomation* getGlobalIUIAutomation() {
	if( NULL == pAutomation ) {
		HRESULT hr ;
		hr = CoInitializeEx(NULL, COINIT_MULTITHREADED) ;
		if (FAILED(hr)) {
			printf("UiaDll: CoInitialize failed. hr = 0x%x", hr) ;
			return NULL;
		}
		hr = CoCreateInstance(__uuidof(CUIAutomation), NULL, CLSCTX_INPROC_SERVER, __uuidof(IUIAutomation), (void**)&pAutomation);
		if (FAILED(hr)) {
			printf("UiaDll: CoCreateInstance failed. hr = 0x%x", hr) ;
			return NULL;
		}
	}
	return pAutomation ;
}