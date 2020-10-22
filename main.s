	#include <pic18_chip_select.inc>
	#include <xc.inc>

psect	code, abs
	
main:
	org	0x0
	goto	start

	org	0x100		    ; Main code starts here at address 0x100
	cntr1   equ 0x06
	dcntr1  equ 0x01
	dcntr2  equ 0x02
	dcntr3  equ 0x03
start:
	movlw 	0x0
	movwf	TRISC, A	    ; Port C all outputs
	movwf   cntr1, A
loop:
	movff 	cntr1, PORTC
	incf 	cntr1, F, A
	rcall   delay1s
test:
	movlw 	0x63
	cpfsgt 	cntr1, A
	bra 	loop		    ; Not yet finished goto start of loop again
	goto 	0x0		    ; Re-run program from start
;-------------------------
;functions
;-------------------------
;delay 2 + 3x255 + 2 = 769 Cycle = 3076 clocks = 3076 * 15.625 ns = 48 us
delay48us:
	movlw   0xff                ; 1C
	movwf   dcntr1, A            ; 1C
dloop:	decfsz	dcntr1, F, A         ; 1(2)C
	bra     dloop               ; 2C
  	return

delay12ms:
	movlw  0xff
	movwf  dcntr2, A
dloop2: rcall  delay48us
	decfsz dcntr2, F, A
	bra    dloop2
	return
	
delay1s:
	movlw  0x53 ;83
	movwf  dcntr3, A
dloop3: rcall  delay12ms
	decfsz dcntr3, F, A
	bra    dloop3
	return	
	
	end	main
