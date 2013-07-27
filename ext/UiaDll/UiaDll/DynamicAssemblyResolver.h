#pragma once
using namespace System::IO;
using namespace System::Reflection;

ref class DynamicAssemblyResolver
{
public:
  static property String^ PrivatePath {
    void set(String^ value);
  }

private:
  static String^ _PrivatePath = nullptr;
  static Assembly^ Resolve(Object^ sender, ResolveEventArgs^ args);
  static String^ AssemblyFromQualifiedName(String^ qualifiedName);
};