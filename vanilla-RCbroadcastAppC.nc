#include <Timer.h>
#include "RCbroadcast.h"
#include <printf.h>
 
 configuration RCbroadcastAppC {
 }
 implementation {
   components MainC;
   components LedsC;
   components RCbroadcastC as App;
   components new TimerMilliC() as Timer0;
   components new TimerMilliC() as TimerBroadcast;
   components new TimerMilliC() as TimerDataCycle;
   components new TimerMilliC() as TimerAck1;
   components ActiveMessageC;
   components new AMSenderC(AM_BROADCASTRC);
   components new AMReceiverC(AM_BROADCASTRC);
   components SerialPrintfC,SerialStartC;

   App.Boot -> MainC;
   App.Leds -> LedsC;
   App.Timer0 -> Timer0;
   App.Receive -> AMReceiverC;
   App.Packet -> AMSenderC;
   App.AMPacket -> AMSenderC;
   App.AMSend -> AMSenderC;
   App.AMControl -> ActiveMessageC;
   App.TimerAck1 -> TimerAck1;
   App.TimerBroadcast -> TimerBroadcast;
   App.TimerDataCycle -> TimerDataCycle;
 }
