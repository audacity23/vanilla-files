#ifndef MOBILEDATA_H
 #define MOBILEDATA_H
 
enum {
   AM_MOBILEDATA = 6,
   TIMER_PERIOD_MILLI = 200
};
 
typedef nx_struct BroadcastMsg {	//Broadcast message structure    (ISME NODEID OF ALL THE EXISTING NODES KAISE BHEJE?)
  nx_uint16_t node_id;
  /*nx_uint16_t Tot_nodes;		// N
  nx_uint16_t free_nodes; // M
  nx_uint16_t slot1;  
  nx_uint16_t slot2;
  nx_uint16_t slot3;
  nx_uint16_t slot4;         
  nx_uint16_t slot5;
  nx_uint16_t slot6;
  nx_uint16_t slot7;
  nx_uint16_t slot8;
  nx_uint16_t slot9;
  nx_uint16_t slot10;
  nx_uint16_t slot11;
  nx_uint16_t slot12;
  nx_uint16_t slot13;
  nx_uint16_t slot14;
  nx_uint16_t slot15;
  nx_uint16_t slot16;
  nx_uint16_t slot17;
  nx_uint16_t slot18;*/
} BroadcastMsg;*/

typedef nx_struct MobileMsg {	 //Mobile message to RC structure.
  nx_uint16_t node_id;		
  nx_uint16_t data;
  //nx_uint16_t slot_id;
} MobileMsg;

/*typedef nx_struct REQMsg {
 nx_uint16_t node_id;
 nx_uint16_t slot_id;
} REQMsg;

typedef nx_struct AckMsg {
  nx_uint16_t ackId;
} AckMsg;*/

 #endif
