#include "stdafx.h"
#include "StringHelper.h"

extern "C" {
	__declspec ( dllexport ) void String_CleanUp(const char* strings[], const int numberOfStrings) {
		StringHelper::FreeUp(strings, numberOfStrings);
	}
}