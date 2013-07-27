#include "StdAfx.h"
#include "DynamicAssemblyResolver.h"

void DynamicAssemblyResolver::PrivatePath::set(String^ path) {
	_PrivatePath = path;
	AppDomain::CurrentDomain->AssemblyResolve += gcnew ResolveEventHandler(Resolve);
}

Assembly^ DynamicAssemblyResolver::Resolve(Object^ sender, ResolveEventArgs^ args)
{
	try
	{
    auto fullPrivatePath = Path::Combine(_PrivatePath, AssemblyFromQualifiedName(args->Name));
		return Assembly::LoadFrom(fullPrivatePath);
	}
	catch(...) { }

	return nullptr;
}

String^ DynamicAssemblyResolver::AssemblyFromQualifiedName(String^ qualifiedName)
{
		return qualifiedName->Substring(0, qualifiedName->IndexOf(",")) + ".dll";
}
