#pragma once
ref class StringHelper
{
public:
	static void CopyToUnmanagedString(String^ source, char* destination, const int destinationSize);
	static char* UnmanagedStringFrom(String^ source);
};

