// dllmain.cpp : Defines the entry point for the DLL application.
#include "stdafx.h"

IUIAutomation *pAutomation ;

IUIAutomation* getGlobalIUIAutomation() {
	return pAutomation ;
}


BOOL APIENTRY DllMain( HMODULE hModule,
                       DWORD  ul_reason_for_call,
                       LPVOID lpReserved
					 )
{
	switch (ul_reason_for_call)
	{
	case DLL_PROCESS_ATTACH: 
		HRESULT hr ;
		hr = CoInitializeEx(NULL, COINIT_MULTITHREADED) ;
		if (FAILED(hr)) return FALSE ;
		hr = CoCreateInstance(__uuidof(CUIAutomation), NULL, CLSCTX_INPROC_SERVER, __uuidof(IUIAutomation), (void**)&pAutomation);
		if (FAILED(hr)) return FALSE ;
		break ;
	case DLL_THREAD_ATTACH:
	case DLL_THREAD_DETACH:
	case DLL_PROCESS_DETACH:
		break;
	}
	return TRUE;
}

