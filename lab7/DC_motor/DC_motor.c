void main() {
     AD1PCFG = 0xFFFF;
     DDPCON.JTAGEN = 0; // disable JTAG
     TRISA = 0x0000;  //portA is output
     TRISE = 0XFFFF;  //portE is inputs
}