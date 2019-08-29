#ifndef MOBILEDATA_H
 #define MOBILEDATA_H
 
enum {
   AM_MOBILEDATA = 6,
   TIMER_PERIOD_MILLI = 200
};
 
typedef nx_struct BroadcastMsg {	//Broadcast message structure    (ISME NODEID OF ALL THE EXISTING NODES KAISE BHEJE?)
  nx_uint16_t node_id;
} BroadcastMsg;

typedef nx_struct MobileMsg {	 //Mobile message to RC structure.
  nx_uint16_t node_id;		
  nx_uint16_t data;
} MobileMsg;

typedef nx_struct AckMsg {
  nx_uint16_t ackId;
} AckMsg;

 #endif
