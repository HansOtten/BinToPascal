BinToPascal

Utility to create Pascal include file from binary data files.

Requires a file called 'BintoPascal.ini' with on each line the information to create the include file.

Build with lazarus or Freepascal 
```
fpc BintoPascal.lpr
```
Example
```
wozmon.bin,wozmon.inc,wozmon,$1AA0
``` 
Input: binary file

Output file: text file

Example:
```
{ Binary include of wozmon.bin }
{ Date of BIN file  15/02/2025 14:46:14 }

wozmonsize = 327 ;
wozmonload = $1AA0 ;
wozmon: array[0..326] of byte =

  (
  $D8, $A2, $FF, $9A, $A9, $1B, $C9, $08, $F0, $16, $C9, $1B, $F0, $03, $C8, $10, 
  $1C, $A9, $0C, $20, $A6, $1B, $A9, $5C, $20, $A6, $1B, $20, $D6, $1B, $A0, $01, 
  .
  .
  $A5, $3A, $A8, $A5, $39, $60, $98, $85, $3A, $A9, $0D, $20, $A0, $1E, $A9, $0A, 
  $20, $A0, $1E, $A5, $3A, $A8, $60) ;    
'''
 Use as part of the KIM-1 Simulator build (and the TIM/Jolt Simulator) 
```
>BintoPascal.exe

Creating KIM-1 Simulator ROM include files
kimrom002 include file created
kimrom003 include file created
kimsimrom include file created
wozmon include file created
```

