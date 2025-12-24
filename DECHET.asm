
_main:

;DECHET.c,31 :: 		void main() {
;DECHET.c,33 :: 		TRISA = 0b00010011;
	MOVLW      19
	MOVWF      TRISA+0
;DECHET.c,34 :: 		TRISB = 0b11110011;
	MOVLW      243
	MOVWF      TRISB+0
;DECHET.c,35 :: 		TRISC = 0x00;       //OUTPUT led+buzzer+moteur
	CLRF       TRISC+0
;DECHET.c,36 :: 		TRISD = 0x00;       // LCD
	CLRF       TRISD+0
;DECHET.c,38 :: 		PORTA = 0;
	CLRF       PORTA+0
;DECHET.c,39 :: 		PORTC = 0;
	CLRF       PORTC+0
;DECHET.c,40 :: 		PORTD = 0;
	CLRF       PORTD+0
;DECHET.c,42 :: 		ADC_Init();
	CALL       _ADC_Init+0
;DECHET.c,43 :: 		Lcd_Init();
	CALL       _Lcd_Init+0
;DECHET.c,44 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;DECHET.c,45 :: 		PORTC.RC0 = 0; // LED verte OFF
	BCF        PORTC+0, 0
;DECHET.c,46 :: 		PORTC.RC1 = 0; // LED rouge OFF
	BCF        PORTC+0, 1
;DECHET.c,47 :: 		PORTC.RC2 = 0; // LED jaune OFF
	BCF        PORTC+0, 2
;DECHET.c,48 :: 		PORTC.RC3 = 0; // Servomoteur OFF
	BCF        PORTC+0, 3
;DECHET.c,49 :: 		PORTC.RC4 = 0; // Buzzer OFF
	BCF        PORTC+0, 4
;DECHET.c,52 :: 		TMR0 = 254;
	MOVLW      254
	MOVWF      TMR0+0
;DECHET.c,53 :: 		INTCON.T0IE = 1; // Activer interruption Timer0
	BSF        INTCON+0, 5
;DECHET.c,54 :: 		OPTION_REG.T0CS = 1;
	BSF        OPTION_REG+0, 5
;DECHET.c,55 :: 		OPTION_REG.T0SE = 0; // 0->1 pour mode incrementation
	BCF        OPTION_REG+0, 4
;DECHET.c,56 :: 		INTCON.INTE = 1; // Activer interruption RB0
	BSF        INTCON+0, 4
;DECHET.c,57 :: 		INTCON.RBIE = 1; // Activer interruptions changement sur RB4-RB7
	BSF        INTCON+0, 3
;DECHET.c,58 :: 		INTCON.GIE = 1; // Activer interruption globale
	BSF        INTCON+0, 7
;DECHET.c,60 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;DECHET.c,61 :: 		Lcd_Out(1, 1, "Systeme pret");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_DECHET+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;DECHET.c,62 :: 		delay_ms(2000);
	MOVLW      21
	MOVWF      R11+0
	MOVLW      75
	MOVWF      R12+0
	MOVLW      190
	MOVWF      R13+0
L_main0:
	DECFSZ     R13+0, 1
	GOTO       L_main0
	DECFSZ     R12+0, 1
	GOTO       L_main0
	DECFSZ     R11+0, 1
	GOTO       L_main0
	NOP
;DECHET.c,64 :: 		while (1) {
L_main1:
;DECHET.c,66 :: 		PORTC.RC0 = 0; // LED verte OFF
	BCF        PORTC+0, 0
;DECHET.c,67 :: 		PORTC.RC1 = 0; // LED rouge OFF
	BCF        PORTC+0, 1
;DECHET.c,68 :: 		PORTC.RC2 = 0; // LED jaune OFF
	BCF        PORTC+0, 2
;DECHET.c,69 :: 		PORTC.RC3 = 0; // Servomoteur OFF
	BCF        PORTC+0, 3
;DECHET.c,70 :: 		PORTC.RC4 = 0; // Buzzer OFF
	BCF        PORTC+0, 4
;DECHET.c,74 :: 		metADC = ADC_Read(0);
	CLRF       FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _metADC+0
	MOVF       R0+1, 0
	MOVWF      _metADC+1
;DECHET.c,75 :: 		ME = (metADC * 100.0) / 1023.0;
	CALL       _int2double+0
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      72
	MOVWF      R4+2
	MOVLW      133
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVLW      0
	MOVWF      R4+0
	MOVLW      192
	MOVWF      R4+1
	MOVLW      127
	MOVWF      R4+2
	MOVLW      136
	MOVWF      R4+3
	CALL       _Div_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      _ME+0
	MOVF       R0+1, 0
	MOVWF      _ME+1
	MOVF       R0+2, 0
	MOVWF      _ME+2
	MOVF       R0+3, 0
	MOVWF      _ME+3
;DECHET.c,76 :: 		plasADC = ADC_Read(1);
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _plasADC+0
	MOVF       R0+1, 0
	MOVWF      _plasADC+1
;DECHET.c,77 :: 		PL = (plasADC * 100.0) / 1023.0;
	CALL       _int2double+0
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      72
	MOVWF      R4+2
	MOVLW      133
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVLW      0
	MOVWF      R4+0
	MOVLW      192
	MOVWF      R4+1
	MOVLW      127
	MOVWF      R4+2
	MOVLW      136
	MOVWF      R4+3
	CALL       _Div_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      _PL+0
	MOVF       R0+1, 0
	MOVWF      _PL+1
	MOVF       R0+2, 0
	MOVWF      _PL+2
	MOVF       R0+3, 0
	MOVWF      _PL+3
;DECHET.c,81 :: 		if (PL >= 80 && ME <= 50) {
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      32
	MOVWF      R4+2
	MOVLW      133
	MOVWF      R4+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSS      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main5
	MOVF       _ME+0, 0
	MOVWF      R4+0
	MOVF       _ME+1, 0
	MOVWF      R4+1
	MOVF       _ME+2, 0
	MOVWF      R4+2
	MOVF       _ME+3, 0
	MOVWF      R4+3
	MOVLW      0
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	MOVLW      72
	MOVWF      R0+2
	MOVLW      132
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSS      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main5
L__main36:
;DECHET.c,82 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;DECHET.c,83 :: 		Lcd_Out(1, 1, "Detection plast");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_DECHET+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;DECHET.c,84 :: 		delay_ms(2000);
	MOVLW      21
	MOVWF      R11+0
	MOVLW      75
	MOVWF      R12+0
	MOVLW      190
	MOVWF      R13+0
L_main6:
	DECFSZ     R13+0, 1
	GOTO       L_main6
	DECFSZ     R12+0, 1
	GOTO       L_main6
	DECFSZ     R11+0, 1
	GOTO       L_main6
	NOP
;DECHET.c,86 :: 		} else if (PL<=55 && ME>=85) {
	GOTO       L_main7
L_main5:
	MOVF       _PL+0, 0
	MOVWF      R4+0
	MOVF       _PL+1, 0
	MOVWF      R4+1
	MOVF       _PL+2, 0
	MOVWF      R4+2
	MOVF       _PL+3, 0
	MOVWF      R4+3
	MOVLW      0
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	MOVLW      92
	MOVWF      R0+2
	MOVLW      132
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSS      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main10
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      42
	MOVWF      R4+2
	MOVLW      133
	MOVWF      R4+3
	MOVF       _ME+0, 0
	MOVWF      R0+0
	MOVF       _ME+1, 0
	MOVWF      R0+1
	MOVF       _ME+2, 0
	MOVWF      R0+2
	MOVF       _ME+3, 0
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSS      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main10
L__main35:
;DECHET.c,87 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;DECHET.c,88 :: 		Lcd_Out(1, 1, "Detection metal");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_DECHET+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;DECHET.c,89 :: 		}
	GOTO       L_main11
L_main10:
;DECHET.c,91 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;DECHET.c,92 :: 		Lcd_Out(1, 1, "Dechet incorrecte");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr4_DECHET+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;DECHET.c,93 :: 		PORTC.RC1 = 1; // LED rouge ON
	BSF        PORTC+0, 1
;DECHET.c,94 :: 		delay_ms(3000);
	MOVLW      31
	MOVWF      R11+0
	MOVLW      113
	MOVWF      R12+0
	MOVLW      30
	MOVWF      R13+0
L_main12:
	DECFSZ     R13+0, 1
	GOTO       L_main12
	DECFSZ     R12+0, 1
	GOTO       L_main12
	DECFSZ     R11+0, 1
	GOTO       L_main12
	NOP
;DECHET.c,95 :: 		PORTC.RC1 = 0; // LED rouge OFF
	BCF        PORTC+0, 1
;DECHET.c,96 :: 		}
L_main11:
L_main7:
;DECHET.c,99 :: 		if (PORTB.RB1) {
	BTFSS      PORTB+0, 1
	GOTO       L_main13
;DECHET.c,100 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;DECHET.c,101 :: 		Lcd_Out(1, 1, "Bac plein");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr5_DECHET+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;DECHET.c,102 :: 		PORTC.RC2 = 1;// LED jaune ON
	BSF        PORTC+0, 2
;DECHET.c,103 :: 		delay_ms(2000);
	MOVLW      21
	MOVWF      R11+0
	MOVLW      75
	MOVWF      R12+0
	MOVLW      190
	MOVWF      R13+0
L_main14:
	DECFSZ     R13+0, 1
	GOTO       L_main14
	DECFSZ     R12+0, 1
	GOTO       L_main14
	DECFSZ     R11+0, 1
	GOTO       L_main14
	NOP
;DECHET.c,104 :: 		PORTC.RC2 = 0; // LED jaune OFF
	BCF        PORTC+0, 2
;DECHET.c,105 :: 		PORTC.RC4 = 1;
	BSF        PORTC+0, 4
;DECHET.c,106 :: 		delay_ms(500);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_main15:
	DECFSZ     R13+0, 1
	GOTO       L_main15
	DECFSZ     R12+0, 1
	GOTO       L_main15
	DECFSZ     R11+0, 1
	GOTO       L_main15
	NOP
	NOP
;DECHET.c,107 :: 		PORTC.RC4 = 0;
	BCF        PORTC+0, 4
;DECHET.c,109 :: 		}
L_main13:
;DECHET.c,112 :: 		if (tri_en_cours) {
	MOVF       _tri_en_cours+0, 0
	IORWF      _tri_en_cours+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main16
;DECHET.c,113 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;DECHET.c,114 :: 		Lcd_Out(1, 1, "Tri en cours");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr6_DECHET+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;DECHET.c,115 :: 		PORTC.RC0 = 1; // LED verte ON
	BSF        PORTC+0, 0
;DECHET.c,116 :: 		delay_ms(4000);
	MOVLW      41
	MOVWF      R11+0
	MOVLW      150
	MOVWF      R12+0
	MOVLW      127
	MOVWF      R13+0
L_main17:
	DECFSZ     R13+0, 1
	GOTO       L_main17
	DECFSZ     R12+0, 1
	GOTO       L_main17
	DECFSZ     R11+0, 1
	GOTO       L_main17
;DECHET.c,117 :: 		PORTC.RC0 = 0; // LED verte OFF
	BCF        PORTC+0, 0
;DECHET.c,118 :: 		PORTC.RC3 = 1; // LED verte ON
	BSF        PORTC+0, 3
;DECHET.c,119 :: 		delay_ms(3000);
	MOVLW      31
	MOVWF      R11+0
	MOVLW      113
	MOVWF      R12+0
	MOVLW      30
	MOVWF      R13+0
L_main18:
	DECFSZ     R13+0, 1
	GOTO       L_main18
	DECFSZ     R12+0, 1
	GOTO       L_main18
	DECFSZ     R11+0, 1
	GOTO       L_main18
	NOP
;DECHET.c,120 :: 		PORTC.RC3 = 0;
	BCF        PORTC+0, 3
;DECHET.c,121 :: 		tri_en_cours=0;
	CLRF       _tri_en_cours+0
	CLRF       _tri_en_cours+1
;DECHET.c,122 :: 		}
L_main16:
;DECHET.c,125 :: 		if (tri_annule) {
	MOVF       _tri_annule+0, 0
	IORWF      _tri_annule+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main19
;DECHET.c,126 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;DECHET.c,127 :: 		Lcd_Out(1, 1, "Tri annule");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr7_DECHET+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;DECHET.c,128 :: 		PORTC.RC0 = 0;
	BCF        PORTC+0, 0
;DECHET.c,129 :: 		tri_annule = 0;
	CLRF       _tri_annule+0
	CLRF       _tri_annule+1
;DECHET.c,130 :: 		}
L_main19:
;DECHET.c,132 :: 		if (systeme_pause) {
	MOVF       _systeme_pause+0, 0
	IORWF      _systeme_pause+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main20
;DECHET.c,133 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;DECHET.c,134 :: 		Lcd_Out(1, 1, "Systeme en pause");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr8_DECHET+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;DECHET.c,135 :: 		PORTC.RC0 = 0;
	BCF        PORTC+0, 0
;DECHET.c,136 :: 		systeme_pause = 0;
	CLRF       _systeme_pause+0
	CLRF       _systeme_pause+1
;DECHET.c,137 :: 		}
L_main20:
;DECHET.c,139 :: 		if (mode_urgence) {
	MOVF       _mode_urgence+0, 0
	IORWF      _mode_urgence+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main21
;DECHET.c,140 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;DECHET.c,141 :: 		Lcd_Out(1, 1, "!!! ERREUR !!!");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr9_DECHET+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;DECHET.c,142 :: 		Lcd_Out(2, 1, "Verifier les bacs");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr10_DECHET+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;DECHET.c,143 :: 		PORTC.RC4 = 1; // Buzzer ON
	BSF        PORTC+0, 4
;DECHET.c,144 :: 		for (i = 0; i < 5; i++) {
	CLRF       _i+0
	CLRF       _i+1
L_main22:
	MOVLW      128
	XORWF      _i+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main38
	MOVLW      5
	SUBWF      _i+0, 0
L__main38:
	BTFSC      STATUS+0, 0
	GOTO       L_main23
;DECHET.c,145 :: 		PORTC.RC0 = 1; // LED verte ON
	BSF        PORTC+0, 0
;DECHET.c,146 :: 		PORTC.RC1 = 1; // LED rouge ON
	BSF        PORTC+0, 1
;DECHET.c,147 :: 		PORTC.RC2 = 1; // LED jaune ON
	BSF        PORTC+0, 2
;DECHET.c,148 :: 		delay_ms(300);
	MOVLW      4
	MOVWF      R11+0
	MOVLW      12
	MOVWF      R12+0
	MOVLW      51
	MOVWF      R13+0
L_main25:
	DECFSZ     R13+0, 1
	GOTO       L_main25
	DECFSZ     R12+0, 1
	GOTO       L_main25
	DECFSZ     R11+0, 1
	GOTO       L_main25
	NOP
	NOP
;DECHET.c,149 :: 		PORTC.RC0 = 0;
	BCF        PORTC+0, 0
;DECHET.c,150 :: 		PORTC.RC1 = 0;
	BCF        PORTC+0, 1
;DECHET.c,151 :: 		PORTC.RC2 = 0;
	BCF        PORTC+0, 2
;DECHET.c,152 :: 		delay_ms(300);
	MOVLW      4
	MOVWF      R11+0
	MOVLW      12
	MOVWF      R12+0
	MOVLW      51
	MOVWF      R13+0
L_main26:
	DECFSZ     R13+0, 1
	GOTO       L_main26
	DECFSZ     R12+0, 1
	GOTO       L_main26
	DECFSZ     R11+0, 1
	GOTO       L_main26
	NOP
	NOP
;DECHET.c,144 :: 		for (i = 0; i < 5; i++) {
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;DECHET.c,153 :: 		}
	GOTO       L_main22
L_main23:
;DECHET.c,154 :: 		mode_urgence = 0;
	CLRF       _mode_urgence+0
	CLRF       _mode_urgence+1
;DECHET.c,155 :: 		}
L_main21:
;DECHET.c,157 :: 		if (systeme_veille) {
	MOVF       _systeme_veille+0, 0
	IORWF      _systeme_veille+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main27
;DECHET.c,158 :: 		PORTC.RC0 = 0; // LED verte OFF
	BCF        PORTC+0, 0
;DECHET.c,159 :: 		PORTC.RC1 = 0; // LED rouge OFF
	BCF        PORTC+0, 1
;DECHET.c,160 :: 		PORTC.RC2 = 0; // LED jaune OFF
	BCF        PORTC+0, 2
;DECHET.c,161 :: 		PORTC.RC3 = 0; // Servomoteur OFF
	BCF        PORTC+0, 3
;DECHET.c,162 :: 		PORTC.RC4 = 0; // Buzzer OFF
	BCF        PORTC+0, 4
;DECHET.c,163 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;DECHET.c,164 :: 		Lcd_Out(1, 1, "Systeme en veille");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr11_DECHET+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;DECHET.c,165 :: 		systeme_veille = 0;
	CLRF       _systeme_veille+0
	CLRF       _systeme_veille+1
;DECHET.c,166 :: 		}
L_main27:
;DECHET.c,168 :: 		delay_ms(1000); // Attente de 1 seconde
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main28:
	DECFSZ     R13+0, 1
	GOTO       L_main28
	DECFSZ     R12+0, 1
	GOTO       L_main28
	DECFSZ     R11+0, 1
	GOTO       L_main28
	NOP
	NOP
;DECHET.c,169 :: 		}
	GOTO       L_main1
;DECHET.c,170 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;DECHET.c,174 :: 		void interrupt() {
;DECHET.c,176 :: 		if (INTCON.INTF) {
	BTFSS      INTCON+0, 1
	GOTO       L_interrupt29
;DECHET.c,177 :: 		tri_en_cours = 1;
	MOVLW      1
	MOVWF      _tri_en_cours+0
	MOVLW      0
	MOVWF      _tri_en_cours+1
;DECHET.c,178 :: 		INTCON.INTF = 0; // Réinitialisation du flag
	BCF        INTCON+0, 1
;DECHET.c,179 :: 		}
L_interrupt29:
;DECHET.c,182 :: 		if (INTCON.RBIF) {
	BTFSS      INTCON+0, 0
	GOTO       L_interrupt30
;DECHET.c,183 :: 		if (PORTB.RB4) { // Annulation du tri
	BTFSS      PORTB+0, 4
	GOTO       L_interrupt31
;DECHET.c,184 :: 		tri_annule = 1;
	MOVLW      1
	MOVWF      _tri_annule+0
	MOVLW      0
	MOVWF      _tri_annule+1
;DECHET.c,185 :: 		}
L_interrupt31:
;DECHET.c,186 :: 		if (PORTB.RB5) { // Pause du système
	BTFSS      PORTB+0, 5
	GOTO       L_interrupt32
;DECHET.c,187 :: 		systeme_pause = 1;
	MOVLW      1
	MOVWF      _systeme_pause+0
	MOVLW      0
	MOVWF      _systeme_pause+1
;DECHET.c,188 :: 		}
L_interrupt32:
;DECHET.c,189 :: 		if (PORTB.RB6) { // Mode urgence
	BTFSS      PORTB+0, 6
	GOTO       L_interrupt33
;DECHET.c,190 :: 		mode_urgence = 1;
	MOVLW      1
	MOVWF      _mode_urgence+0
	MOVLW      0
	MOVWF      _mode_urgence+1
;DECHET.c,191 :: 		}
L_interrupt33:
;DECHET.c,192 :: 		if (PORTB.RB7) { // Mise en veille
	BTFSS      PORTB+0, 7
	GOTO       L_interrupt34
;DECHET.c,193 :: 		systeme_veille = 1;
	MOVLW      1
	MOVWF      _systeme_veille+0
	MOVLW      0
	MOVWF      _systeme_veille+1
;DECHET.c,194 :: 		}
L_interrupt34:
;DECHET.c,196 :: 		INTCON.RBIF = 0; // Réinitialisation du flag
	BCF        INTCON+0, 0
;DECHET.c,197 :: 		}
L_interrupt30:
;DECHET.c,200 :: 		}
L_end_interrupt:
L__interrupt40:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt
