#include <EEPROM.h>
byte i,dmx, score[36];		//	i: loop variable; 	score[]: Score array 

/** Used to set modes for each pin (Input/Output).
  * Clears EEPROM and sets up UART.
  * Called when the board is powered up.
  */
void setup()		
{
	//Set modes of all the output pins
	for(i=2;i<20;i++)
		pinMode(i,OUTPUT);

	//Refresh EEPROM by writing a zero value to all locations
	for(i=0;i<36;i++)
	{
		EEPROM.write(i,0);
	}
	
	//Initialize Serial Communication at baud rate 9600
	Serial.begin(9600);
	
	//Read score stored in EEPROM 
	for(i=0;i<=35;i++)
		score[i] = EEPROM.read(i);

}

/** Reads data via Serial UART and writes to EEPROM */
void writes()			
{
//Check if the required data is present in the serial buffer
if(Serial.available()==36)
	for(i=0;i<=35;i++)				//Write value to EEPROM
		EEPROM.write(i,Serial.read());

//Populate score array from EEPROM values
for(i=0;i<=35;i++)
	score[i] = EEPROM.read(i);
}

/** Select and toggle the DEMUX channels */
void demux()			
{
for(i=0;i<=5;i++)
	digitalWrite(14+i,LOW);		//	to clear previous values

byte n, temp=dmx;

//Converts the value of 'dmx' to 6-bit binary format and writes value to the demultiplexer pins
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

/** Generates pin mappings corresponding to the current digit to be displayed */
void disp()		
{
for(i=2;i<=8;i++)				//Clear previous values
	digitalWrite(i,LOW);

//Check the digit to be displayed and activate pins accordingly
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

/** Executed over and over continuously after execution of 'void setup(){...}' */
void loop()
{

//Check Serial port for data. If found, write to EEPROM.
writes();

//Iterate through all the 36 7-segment displays and all 36 values in memory
for(dmx=0;dmx<=35;dmx++){
	//Activate appropriate DEMUX channel
	demux();
	
	//Print character on 7-segment display
	disp();
	
	/** Add delay to facilitate persistence of vision effect.
	  * Also prevents overheating of demultiplexer due to fast switching
	  */
	delayMicroseconds(200);               
	}
}


