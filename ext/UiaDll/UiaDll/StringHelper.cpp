#include "StdAfx.h"
#include "StringHelper.h"

void StringHelper::CopyToUnmanagedString(String^ source, char* destination, const int destinationSize)
{
	auto unmanagedString = Marshal::StringToHGlobalAnsi(source);
	strncpy_s(destination, destinationSize, (const char*)(void*)unmanagedString,  _TRUNCATE);
	Marshal::FreeHGlobal(unmanagedString);
}

void StringHelper::Write(Exception^ error, char* destination, const int destinationSize)
{
    StringHelper::CopyToUnmanagedString(error->Message, destination, destinationSize);
}

char* StringHelper::UnmanagedStringFrom(String^ source)
{
	const int numberOfBytes = source->Length + 1;
	auto unmanagedString = new char[numberOfBytes];
	CopyToUnmanagedString(source, unmanagedString, numberOfBytes);
	return unmanagedString;
}

void StringHelper::FreeUp(const char* unmanagedStrings[], const int numberOfStrings)
{
	for(auto whichString = 0; whichString < numberOfStrings; ++whichString) {
		delete[] unmanagedStrings[whichString];
	}
}

int StringHelper::Copy(array<String^>^ strings, const char* unmanagedStrings[])
{
	if( NULL != unmanagedStrings ) {
    auto whichItem = 0;
    for each(String^ theString in strings) {
      unmanagedStrings[whichItem++] = UnmanagedStringFrom(theString);
    }
	}

	return strings->Length;
}

void StringHelper::CopyNames(AutomationElementCollection^ automationElements, const char* unmanagedStrings[])
{
	auto whichItem = 0;
	for each(AutomationElement^ automationElement in automationElements) {
		unmanagedStrings[whichItem++] = UnmanagedStringFrom(automationElement->Current.Name);
	}
}

void StringHelper::CopyClassNames(AutomationElementCollection^ automationElements, const char* unmanagedStrings[])
{
	auto whichItem = 0;
	for each(AutomationElement^ automationElement in automationElements) {
		unmanagedStrings[whichItem++] = UnmanagedStringFrom(automationElement->Current.ClassName);
	}
}