//LCD
sbit LCD_RS at RD4_bit;
sbit LCD_EN at RD5_bit;
sbit LCD_D4 at RD0_bit;
sbit LCD_D5 at RD1_bit;
sbit LCD_D6 at RD2_bit;
sbit LCD_D7 at RD3_bit;

sbit LCD_RS_Direction at TRISD4_bit;
sbit LCD_EN_Direction at TRISD5_bit;
sbit LCD_D4_Direction at TRISD0_bit;
sbit LCD_D5_Direction at TRISD1_bit;
sbit LCD_D6_Direction at TRISD2_bit;
sbit LCD_D7_Direction at TRISD3_bit;

// Déclaration variables globales pour l'affichage
int tri_en_cours = 0;
int tri_annule = 0;
int systeme_pause = 0;
int mode_urgence = 0;
int systeme_veille = 0;
int afficher_confirmer = 0;
int afficher_confirme = 0;
int compteur_appui = 0;
char txt[10];
int metADC, plasADC;
float ME;
float PL;
int i;

void main() {
    // Configurations des ports
    TRISA = 0b00010011;
    TRISB = 0b11110011;
    TRISC = 0x00;       //OUTPUT led+buzzer+moteur
    TRISD = 0x00;       // LCD

    PORTA = 0;
    PORTC = 0;
    PORTD = 0;
    // Initialisation
    ADC_Init();
    Lcd_Init();
    Lcd_Cmd(_LCD_CLEAR);
    PORTC.RC0 = 0; // LED verte OFF
    PORTC.RC1 = 0; // LED rouge OFF
    PORTC.RC2 = 0; // LED jaune OFF
    PORTC.RC3 = 0; // Servomoteur OFF
    PORTC.RC4 = 0; // Buzzer OFF

    // Configuration des interruptions
    TMR0 = 254;
    INTCON.T0IE = 1; // Activer interruption Timer0
    OPTION_REG.T0CS = 1;
    OPTION_REG.T0SE = 0; // 0->1 pour mode incrementation
    INTCON.INTE = 1; // Activer interruption RB0
    INTCON.RBIE = 1; // Activer interruptions changement sur RB4-RB7
    INTCON.GIE = 1; // Activer interruption globale
    
    Lcd_Cmd(_LCD_CLEAR);
    Lcd_Out(1, 1, "Systeme pret");
    delay_ms(2000);

    while (1) {
        //Etat repos
        PORTC.RC0 = 0; // LED verte OFF
        PORTC.RC1 = 0; // LED rouge OFF
        PORTC.RC2 = 0; // LED jaune OFF
        PORTC.RC3 = 0; // Servomoteur OFF
        PORTC.RC4 = 0; // Buzzer OFF

        
        //Lecture de l'ADC
        metADC = ADC_Read(0);
        ME = (metADC * 100.0) / 1023.0;
        plasADC = ADC_Read(1);
        PL = (plasADC * 100.0) / 1023.0;

        

        if (PL >= 80 && ME <= 50) {
            Lcd_Cmd(_LCD_CLEAR);
            Lcd_Out(1, 1, "Detection plast");
            delay_ms(2000);

        } else if (PL<=55 && ME>=85) {
            Lcd_Cmd(_LCD_CLEAR);
            Lcd_Out(1, 1, "Detection metal");
            }
        else {
            Lcd_Cmd(_LCD_CLEAR);
            Lcd_Out(1, 1, "Dechet incorrecte");
            PORTC.RC1 = 1; // LED rouge ON
            delay_ms(3000);
            PORTC.RC1 = 0; // LED rouge OFF
        }

        // Vérification du niveau du bac (RB1)
        if (PORTB.RB1) {
            Lcd_Cmd(_LCD_CLEAR);
            Lcd_Out(1, 1, "Bac plein");
            PORTC.RC2 = 1;// LED jaune ON
            delay_ms(2000);
            PORTC.RC2 = 0; // LED jaune OFF
            PORTC.RC4 = 1;
            delay_ms(500);
            PORTC.RC4 = 0;

        }
        
        //Interuption RB0
        if (tri_en_cours) {
            Lcd_Cmd(_LCD_CLEAR);
            Lcd_Out(1, 1, "Tri en cours");
            PORTC.RC0 = 1; // LED verte ON
            delay_ms(4000);
            PORTC.RC0 = 0; // LED verte OFF
            PORTC.RC3 = 1; // LED verte ON
            delay_ms(3000);
            PORTC.RC3 = 0;
            tri_en_cours=0;
        }

        //Interuption PORTB
        if (tri_annule) {
            Lcd_Cmd(_LCD_CLEAR);
            Lcd_Out(1, 1, "Tri annule");
            PORTC.RC0 = 0;
            tri_annule = 0;
        }

        if (systeme_pause) {
            Lcd_Cmd(_LCD_CLEAR);
            Lcd_Out(1, 1, "Systeme en pause");
            PORTC.RC0 = 0;
            systeme_pause = 0;
        }

        if (mode_urgence) {
            Lcd_Cmd(_LCD_CLEAR);
            Lcd_Out(1, 1, "!!! ERREUR !!!");
            Lcd_Out(2, 1, "Verifier les bacs");
            PORTC.RC4 = 1; // Buzzer ON
            for (i = 0; i < 5; i++) {
                PORTC.RC0 = 1; // LED verte ON
                PORTC.RC1 = 1; // LED rouge ON
                PORTC.RC2 = 1; // LED jaune ON
                delay_ms(300);
                PORTC.RC0 = 0;
                PORTC.RC1 = 0;
                PORTC.RC2 = 0;
                delay_ms(300);
            }
            mode_urgence = 0;
        }

        if (systeme_veille) {
            PORTC.RC0 = 0; // LED verte OFF
            PORTC.RC1 = 0; // LED rouge OFF
            PORTC.RC2 = 0; // LED jaune OFF
            PORTC.RC3 = 0; // Servomoteur OFF
            PORTC.RC4 = 0; // Buzzer OFF
            Lcd_Cmd(_LCD_CLEAR);
            Lcd_Out(1, 1, "Systeme en veille");
            systeme_veille = 0;
        }

        delay_ms(1000); // Attente de 1 seconde
    }
}



void interrupt() {
    // Interruption RB0 : Activation manuelle du tri
    if (INTCON.INTF) {
        tri_en_cours = 1;
        INTCON.INTF = 0; // Réinitialisation du flag
    }

    // Interruption changement sur PORTB (RB4-RB7)
    if (INTCON.RBIF) {
        if (PORTB.RB4) { // Annulation du tri
            tri_annule = 1;
        }
       if (PORTB.RB5) { // Pause du système
            systeme_pause = 1;
        }
       if (PORTB.RB6) { // Mode urgence
            mode_urgence = 1;
        }
       if (PORTB.RB7) { // Mise en veille
            systeme_veille = 1;
        }

        INTCON.RBIF = 0; // Réinitialisation du flag
    }


}