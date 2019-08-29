#include <Timer.h>
 #include "RCbroadcast.h"
 #include "Mobiledata.h"
#include <printf.h>
 
 configuration MobiledataAppC {
 }
 implementation {
   components MainC;
   components LedsC;
   components MobiledataC as App;
   components new TimerMilliC() as Timer0;
   components new TimerMilliC() as Timer1;
//
   components ActiveMessageC;
   components new AMSenderC(AM_MOBILEDATA); 	
   components SerialPrintfC,SerialStartC;

   App.Boot -> MainC;
   App.Leds -> LedsC;
   App.Timer0 -> Timer0;
   App.Timer1 -> Timer1;
   App.Packet -> AMSenderC;
   App.AMPacket -> AMSenderC;
   App.AMSend -> AMSenderC;
   App.AMControl -> ActiveMessageC;

 }
