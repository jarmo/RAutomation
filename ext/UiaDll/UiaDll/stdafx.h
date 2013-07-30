// stdafx.h : include file for standard system include files,
// or project specific include files that are used frequently, but
// are changed infrequently
//

#pragma once

#include "targetver.h"

#define WIN32_LEAN_AND_MEAN             // Exclude rarely-used stuff from Windows headers
// Windows Header Files:
#include <windows.h>
#include <ObjBase.h>
#include <UIAutomation.h>
#include <comutil.h> 

#include <list>

using namespace System;
using namespace System::Runtime::InteropServices;
namespace UIAutomation = System::Windows::Automation;

typedef enum {
    Handle = 1,
    Id,
    Value,
    Focus,
    ScreenPoint
} FindMethod;

typedef struct _FindInformation {
    HWND rootWindow;
    int index;
    bool onlySearchChildren;
    FindMethod  how;
    union {
        char stringData[256];
        int intData;
        int pointData[2];
	  } data;
} FindInformation, *LPFindInformation;