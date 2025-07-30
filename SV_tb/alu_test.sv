class alu_test;
  //Virtual interfaces for driver, monitor and reference model
  virtual alu_if drv_vif;
  virtual alu_if mon_vif;
  virtual alu_if ref_vif;
  alu_environment env;

  //from driver, monitor and reference model to test
  function new(virtual alu_if drv_vif,
               virtual alu_if mon_vif,
               virtual alu_if ref_vif);
    this.drv_vif=drv_vif;
    this.mon_vif=mon_vif;
    this.ref_vif=ref_vif;
  endfunction

  task run();
    env=new(drv_vif,mon_vif,ref_vif);
    env.build;
    env.start;
  endtask
endclass

// class test1 extends alu_test;
//  alu_transaction1 trans1;
//   function new(virtual alu_if drv_vif,virtual alu_if mon_vif,virtual alu_if ref_vif);
//     super.new(drv_vif, mon_vif, ref_vif);
//   endfunction

//   task run();
//     env=new(drv_vif,mon_vif,ref_vif);
//     env.build;
//     begin
//     trans1 = new();
//     env.gen.blueprint= trans1;
//     end
//     env.start;
//   endtask
// endclass

// class test2 extends alu_test;
//  alu_transaction2 trans2;
//   function new(virtual alu_if drv_vif,virtual alu_if mon_vif,virtual alu_if ref_vif);
//     super.new(drv_vif, mon_vif, ref_vif);
//   endfunction

//   task run();
//     $display("child test");
//     env=new(drv_vif,mon_vif,ref_vif);
//     env.build;
//     begin
//     trans2 = new();
//     env.gen.blueprint= trans2;
//     end
//     env.start;
//   endtask
// endclass

// class test3 extends alu_test;
//  alu_transaction3 trans3;
//   function new(virtual alu_if drv_vif,virtual alu_if mon_vif,virtual alu_if ref_vif);
//     super.new(drv_vif, mon_vif, ref_vif);
//   endfunction
//   task run();
//     $display("child test");
//     env=new(drv_vif,mon_vif,ref_vif);
//     env.build;
//     begin
//     trans3 = new();
//     env.gen.blueprint= trans3;
//     end
//     env.start;
//   endtask
// endclass

// class test4 extends alu_test;
//  alu_transaction4 trans4;
//   function new(virtual alu_if drv_vif,virtual alu_if mon_vif,virtual alu_if ref_vif);
//     super.new(drv_vif, mon_vif, ref_vif);
//   endfunction

//   task run();
//     env=new(drv_vif,mon_vif,ref_vif);
//     env.build;
//     begin
//     trans4 = new();
//     env.gen.blueprint= trans4;
//     end
//     env.start;
//   endtask
// endclass

// class test5 extends alu_test;
//  alu_transaction5 trans5;
//   function new(virtual alu_if drv_vif,virtual alu_if mon_vif,virtual alu_if ref_vif);
//     super.new(drv_vif, mon_vif, ref_vif);
//   endfunction

//   task run();
//     env=new(drv_vif,mon_vif,ref_vif);
//     env.build;
//     begin
//     trans5 = new();
//     env.gen.blueprint= trans5;
//     end
//     env.start;
//   endtask
// endclass
// class test6 extends alu_test;
//  alu_transaction6 trans6;
//   function new(virtual alu_if drv_vif,virtual alu_if mon_vif,virtual alu_if ref_vif);
//     super.new(drv_vif, mon_vif, ref_vif);
//   endfunction

//   task run();
//     env=new(drv_vif,mon_vif,ref_vif);
//     env.build;
//     begin
//     trans6 = new();
//     env.gen.blueprint= trans6;
//     end
//     env.start;
//   endtask
// endclass

// class test7 extends alu_test;
//  alu_transaction7 trans7;
//   function new(virtual alu_if drv_vif,virtual alu_if mon_vif,virtual alu_if ref_vif);
//     super.new(drv_vif, mon_vif, ref_vif);
//   endfunction

//   task run();
//     env=new(drv_vif,mon_vif,ref_vif);
//     env.build;
//     begin
//     trans7 = new();
//     env.gen.blueprint= trans7;
//     end
//     env.start;
//   endtask

class test_regression extends alu_test;
 alu_transaction1  trans1;
 alu_transaction2 trans2;
 alu_transaction3 trans3;
 alu_transaction4 trans4;
 alu_transaction5 trans5;
 alu_transaction6 trans6;
 alu_transaction7 trans7;

  function new(virtual alu_if drv_vif,virtual alu_if mon_vif,virtual alu_if ref_vif);
    super.new(drv_vif, mon_vif, ref_vif);
  endfunction

  task run();
    env=new(drv_vif,mon_vif,ref_vif);
    env.build;

    begin
    trans1 = new();
    env.gen.blueprint= trans1;
    end
    env.start;

    begin
    trans2 = new();
    env.gen.blueprint= trans2;
    end
    env.start;

    begin
    trans3 = new();
    env.gen.blueprint= trans3;
    end
    env.start;

    begin
    trans4 = new();
    env.gen.blueprint= trans4;
    end
    env.start;

    begin
    trans5 = new();
    env.gen.blueprint= trans5;
    end
    env.start;

    begin
    trans6 = new();
    env.gen.blueprint= trans6;
    end
    env.start;

    begin
    trans7 = new();
    env.gen.blueprint= trans7;
    end
    env.start;
  endtask
endclass
