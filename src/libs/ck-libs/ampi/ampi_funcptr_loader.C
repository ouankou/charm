
#include "ampi_funcptr_loader.h"

#include <stdio.h>
#include <string.h>


static void AMPI_FuncPtr_Pack(struct AMPI_FuncPtr_Transport * x)
{
#define AMPI_CUSTOM_FUNC(return_type, function_name, ...) \
    x->function_name = function_name;
#if AMPI_HAVE_PMPI
  #define AMPI_FUNC(return_type, function_name, ...) \
      x->function_name = function_name; \
      x->P##function_name = P##function_name;
#else
  #define AMPI_FUNC AMPI_CUSTOM_FUNC
#endif
#define AMPI_FUNC_NOIMPL AMPI_FUNC

#include "ampi_functions.h"

#undef AMPI_FUNC
#undef AMPI_FUNC_NOIMPL
#undef AMPI_CUSTOM_FUNC
}

AMPI_FuncPtr_Unpack_t AMPI_FuncPtr_Unpack_Locate(SharedObject myexe)
{
  auto myPtrUnpack = (AMPI_FuncPtr_Unpack_t)dlsym(myexe, "AMPI_FuncPtr_Unpack");

  if (myPtrUnpack == nullptr)
  {
    CkError("dlsym error: %s\n", dlerror());
    CkAbort("Could not complete AMPI_FuncPtr_Unpack!");
  }

  return myPtrUnpack;
}

void AMPI_FuncPtr_Populate_Function(AMPI_FuncPtr_Unpack_t myPtrUnpack)
{
  // populate the user binary's function pointer shim
  AMPI_FuncPtr_Transport x;
  AMPI_FuncPtr_Pack(&x);
  myPtrUnpack(&x);
}

void AMPI_FuncPtr_Populate_Binary(SharedObject myexe)
{
  AMPI_FuncPtr_Populate_Function(AMPI_FuncPtr_Unpack_Locate(myexe));
}
