			//ack handle remaining
#include <Timer.h>
#include <stdlib.h>				//for the rand and srand function
#include "RCbroadcast.h"
#include "mobiledata.h"
#include "printf.h"
														
											
 
 module MobiledataC {
  uses interface Boot;
  uses interface Leds;
  uses interface Timer<TMilli> as Timer0;
  uses interface Timer<TMilli> as Timer1;
  uses interface Packet;
  uses interface AMPacket;
  uses interface AMSend;
  uses interface SplitControl as AMControl;
}
 
 implementation {

  bool busy = FALSE;
  message_t pkt;
  
  	uint16_t slot = TOS_NODE_ID - 6;
	uint16_t server;
	uint16_t counter = 0;
	uint16_t data;		
	int out = 0;
	
   	event void Boot.booted() {
		call AMControl.start();
	}

   	event void AMControl.startDone(error_t err) {
		if (err == SUCCESS) {
     		call Timer0.startPeriodic(600);			//doubtful about 600
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
			server = newpkt->node_id;
			out = 1;
			printf("broadcast received from : %u \n",server);
			}
		return msg;
	}
    
    event void Timer0.fired(){
    	counter = 0;
	if(out == 1)
    	{call Timer1.startPeriodic(10);}
    }
    event void Timer1.fired() {				//when is timer1 getting fired?
		counter++;
		if(counter == slot+2){			//why slot+2?
				if (!busy) {
					MobileMsg* newpkt = (MobileMsg*)(call Packet.getPayload(&pkt, sizeof(MobileMsg)));
					newpkt->data = data;  //random data.				
					newpkt->nodeid = TOS_NODE_ID;
					if (call AMSend.send(server, &pkt, sizeof(MobileMsg)) == SUCCESS) {
						busy = TRUE;
													  }
					   }
					   out = 0;
				}
	}

	event void AMSend.sendDone(message_t* msg, error_t error) {
		if (&pkt == msg) {
		  busy = FALSE;
		}
	}
}
