#include "ComlibManager.h"

#if CHARM_MPI
#include "mpi.h"
#define MPI_MAX_MSG_SIZE 1000
#define MPI_BUF_SIZE 2000000
char mpi_sndbuf[MPI_BUF_SIZE];
char mpi_recvbuf[MPI_BUF_SIZE];
#endif

class MPIStrategy : public Strategy {
    CharmMessageHolder *messageBuf;
    int messageCount;

 public:
    MPIStrategy(int substrategy);
    void insertMessage(CharmMessageHolder *msg);
    void doneInserting();
};
