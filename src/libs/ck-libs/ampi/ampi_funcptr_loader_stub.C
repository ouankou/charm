
#include "ampi_funcptr_loader.h"

AMPI_FuncPtr_Unpack_t AMPI_FuncPtr_Unpack_Locate(SharedObject myexe)
{
  (void)myexe;
  return nullptr;
}

void AMPI_FuncPtr_Populate_Function(AMPI_FuncPtr_Unpack_t myPtrUnpack)
{
  (void)myPtrUnpack;
}

void AMPI_FuncPtr_Populate_Binary(SharedObject myexe)
{
  (void)myexe;
}
