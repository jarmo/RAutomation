#pragma once
using namespace System::Windows::Automation;

ref class StringHelper
{
public:
	static void CopyToUnmanagedString(String^ source, char* destination, const int destinationSize);
	static char* UnmanagedStringFrom(String^ source);
	static void FreeUp(const char* unmanagedStrings[], const int numberOfStrings);
	static void CopyNames(AutomationElementCollection^ automationElements, const char* unmanagedStrings[]);
	static void CopyClassNames(AutomationElementCollection^ automationElements, const char* unmanagedStrings[]);
};

