#ifndef MOBILEDATA_H
 #define MOBILEDATA_H
 
 enum {
   AM_MOBILEDATA = 6,
   TIMER_PERIOD_MILLI = 10
 };
 
typedef nx_struct MobileMsg {	//Mobile message structure?
  nx_uint16_t nodeid;	
  nx_uint16_t data;
} MobileMsg;

typedef nx_struct BroadcastMsg {	//Broadcast message structure
  nx_uint16_t nodeid;
 // nx_uint16_t data;
} BroadcastMsg;


 #endif
