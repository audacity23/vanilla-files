#ifndef CENTRALCOORD_H
 #define CENTRALCOORD_H
 
 enum {
   AM_CENTRALCOORD = 6,
   TIMER_PERIOD_MILLI = 10
 };
 
typedef nx_struct RCtoCCMsg {
  nx_uint16_t nodeid;
  nx_uint16_t data;
} RCtoCCMsg;


 #endif
 
