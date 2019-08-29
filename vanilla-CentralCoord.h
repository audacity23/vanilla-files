#ifndef CENTRALCOORD_H
 #define CENTRALCOORD_H
 
 enum {
   AM_CENTRALCOORD = 6,
   TIMER_PERIOD_MILLI = 10
 };
 
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


 #endif
 
