#include "StdAfx.h"
#include "StringHelper.h"

void StringHelper::CopyToUnmanagedString(String^ source, char* destination, const int destinationSize)
{
	auto unmanagedString = Marshal::StringToHGlobalAnsi(source);
	strncpy(destination, (const char*)(void*)unmanagedString, destinationSize);
	Marshal::FreeHGlobal(unmanagedString);
}

char* StringHelper::UnmanagedStringFrom(String^ source)
{
	const int numberOfBytes = source->Length + 1;
	auto unmanagedString = new char[numberOfBytes];
	CopyToUnmanagedString(source, unmanagedString, numberOfBytes);
	return unmanagedString;
}