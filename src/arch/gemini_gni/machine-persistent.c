/** @file
 * Elan persistent communication
 * @ingroup Machine
*/

/*
  included in machine.c
  Gengbin Zheng, 9/6/2011
*/

/*
  machine specific persistent comm functions:
  * LrtsSendPersistentMsg
  * CmiSyncSendPersistent
  * PumpPersistent
  * PerAlloc PerFree      // persistent message memory allocation/free functions
  * persist_machine_init  // machine specific initialization call
*/

#if USE_LRTS_MEMPOOL
#define LRTS_GNI_RDMA_PUT_THRESHOLD  2048
#else
#define LRTS_GNI_RDMA_PUT_THRESHOLD  16384
#endif

void LrtsSendPersistentMsg(PersistentHandle h, int destNode, int size, void *m)
{
    gni_post_descriptor_t *pd;
    gni_return_t status;
    RDMA_REQUEST        *rdma_request_msg;
    
    CmiAssert(h!=NULL);
    PersistentSendsTable *slot = (PersistentSendsTable *)h;
    CmiAssert(slot->used == 1);
    CmiAssert(CmiNodeOf(slot->destPE) == destNode);
    if (size > slot->sizeMax) {
        CmiPrintf("size: %d sizeMax: %d\n", size, slot->sizeMax);
        CmiAbort("Abort: Invalid size\n");
    }

    // CmiPrintf("[%d] LrtsSendPersistentMsg h=%p hdl=%d destNode=%d destAddress=%p size=%d\n", CmiMyPe(), h, CmiGetHandler(m), destNode, slot->destBuf[0].destAddress, size);

    if (slot->destBuf[0].destAddress) {
        // uGNI part
        MallocPostDesc(pd);
        if(size <= LRTS_GNI_RDMA_PUT_THRESHOLD) {
            pd->type            = GNI_POST_FMA_PUT;
        }
        else
        {
            pd->type            = GNI_POST_RDMA_PUT;
        }
        pd->cq_mode         = GNI_CQMODE_GLOBAL_EVENT;
        pd->dlvr_mode       = GNI_DLVMODE_PERFORMANCE;
        pd->length          = ALIGN64(size);
        pd->local_addr      = (uint64_t) m;
       
        pd->remote_addr     = (uint64_t)slot->destBuf[0].destAddress;
        pd->remote_mem_hndl = slot->destBuf[0].mem_hndl;
        pd->src_cq_hndl     = 0;//post_tx_cqh;     /* smsg_tx_cqh;  */
        pd->rdma_mode       = 0;
        pd->cqwrite_value   = PERSIST_SEQ;
        pd->amo_cmd         = 0;

        SetMemHndlZero(pd->local_mem_hndl);
#if CMK_SMP
#if REMOTE_EVENT
        bufferRdmaMsg(destNode, pd, (int)(size_t)(slot->destHandle));
#else
        bufferRdmaMsg(destNode, pd, -1);
#endif
#else
#if REMOTE_EVENT
        pd->cq_mode |= GNI_CQMODE_REMOTE_EVENT;
        int sts = GNI_EpSetEventData(ep_hndl_array[destNode], inst_id, ACK_EVENT((int)(slot->destHandle)));
        GNI_RC_CHECK("GNI_EpSetEventData", sts);
#endif

        status = registerMessage((void*)(pd->local_addr), pd->length, pd->cqwrite_value, &pd->local_mem_hndl);
        if (status == GNI_RC_SUCCESS) 
        {
        if(pd->type == GNI_POST_RDMA_PUT) 
            status = GNI_PostRdma(ep_hndl_array[destNode], pd);
        else
            status = GNI_PostFma(ep_hndl_array[destNode],  pd);
        }
        else
            status = GNI_RC_ERROR_RESOURCE;
        if(status == GNI_RC_ERROR_RESOURCE|| status == GNI_RC_ERROR_NOMEM )
        {
            bufferRdmaMsg(destNode, pd, -1);
        }else
            GNI_RC_CHECK("AFter posting", status);
#endif
    }
  else {
#if 1
    if (slot->messageBuf != NULL) {
      CmiPrintf("Unexpected message in buffer on %d\n", CmiMyPe());
      CmiAbort("");
    }
    slot->messageBuf = m;
    slot->messageSize = size;
#else
    /* normal send */
    PersistentHandle  *phs_tmp = phs;
    int phsSize_tmp = phsSize;
    phs = NULL; phsSize = 0;
    CmiPrintf("[%d]Slot sending message directly\n", CmiMyPe());
    CmiSyncSendAndFree(slot->destPE, size, m);
    phs = phs_tmp; phsSize = phsSize_tmp;
#endif
  }
}

#if 0
void CmiSyncSendPersistent(int destPE, int size, char *msg, PersistentHandle h)
{
  CmiState cs = CmiGetState();
  char *dupmsg = (char *) CmiAlloc(size);
  memcpy(dupmsg, msg, size);

  /*  CmiPrintf("Setting root to %d\n", 0); */
  CMI_SET_BROADCAST_ROOT(dupmsg, 0);

  if (cs->pe==destPE) {
    CQdCreate(CpvAccess(cQdState), 1);
    CdsFifo_Enqueue(CpvAccess(CmiLocalQueue),dupmsg);
  }
  else
    LrtsSendPersistentMsg(h, destPE, size, dupmsg);
}
#endif

extern void CmiReference(void *blk);

#if 0

/* called in PumpMsgs */
int PumpPersistent()
{
  int status = 0;
  PersistentReceivesTable *slot = persistentReceivesTableHead;
  while (slot) {
    char *msg = slot->messagePtr[0];
    int size = *(slot->recvSizePtr[0]);
    if (size)
    {
      int *footer = (int*)(msg + size);
      if (footer[0] == size && footer[1] == 1) {
/*CmiPrintf("[%d] PumpPersistent messagePtr=%p size:%d\n", CmiMyPe(), slot->messagePtr, size);*/

#if 0
      void *dupmsg;
      dupmsg = CmiAlloc(size);
                                                                                
      _MEMCHECK(dupmsg);
      memcpy(dupmsg, msg, size);
      memset(msg, 0, size+2*sizeof(int));
      msg = dupmsg;
#else
      /* return messagePtr directly and user MUST make sure not to delete it. */
      /*CmiPrintf("[%d] %p size:%d rank:%d root:%d\n", CmiMyPe(), msg, size, CMI_DEST_RANK(msg), CMI_BROADCAST_ROOT(msg));*/

      CmiReference(msg);
      swapRecvSlotBuffers(slot);
#endif

      CmiPushPE(CMI_DEST_RANK(msg), msg);
#if CMK_BROADCAST_SPANNING_TREE
      if (CMI_BROADCAST_ROOT(msg))
          SendSpanningChildren(size, msg);
#endif
      /* clear footer after message used */
      *(slot->recvSizePtr[0]) = 0;
      footer[0] = footer[1] = 0;

#if 0
      /* not safe at all! */
      /* instead of clear before use, do it earlier */
      msg=slot->messagePtr[0];
      size = *(slot->recvSizePtr[0]);
      footer = (int*)(msg + size);
      *(slot->recvSizePtr[0]) = 0;
      footer[0] = footer[1] = 0;
#endif
      status = 1;
      }
    }
    slot = slot->next;
  }
  return status;
}

#endif

void *PerAlloc(int size)
{
//  return CmiAlloc(size);
  gni_return_t status;
  void *res = NULL;
  size = ALIGN64(size) + sizeof(CmiChunkHeader);
  if (0 != posix_memalign(&res, 64, size))
      CmiAbort("PerAlloc: failed to allocate memory.");
  //printf("[%d] PerAlloc %p. \n", myrank, res);
  char *ptr = (char*)res+sizeof(CmiChunkHeader);
  SIZEFIELD(ptr)=size;
  REFFIELD(ptr)=1;
#if  CQWRITE || CMK_PERSISTENT_COMM
  MEMORY_REGISTER(onesided_hnd, nic_hndl,  res, size , &MEMHFIELD(ptr), &omdh, rdma_rx_cqh, status);
#else
  MEMORY_REGISTER(onesided_hnd, nic_hndl,  res, size , &MEMHFIELD(ptr), &omdh, NULL, status);
#endif
  GNI_RC_CHECK("Mem Register before post", status);
  return ptr;
}
                                                                                
void PerFree(char *msg)
{
//  CmiFree(msg);
  char *ptr = msg-sizeof(CmiChunkHeader);
  MEMORY_DEREGISTER(onesided_hnd, nic_hndl, &MEMHFIELD(msg) , &omdh, SIZEFIELD(msg));
  free(ptr);
}

/* machine dependent init call */
void persist_machine_init(void)
{
}

void initSendSlot(PersistentSendsTable *slot)
{
  int i;
  slot->used = 0;
  slot->destPE = -1;
  slot->sizeMax = 0;
  slot->destHandle = 0; 
#if 0
  for (i=0; i<PERSIST_BUFFERS_NUM; i++) {
    slot->destAddress[i] = NULL;
    slot->destSizeAddress[i] = NULL;
  }
#endif
  memset(&slot->destBuf, 0, sizeof(PersistentBuf)*PERSIST_BUFFERS_NUM);
  slot->messageBuf = 0;
  slot->messageSize = 0;
}

void initRecvSlot(PersistentReceivesTable *slot)
{
  int i;
#if 0
  for (i=0; i<PERSIST_BUFFERS_NUM; i++) {
    slot->messagePtr[i] = NULL;
    slot->recvSizePtr[i] = NULL;
  }
#endif
  memset(&slot->destBuf, 0, sizeof(PersistentBuf)*PERSIST_BUFFERS_NUM);
  slot->sizeMax = 0;
  slot->index = -1;
  slot->prev = slot->next = NULL;
}

void setupRecvSlot(PersistentReceivesTable *slot, int maxBytes)
{
  int i;
  for (i=0; i<PERSIST_BUFFERS_NUM; i++) {
    char *buf = PerAlloc(maxBytes+sizeof(int)*2);
    _MEMCHECK(buf);
    memset(buf, 0, maxBytes+sizeof(int)*2);
    slot->destBuf[i].mem_hndl = MEMHFIELD(buf);
    slot->destBuf[i].destAddress = buf;
    /* note: assume first integer in elan converse header is the msg size */
    slot->destBuf[i].destSizeAddress = (unsigned int*)buf;
#if USE_LRTS_MEMPOOL
    // assume already registered from mempool
    // slot->destBuf[i].mem_hndl = GetMemHndl(buf);
#endif
    // FIXME:  assume always succeed
  }
  slot->sizeMax = maxBytes;
#if REMOTE_EVENT
  slot->index = IndexPool_getslot(&ackPool, slot->destBuf[0].destAddress, 2);
#endif
}


PersistentHandle getPersistentHandle(PersistentHandle h)
{
#if REMOTE_EVENT
  return (PersistentHandle)(((PersistentReceivesTable*)h)->index);
#else
  return h;
#endif
}
