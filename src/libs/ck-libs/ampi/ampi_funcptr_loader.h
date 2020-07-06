#ifndef AMPI_FUNCPTR_LOADER_H_
#define AMPI_FUNCPTR_LOADER_H_

#include "ampiimpl.h"
#include "ampi_funcptr.h"

typedef int (*AMPI_FuncPtr_Unpack_t)(struct AMPI_FuncPtr_Transport *);

AMPI_FuncPtr_Unpack_t AMPI_FuncPtr_Unpack_Locate(SharedObject);
void AMPI_FuncPtr_Populate_Function(AMPI_FuncPtr_Unpack_t);
void AMPI_FuncPtr_Populate_Binary(SharedObject);

#endif /* AMPI_FUNCPTR_LOADER_H_ */
