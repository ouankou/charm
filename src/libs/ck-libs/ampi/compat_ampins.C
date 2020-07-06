#include "charm-api.h"

typedef struct CmiIsomallocContext {
  void * opaque;
} CmiIsomallocContext;

CLINKAGE void AMPI_Node_Setup(int numranks);
void AMPI_Node_Setup(int numranks)
{
}

CLINKAGE void AMPI_Rank_Setup(int myrank, int numranks, CmiIsomallocContext ctx);
void AMPI_Rank_Setup(int myrank, int numranks, CmiIsomallocContext ctx)
{
}
