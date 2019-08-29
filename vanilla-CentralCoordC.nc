#include <Timer.h>
#include "CentralCoord.h"
#include "printf.h"
 
 module CentralCoordC {
   uses interface Boot;
   uses interface Leds;
   uses interface Timer<TMilli> as Timer0;
   uses interface Packet;
   uses interface AMPacket;
   uses interface AMSend;
   uses interface SplitControl as AMControl;
   uses interface Receive;
}
 
 implementation {

	message_t pkt;
 	uint16_t temp;
 	uint8_t counter;
 	uint16_t data[18];

   	event void Boot.booted() {
		call AMControl.start();
	}

    event void AMControl.startDone(error_t err) {
		if (err == SUCCESS) {
   		}
		else {
		call AMControl.start();
		}
	}

	event void AMControl.stopDone(error_t err) {
	}

   

	event void AMSend.sendDone(message_t* msg, error_t error) {
	}

	event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
		if (len == sizeof(RCtoCCMsg)) {
			RCtoCCMsg* newpkt = (RCtoCCMsg*)payload;	
			temp = newpkt->nodeid;
			printf("data received from nodeid: %u \n", temp);
			if(temp == 1 || temp==2 || temp==3 || temp==4 || temp==5 || temp==6)
			{
			data[0] = newpkt->data1;
			data[1] = newpkt->data2;
			data[2] = newpkt->data3;
			data[3] = newpkt->data4;
			data[4] = newpkt->data5;
			data[5] = newpkt->data6;
			data[6] = newpkt->data7;
			data[7] = newpkt->data8;
			data[8] = newpkt->data9;
			data[9] = newpkt->data10;
			data[10] = newpkt->data11;
			data[11] = newpkt->data12;
			data[12] = newpkt->data13;
			data[13] = newpkt->data14;
			data[14] = newpkt->data15;
			data[15] = newpkt->data16;
			data[16] = newpkt->data17;
			data[17] = newpkt->data18;
			}
		}
		return msg;
	}
 }
