#include "StdAfx.h"
#include "StringHelper.h"

void StringHelper::CopyToUnmanagedString(String^ source, char* destination, const int destinationSize)
{
	auto unmanagedString = Marshal::StringToHGlobalAnsi(source);
	strncpy(destination, (const char*)(void*)unmanagedString, destinationSize - 1);
	Marshal::FreeHGlobal(unmanagedString);
}
