// ListViewExplorer.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"

HWND ask_for_list_view_handle() {
	HWND hwnd = 0 ;

	printf("HWND of list view control: ") ;
	scanf_s("%x", &hwnd) ;
	while(getchar() != '\n') continue;

	return hwnd ;
}

void print_acc_name(VARIANT varIn, IAccessible *pAccessible) {
	BSTR bstrName ;

	if (pAccessible->get_accName(varIn, &bstrName) == S_OK) {
		printf("Name: TODO print BSTR\r\n") ;
		SysFreeString(bstrName) ;
	} else
		printf("Name: not available\r\n") ;
}

void print_acc_value(VARIANT varIn, IAccessible *pAccessible) {
}

void print_properties(IAccessible *pAccessible) {
	VARIANT varChild ;
	VariantInit(&varChild) ;
	varChild.vt = VT_I4 ;
	varChild.lVal = CHILDID_SELF ;

	print_acc_name(varChild, pAccessible) ;
	print_acc_value(varChild, pAccessible) ;
}

int _tmain(int argc, _TCHAR* argv[])
{
	printf("ListView Explorer\r\n") ;

	HWND hwndListView = ask_for_list_view_handle() ;
	IAccessible *pAccessible ;
	LPFNACCESSIBLEOBJECTFROMWINDOW lpfnAccessibleObjectFromWindow ;

	HMODULE hModule = LoadLibraryA("oleacc.dll");
	if (hModule == 0) {
		printf("Cannot load oleacc.dll\r\n") ;
		return 1 ;
	}

	lpfnAccessibleObjectFromWindow = (LPFNACCESSIBLEOBJECTFROMWINDOW)GetProcAddress(hModule, "AccessibleObjectFromWindow");

	if (HRESULT hResult = lpfnAccessibleObjectFromWindow(hwndListView, OBJID_CLIENT, IID_IAccessible, (void**)&pAccessible) == S_OK) {
		printf("Got IAccessible\r\n") ;
		print_properties(pAccessible) ;
	} else
		printf("Cannot retrieve IAccessible for window HWND %x. AccessibleObjectFromWindow returned %x\r\n", hwndListView, hResult) ;
	

	return 0;
}

