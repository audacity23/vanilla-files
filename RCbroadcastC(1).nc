// Source node
#include <Timer.h>
#include "RCbroadcast.h"
#include "CentralCoord.h"
#include "mobiledata.h"
#include "printf.h"
														
 
 module RCbroadcastC {
  uses interface Boot;
  uses interface Leds;
  uses interface Timer<TMilli> as Timer0;
  uses interface Packet;
  uses interface AMPacket;
  uses interface AMSend;
  uses interface SplitControl as AMControl;
}
 
 implementation {

  bool busy = FALSE;
  message_t pkt;
  uint16_t count=0;
  uint16_t sender;
  uint16_t data;
  
	uint8_t counter;

   event void Boot.booted() {
	call AMControl.start();
	}

   event void AMControl.startDone(error_t err) {
	if (err == SUCCESS) {
     	call Timer0.startPeriodic(TIMER_PERIOD_MILLI);
	}
	else {
	call AMControl.start();
	}
}

	event void AMControl.stopDone(error_t err) {
	}

->	event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
		if (len == sizeof(MobileMsg)) {
			MobileMsg* newpkt = (MobileMsg*)payload;
			sender = newpkt->nodeid;
			data = newpkt->data;
			}
		return msg;
	}
    	event void Timer0.fired() {
		counter++;	
		if (!busy) {
			BroadcastMsg* newpkt = (BroadcastMsg*)(call Packet.getPayload(&pkt, sizeof(BroacastMsg)));
			newpkt->nodeid = TOS_NODE_ID;
			if (call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(BroadcastMsg)) == SUCCESS) {
				busy = TRUE;
				}
		}
	}

	event void AMSend.sendDone(message_t* msg, error_t error) {
		if (&pkt == msg) {
		  busy = FALSE;
		}
	}
}
 
