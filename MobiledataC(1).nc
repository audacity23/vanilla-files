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
  
	uint16_t count;
  	uint16_t temp;
	uint16_t server;
	uint16_t counter = 0;
	uint16_t slot= -1; // no slot allocated.
	uint16_t data;
	bool slotAllocated = FALSE;			
	
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
			server = newpkt->node_id;
			count = newpkt->Tot_nodes;
			temp = newpkt->free_nodes;
			switch (TOS_NODE_ID) {
				case newpkt->slot1 : slot = 0;
				case newpkt->slot2 : slot = 1;
				case newpkt->slot3 : slot = 2;
				case newpkt->slot4 : slot = 3;
				case newpkt->slot5 : slot = 4;
				case newpkt->slot6 : slot = 5;
				case newpkt->slot7 : slot = 6;
				case newpkt->slot8 : slot = 7;
				case newpkt->slot9 : slot = 8;
				case newpkt->slot10 : slot = 9;
				case newpkt->slot11 : slot = 10;
				case newpkt->slot12 : slot = 11;
				case newpkt->slot13 : slot = 12;
				case newpkt->slot14 : slot = 13;
				case newpkt->slot15 : slot = 14;
				case newpkt->slot16 : slot = 15;
				case newpkt->slot17 : slot = 16;
				case newpkt->slot18 : slot = 17;
				default : slot = -1;
			}
			if(slot == -1){
				slot = rand()%(temp) + (count-temp);			//this may be faulty
			}
			else{
				slotAllocated = TRUE;
			}
			
		return msg;
	}
    
    event void Timer0.fired(){
    	slotAllocated = FALSE;
    	counter = 0;
    	call Timer0.startPeriodic(10);
    }
    event void Timer1.fired() {				//when is timer1 getting fired?
		counter++;
		if(counter == slot+2){			//why slot+2?
			if(slotAllocated){
				if (!busy) {
					MobileMsg* newpkt = (MobileMsg*)(call Packet.getPayload(&pkt, sizeof(MobileMsg)));
					newpkt->data = slot;  //random data.				
					newpkt->nodeid = TOS_NODE_ID;
					newpkt->slot_id = slot;
					if (call AMSend.send(server, &pkt, sizeof(MobileMsg)) == SUCCESS) {
						busy = TRUE;
					}
				}
			}
			else{
				if (!busy) {
					REQMsg* newpkt = (REQMsg*)(call Packet.getPayload(&pkt, sizeof(REQMsg)));
					newpkt->nodeid = TOS_NODE_ID;
					newpkt->slot_id = slot;
					if (call AMSend.send(server, &pkt, sizeof(REQMsg)) == SUCCESS) {
						busy = TRUE;
					}
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
