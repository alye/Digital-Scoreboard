#include <EEPROM.h>
byte i,dmx, score[36];		//	i: loop variable; 	score[]: Score array 

void setup()
{
for(i=2;i<20;i++)
pinMode(i,OUTPUT);

for(i=0;i<36;i++)
{
EEPROM.write(i,0);
}
Serial.begin(9600);

for(i=0;i<=35;i++)
score[i] = EEPROM.read(i);

}

void writes()			//	function to write the serial data to EEPROM
{
if(Serial.available()==36)
	for(i=0;i<=35;i++)
	EEPROM.write(i,Serial.read());

for(i=0;i<=35;i++)
score[i] = EEPROM.read(i);
}

void demux()			//	Function to select DEMUX channel
{
for(i=0;i<=5;i++)
digitalWrite(14+i,LOW);		//	to clear previous values
byte n, temp=dmx;
for(i=0;i<=5;i++)
	{
	n=temp%2;
	if(n==1)
	digitalWrite(14+i,HIGH);
	else if(n==0)
	digitalWrite(14+i,LOW);
	temp=temp/2;
	}

}

void disp()			//	Function to display the corresponding digit
{
for(i=2;i<=8;i++)		//	to clear previous values
digitalWrite(i,LOW);

switch(score[dmx])
	{
		case 0: 
			digitalWrite(2,HIGH);
			digitalWrite(3,HIGH);
			digitalWrite(4,HIGH);
			digitalWrite(5,HIGH);
			digitalWrite(6,HIGH);
			digitalWrite(7,HIGH);
			break;

		case 1: 
			digitalWrite(3,HIGH);
			digitalWrite(4,HIGH);
			break;

		case 2: 
			digitalWrite(2,HIGH);
			digitalWrite(3,HIGH);
			digitalWrite(5,HIGH);
			digitalWrite(6,HIGH);
			digitalWrite(8,HIGH);
			break;

		case 3: 
			digitalWrite(2,HIGH);
			digitalWrite(3,HIGH);
			digitalWrite(4,HIGH);
			digitalWrite(5,HIGH);
			digitalWrite(8,HIGH);
			break;

		case 4: 
			digitalWrite(3,HIGH);
			digitalWrite(4,HIGH);
			digitalWrite(7,HIGH);
			digitalWrite(8,HIGH);
			break;

		case 5: 
			digitalWrite(2,HIGH);
			digitalWrite(4,HIGH);
			digitalWrite(5,HIGH);
			digitalWrite(7,HIGH);
			digitalWrite(8,HIGH);
			break;

		case 6: 
			digitalWrite(2,HIGH);
			digitalWrite(4,HIGH);
			digitalWrite(5,HIGH);
			digitalWrite(6,HIGH);
			digitalWrite(7,HIGH);
			digitalWrite(8,HIGH);
			break;

		case 7: 
			digitalWrite(2,HIGH);
			digitalWrite(3,HIGH);
			digitalWrite(4,HIGH);
			break;

		case 8: 
			digitalWrite(2,HIGH);
			digitalWrite(3,HIGH);
			digitalWrite(4,HIGH);
			digitalWrite(5,HIGH);
			digitalWrite(6,HIGH);
			digitalWrite(7,HIGH);
			digitalWrite(8,HIGH);
			break;

		case 9: 
			digitalWrite(2,HIGH);
			digitalWrite(3,HIGH);
			digitalWrite(4,HIGH);
			digitalWrite(7,HIGH);
			digitalWrite(8,HIGH);
			break;

	}

}

void loop()
{
writes();
for(dmx=0;dmx<=35;dmx++)
	{
	demux();
	disp();
	delayMicroseconds(200);
	}
}


