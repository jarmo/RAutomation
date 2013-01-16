#include "StdAfx.h"
#include "AutomationControl.h"


AutomationControl::AutomationControl(const HWND windowHandle)
{
	_control = AutomationElement::FromHandle(IntPtr(windowHandle));
}
