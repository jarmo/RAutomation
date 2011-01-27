// IAccessibleDLL.cpp : Defines the exported functions for the DLL application.
//

#undef UNICODE

#include "stdafx.h"
#include <windows.h>
#include <objbase.h>
#include <OleAcc.h>
#include <Commctrl.h>

extern "C"
__declspec( dllexport ) long get_button_state(HWND buttonHwnd) {
	IAccessible		*pIAccessible ;
	VARIANT			varState;
	VARIANT			varChildId;
	BOOL			checked = FALSE ;
	HRESULT hr ;
	HMODULE hModule ;
	LPFNACCESSIBLEOBJECTFROMWINDOW lpfnAccessibleObjectFromWindow ;

	hModule = LoadLibraryA("oleacc.dll");
	lpfnAccessibleObjectFromWindow = (LPFNACCESSIBLEOBJECTFROMWINDOW)GetProcAddress(hModule, "AccessibleObjectFromWindow");

	hr = lpfnAccessibleObjectFromWindow(buttonHwnd, OBJID_CLIENT, IID_IAccessible, (void**)&pIAccessible) ;

	VariantInit(&varChildId);
	varChildId.vt = VT_I4;
	varChildId.lVal = CHILDID_SELF ;

	pIAccessible->get_accState(varChildId, &varState);
	
	return varState.lVal ;
}

extern "C"
__declspec( dllexport ) int get_list_view_item_text(HWND listView, int index, LPSTR pItemText, int itemTextSize) {
	LVITEM lvItem ;
	HRESULT hr ;

	lvItem.state = LVIF_TEXT ;
	lvItem.iSubItem = 0 ;
	lvItem.pszText = pItemText ;
	lvItem.cchTextMax = 255 ;

	hr = SendMessage(listView, LVM_GETITEMTEXT, index, (LPARAM)&lvItem) ;

	return hr ;
}
