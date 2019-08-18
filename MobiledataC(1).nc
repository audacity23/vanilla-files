// Source node
#include <Timer.h>
#include "RCbroadcast.h"
#include "mobiledata.h"
#include "printf.h"
														//different frequencies pe msg ko sunna hai...?
														//time sync kaha initialise hoga?
 
 module MobiledataC {
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
  
  	uint16_t count;
  	uint16_t temp;
	uint16_t counter;

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

	event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
		if (len == sizeof(BroadcastMsg)) {
			BroadcastMsg* newpkt = (BroadcastMsg*)payload;
			temp = newpkt->nodeid;
				counter = newpkt->counter;
				//slot = newpkt->broadcasttable;					//fixing the slot of sending data to RC.
				call Leds.set(newpkt->counter);
				printf("node number : %u \t",temp);
			}
		return msg;
	}
    	event void Timer0.fired() {				//apne slot me data bhejna hai
		counter++;
		count++;	
		if(count == slot)						//counter value equal to slot
		{if (!busy) {
			MobileMsg* newpkt = (MobileMsg*)(call Packet.getPayload(&pkt, sizeof(MobileMsg)));
			//newpkt->data = 1;
			newpkt->nodeid = TOS_NODE_ID;
			newpkt->counter = counter;
			newpkt->data = ??			//kya data bhejna hai?
			if (call AMSend.send(temp, &pkt, sizeof(BroadcastMsg)) == SUCCESS) {
				busy = TRUE;
				}
		}
	}
	}

	// event void sendDone(message_t* msg, error_t error) {
	// }

	event void AMSend.sendDone(message_t* msg, error_t error) {
		if (&pkt == msg) {
		  busy = FALSE;
		}
	}
}
 
