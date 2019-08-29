#ifndef RCBROADCAST_H
 #define RCBROADCAST_H
 
 enum {
   AM_BROADCASTRC = 6,
   TIMER_PERIOD_MILLI = 200
 };
 
typedef nx_struct BroadcastMsg {	//Broadcast message structure    (ISME NODEID OF ALL THE EXISTING NODES KAISE BHEJE?)
  nx_uint16_t node_id;
} BroadcastMsg;

typedef nx_struct RCtoCCMsg {	//RC to CC message structure
  nx_uint16_t node_id;
  nx_uint16_t data1;
  nx_uint16_t data2;
  nx_uint16_t data3;
  nx_uint16_t data4;
  nx_uint16_t data5;
  nx_uint16_t data6;
  nx_uint16_t data7;
  nx_uint16_t data8;
  nx_uint16_t data9;
  nx_uint16_t data10;
  nx_uint16_t data11;
  nx_uint16_t data12;
  nx_uint16_t data13;
  nx_uint16_t data14;
  nx_uint16_t data15;
  nx_uint16_t data16;
  nx_uint16_t data17;
  nx_uint16_t data18;
} RCtoCCMsg;


typedef nx_struct MobileMsg {	 //Mobile message to RC structure.
  nx_uint16_t node_id;		
  nx_uint16_t data;
} MobileMsg;

typedef nx_struct AckMsg {
  nx_uint16_t ackId;
} AckMsg;


 #endif
