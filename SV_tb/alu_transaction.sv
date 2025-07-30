`include "define.sv"
class alu_transaction;
  rand logic [`width-1:0] opa,opb;
  randc logic [1:0]inp_valid;
  rand logic mode,ce,cin;
  randc logic [`cmd_width-1:0]cmd;
  logic [`width+1:0]res;
  logic err,oflow,cout,g,e,l;
constraint c1{inp_valid dist{3:=75, 2:=10, 0:=10, 1:=10};}

  virtual function alu_transaction copy();
    copy=new();
    copy.opa=this.opa;
    copy.opb=this.opb;
    copy.inp_valid=this.inp_valid;
    copy.ce=this.ce;
    copy.mode=this.mode;
    copy.cin=this.cin;
    copy.cmd=this.cmd;
    return copy;
  endfunction
endclass


class alu_transaction1 extends alu_transaction;

  constraint mode_val  { mode == 0; }
  constraint sing_op_cmd { cmd  inside {6, 7, 8, 9, 10, 11};}
  constraint inp_val   { inp_valid inside {1}; }

  virtual function alu_transaction copy();
    alu_transaction1 copy1;
    copy1 = new();
    copy1.inp_valid = this.inp_valid;
    copy1.mode      = this.mode;
    copy1.cmd       = this.cmd;
    copy1.opa       = this.opa;
    copy1.opb       = this.opb;
    copy1.cin       = this.cin;
    copy1.ce       = this.ce;

    return copy1;
  endfunction

endclass

class alu_transaction2 extends alu_transaction;

  constraint mode_val  { mode == 1; }
  constraint sing_op_cmd { cmd  inside {4, 5, 6, 7};}
  constraint inp_val   { inp_valid inside {1, 2, 3}; }

  virtual function alu_transaction copy();
    alu_transaction2 copy2;
    copy2 = new();
    copy2.inp_valid = this.inp_valid;
    copy2.mode      = this.mode;
    copy2.cmd       = this.cmd;
    copy2.opa       = this.opa;
    copy2.opb       = this.opb;
    copy2.cin       = this.cin;
    copy2.ce       = this.ce;

    return copy2;
  endfunction

endclass


class alu_transaction3 extends alu_transaction;
  
  constraint mode_val {mode dist {0:=50, 1:=50}; }
  constraint cmd_range {if(mode) 
    			cmd inside {[0:3]};
                        else 
                cmd inside {[0:5]};}
  constraint inp_val    { inp_valid == 3; }
  virtual function alu_transaction copy();
    alu_transaction3 copy3;
    copy3 = new();
    copy3.inp_valid = this.inp_valid;
    copy3.mode      = this.mode;
    copy3.cmd       = this.cmd;
    copy3.opa       = this.opa;
    copy3.opb       = this.opb;
    copy3.cin       = this.cin;
    copy3.ce       = this.ce;

    return copy3;
  endfunction

endclass

class alu_transaction4 extends alu_transaction;

  constraint mode_val {mode == 0; }
  constraint cmd_range {cmd inside {0, 1, 2, 3, 4, 5, 12, 13};}
  constraint inp_values {inp_valid inside {3};}

  virtual function alu_transaction copy();
    alu_transaction4 copy4;
    copy4 = new();
    copy4.inp_valid = this.inp_valid;
    copy4.mode      = this.mode;
    copy4.cmd       = this.cmd;
    copy4.opa       = this.opa;
    copy4.opb       = this.opb;
    copy4.cin       = this.cin;
    copy4.ce       = this.ce;

    return copy4;
  endfunction

endclass

class alu_transaction5 extends alu_transaction;

  constraint mode_val {mode ==1; }
  constraint cmd_range { cmd inside {[8:12]};}
  constraint inp_values {inp_valid == 3;}
  virtual function alu_transaction copy();
    alu_transaction5 copy5;
    copy5 = new();
    copy5.inp_valid = this.inp_valid;
    copy5.mode      = this.mode;
    copy5.cmd       = this.cmd;
    copy5.opa       = this.opa;
    copy5.opb       = this.opb;
    copy5.cin       = this.cin;
    copy5.ce       = this.ce;

    return copy5;
  endfunction

endclass

 class alu_transaction6 extends alu_transaction;

  constraint inp_values {inp_valid == 3;}

   virtual function alu_transaction copy();
     alu_transaction6 copy6;
     copy6 = new();
     copy6.inp_valid = this.inp_valid;
     copy6.mode      = this.mode;
     copy6.cmd       = this.cmd;
     copy6.opa       = this.opa;
     copy6.opb       = this.opb;
     copy6.cin       = this.cin;

     return copy6;
   endfunction

 endclass

 class alu_transaction7 extends alu_transaction;

  constraint mode_val {mode ==0; }
  constraint cmd_range { cmd inside {[12:13]};}
  constraint inp_values {inp_valid == 3;}

   virtual function alu_transaction copy();
     alu_transaction7 copy7;
     copy7 = new();
     copy7.inp_valid = this.inp_valid;
     copy7.mode      = this.mode;
     copy7.cmd       = this.cmd;
     copy7.opa       = this.opa;
     copy7.opb       = this.opb;
     copy7.cin       = this.cin;

     return copy7;
   endfunction

 endclass
