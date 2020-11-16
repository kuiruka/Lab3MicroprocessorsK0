#include <xc.inc>
	
global	DAC_Setup, DAC_Int_Hi
    
psect	dac_code, class=CODE
	
DAC_Int_Hi:	
	;btfss	TMR0IF		; check that this is timer0 interrupt
	btfss  CCP4IF
	retfie	f		; if not then return
	incf	LATJ, F, A	; increment PORTD
	;bcf	TMR0IF		; clear interrupt flag
	bcf     CCP4IF
	retfie	f		; fast return from interrupt

DAC_Setup:
	clrf	TRISJ, A	; Set PORTD as all outputs
	clrf	LATJ, A		; Clear PORTD outputs
	
	movlw   00001010B       ; CCP4 compare mode, software interrupt only
	movwf   CCP4CON, A
	
	movlw   00000000B       ; Timer1 is selected
	movwf   CCPTMRS1,A
	
	movlw   0x0a		; The value to compare with TMRH:TMRL
	movwf   CCPR4L,A
	movlw   0x00
	movwf   CCPR4H,A
	movlw   00110011B       ; Set timer1 to 16-bit, Fosc/4/8, 500kHz
	movwf   T1CON,A

	;movlw	10000111B	; Set timer0 to 16-bit, Fosc/4/256
	;movwf	T0CON, A	; = 62.5KHz clock rate, approx 1sec rollover
	;bsf	TMR0IE		; Enable timer0 interrupt
	
	;bsf	GIE		; Enable all interrupts
	;bsf     PEIE
	
	movlw  11000000B       ; no priority, global interrupt enable
	movwf  INTCON, A       ; GIE, PEIE	
	
	;movlw  00000010B
	;movwf  PIE4, A
	bsf     CCP4IE         ; ;CCP interrupt enable. PIE4<1>
	return
	
	end

