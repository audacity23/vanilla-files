// Source node
#include <Timer.h>
#include "RCbroadcast.h"
#include "mobiledata.h"
#include "printf.h"
														
														
 
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
  
  	uint16_t count = 0;
  	uint16_t temp;
	uint16_t server;
	uint16_t data;			//garbage data
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
			server = newpkt->nodeid;
				printf("BC packet recieved from : %u \t",server);
			}
		return msg;
	}
    	event void Timer0.fired() {				
		count++;	
		if(count == TOS_NODE_ID)						//count value equal to the nodeid.
		{if (!busy) {
			MobileMsg* newpkt = (MobileMsg*)(call Packet.getPayload(&pkt, sizeof(MobileMsg)));
			newpkt->data = data;
			newpkt->nodeid = TOS_NODE_ID;
			if (call AMSend.send(server, &pkt, sizeof(MobileMsg)) == SUCCESS) {
				busy = TRUE;
				}
		}
	}
	}


	event void AMSend.sendDone(message_t* msg, error_t error) {
		if (&pkt == msg) {
		  busy = FALSE;
		}
	}
}
 
