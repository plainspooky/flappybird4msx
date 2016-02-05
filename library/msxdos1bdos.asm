;
; MSX-DOS1 BDOS Routines 
; Version 0.1
;
MSXDOS:				equ 0x0005
DISKBASIC:			equ 0xF37D

Boot:				equ 0x00
GetCharAndEcho:		equ 0x01
PutChar:			equ 0x02
ReadSerial:			equ 0x03
WriteSerial:		equ 0x04
WritePrinter:		equ 0x05
ReadKey:			equ 0x06
WaitKey:			equ 0x07
GetChar:			equ 0x08
PutString:			equ 0x09
GetString:			equ 0x0A
KeyboardStatus:		equ 0x0B
GetSysVersion:		equ 0x0C
RefreshDiskInfo:	equ 0x0D
SetCurrentDrive		equ 0x0E
OpenFile:			equ 0x0F
UpdateFile:			equ 0x10
FindFirst:			equ 0x11
FindNext:			equ 0x12
DeleteFile:			equ 0x13
ReadBlock:			equ 0x14
WriteBlock:			equ 0x15
CreateFile:			equ 0x16
RenameFiles:		equ 0x17
GetSysDrives:		equ 0x18
GetCurrentDrive:	equ 0x19
SetBuffer:			equ 0x1A
GetDiskInfo:		equ 0x1B
ReadRecord:			equ 0x21
WriteRecord:		equ 0x22
GetFileSize:		equ 0x23
ReadNextRecord:		equ 0x24
ReadRecords:		equ 0x27
WriteRecords:		equ 0x28
GetDate:			equ 0x2A
SetDate:			equ 0x2B
GetTime:			equ 0x2C
SetTime:			equ 0x2D
ReadSectors:		equ 0x2F
WriteSectors:		equ 0x30
