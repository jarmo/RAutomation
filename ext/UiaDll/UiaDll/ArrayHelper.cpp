#include "StdAfx.h"
#include "ArrayHelper.h"


int ArrayHelper::Copy(array<int, 1>^ source, int destination[])
{
  if( NULL != destination ) {
    auto index = 0;
    for each(auto value in source) {
      destination[index++] = value;
    }
  }
  return source->Length;
}
