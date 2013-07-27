#include "stdafx.h"
#include "MenuItemSelector.h"

BOOL MenuItemExists(const HWND windowHandle, std::list<const char*>& menuItems);
void MenuSelectPath(const HWND windowHandle, char* errorInfo, const int errorInfoSize, std::list<const char*>& menuItems);

extern "C" {

  #pragma managed(push, off)
	__declspec ( dllexport ) void Menu_SelectPath(const HWND windowHandle, char* errorInfo, const int errorInfoSize, const char* arg0, ...) {
		va_list arguments;
		va_start(arguments, arg0);			

		std::list<const char*> menuItems;

		const char* lastArgument = arg0;
		while( NULL != lastArgument ) {
			menuItems.push_back(lastArgument);
			lastArgument = va_arg(arguments, const char*);
		}
		va_end(arguments);

		MenuSelectPath(windowHandle, errorInfo, errorInfoSize, menuItems);
	}
  #pragma managed(pop)

  #pragma managed(push, off)
	__declspec ( dllexport ) BOOL Menu_ItemExists(const HWND windowHandle, const char* arg0, ...) {
		va_list arguments;
		va_start(arguments, arg0);			

		std::list<const char*> menuItems;

		const char* lastArgument = arg0;
		while( NULL != lastArgument ) {
			menuItems.push_back(lastArgument);
			lastArgument = va_arg(arguments, const char*);
		}
		va_end(arguments);

		return MenuItemExists(windowHandle, menuItems);
	}
  #pragma managed(pop)
}

BOOL MenuItemExists(const HWND windowHandle, std::list<const char*>& menuItems)
{
	auto menuSelector = gcnew MenuItemSelector();
	return menuSelector->MenuItemExists(windowHandle, menuItems);
}

void MenuSelectPath(const HWND windowHandle, char* errorInfo, const int errorInfoSize, std::list<const char*>& menuItems)
{
	try {
		auto menuSelector = gcnew MenuItemSelector();
		menuSelector->SelectMenuPath(windowHandle, menuItems);
	} catch(Exception^ e) {
		if( errorInfo ) {
			StringHelper::CopyToUnmanagedString(e->ToString(), errorInfo, errorInfoSize);
		}
	}
}