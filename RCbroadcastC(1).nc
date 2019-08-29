#include <Timer.h>
#include "RCbroadcast.h"
#include "CentralCoord.h"
#include "mobiledata.h"
#include "printf.h"
														
 
module RCbroadcastC {
	uses interface Boot;
	uses interface Leds;
	uses interface Timer<TMilli> as Timer0;
	uses interface Timer<TMilli> as TimerAck1;
  	uses interface Timer<TMilli> as TimerBroadcast;
  	uses interface Timer<TMilli> as TimerDataCycle;
	uses interface Packet;
	uses interface AMPacket;
	uses interface AMSend;
	uses interface SplitControl as AMControl;
}
 
implementation {
	
	bool busy = FALSE;
	message_t pkt;
  	uint16_t nodeid[18];			
  	int i=0;
	int index = 0;
	uint32_t myid = TOS_NODE_ID;	//new
	uint16_t temp;
  	uint16_t temp_slotid;
  	uint16_t data[18];			
  	uint16_t newnode;
  	uint32_t delay = 10; // time for msg transmission.
  	uint32_t ackTime = 5; //time for ack fire.
  	int counter = 0;
	bool newAck = FALSE;
	int breaks = 0;				//new
	uint32_t delayforsendingtoCC = 300;		//new

   	event void Boot.booted() {
		call AMControl.start();
	}

   	event void AMControl.startDone(error_t err) {
		if (err == SUCCESS) {
			for(i = 0 ; i< 18 ;i++){
				data[i] = -1; // intially no data is available
				nodeid[i] = -1; // intially all slots are free
			}
     		call Timer0.startPeriodic(TIMER_PERIOD_MILLI);
     		call TimerDataCycle.startPeriodicAt(myid*100,delayforsendingtoCC);		//new, accepts only uint32_t
		}
		else {
		call AMControl.start();
		}
	}

	event void AMControl.stopDone(error_t err) {
	}

	event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
		if (len == sizeof(MobileMsg)) {			
			MobileMsg* newpkt = (MobileMsg*)payload;
			temp = newpkt->node_id;
			data[index] = newpkt->data; 
			index++;
			call TimerAck1.startOneShot(ackTime); 
			}
		}
		return msg;
	}
    
    event void Timer0.fired() { //generic timer.
    		for(i=0;i<(totalslots-freeslots);i++)			//new
		{
		if(counters[i] == 3)
		{
		nodeid[i] = -1;
		freeslots++;
		breaks = 1;
		}
		counters[i]++;
		}
		if(breaks == 1)
		{
		call TimerBroadcast.startOneShot(delay);
		}
		breaks = 0;
		counter++;
		/*if(counter % 3 == 0){				 
			counter = 0; //reset counter for new cycle.
			for( i = 0; i< 18;i++){
				nodeid[i] = -1; //reset all slot info	
			}
			freeslots++;
			call TimerBroadcast.startOneShot(delay);
		}*/
			if(newAck == TRUE){				
				call TimerBroadcast.startOneShot(delay);
			}
			else{
				counter = 0; //reset counter for new cycle.
			}
	}

	event void TimerBroadcast.fired() {
		if (!busy) {
			BroadcastMsg* newpkt = (BroadcastMsg*)(call Packet.getPayload(&pkt, sizeof(BroacastMsg)));
			newpkt->node_id = TOS_NODE_ID;
			if (call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(BroadcastMsg)) == SUCCESS) {
				busy = TRUE;
			}
		}
	}

	event void TimerDataCycle.fired() { //generic timer.
		if (!busy) {
			RCtoCCMsg* newpkt = (RCtoCCMsg*)(call Packet.getPayload(&pkt, sizeof(BroacastMsg)));
			newpkt->node_id = TOS_NODE_ID; 
			newpkt->data1 = data[0];
			newpkt->data2 = data[1];
			newpkt->data3 = data[2];
			newpkt->data4 = data[3];
			newpkt->data5 = data[4];
			newpkt->data6 = data[5];
			newpkt->data7 = data[6];
			newpkt->data8 = data[7];
			newpkt->data9 = data[8];
			newpkt->data10 = data[9];
			newpkt->data11 = data[10];
			newpkt->data12 = data[11];
			newpkt->data13 = data[12];
			newpkt->data14 = data[13];
			newpkt->data15 = data[14];
			newpkt->data16 = data[15];
			newpkt->data17 = data[16];
			newpkt->data18 = data[17];
			if (call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(RCtoCCMsg)) == SUCCESS) {
				busy = TRUE;
				//clear all stored data info for new cycle.
				for(i = 0 ; i< 18 ;i++){
					data[i] = -1; 
				}
			}
		}
	}
	event void TimerAck1.fired() {
		if (!busy) {
			AckMsg* newpkt = (AckMsg*)(call Packet.getPayload(&pkt, sizeof(AckMsg)));
			newpkt->ackId = 1; // ackId = 1 is success , 2 is failure.
			if (call AMSend.send(temp, &pkt, sizeof(AckMsg)) == SUCCESS) { //send ack to the node which sent the data
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
