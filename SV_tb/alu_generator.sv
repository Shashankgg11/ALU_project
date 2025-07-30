`include "define.sv"
class alu_generator;
  alu_transaction blueprint;
  mailbox #(alu_transaction) mbx_gd;

  function new(mailbox #(alu_transaction)mbx_gd);
    this.mbx_gd=mbx_gd;
    blueprint=new();
   endfunction

  task start();
    for(int i=0;i<`no_of_trans;i++)
      begin
        void'(blueprint.randomize());
        mbx_gd.put(blueprint.copy);
        $display("generator randomized transcation opa=%d,opb=%d,cmd=%d,inp_valid=%d,ce=%d,cin=%d,mode=%d",blueprint.opa,blueprint.opb,blueprint.cmd,blueprint.inp_valid,blueprint.ce,blueprint.cin,blueprint.mode,$time);
      end
  endtask
endclass


