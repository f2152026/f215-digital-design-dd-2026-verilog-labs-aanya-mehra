// tb.v
// Self-checking testbench for the 2-bit magnitude comparator.


module tb;


  reg  [1:0] t_a, t_b;
  wire       t_gt, t_lt, t_eq;


  reg        exp_gt, exp_lt, exp_eq;
  integer    i, j;
  integer    errors;


  comp2 DUT (
    .A  (t_a),
    .B  (t_b),
    .GT (t_gt),
    .LT (t_lt),
    .EQ (t_eq)
  );


  // Waveform dump configuration
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end


  initial begin
    errors = 0;


    for (i = 0; i < 4; i = i + 1) begin
      for (j = 0; j < 4; j = j + 1) begin
        t_a = i[1:0];
        t_b = j[1:0];
        #5;


        exp_gt = (i >  j);
        exp_lt = (i <  j);
        exp_eq = (i == j);


        if (t_gt !== exp_gt || t_lt !== exp_lt || t_eq !== exp_eq) begin
          $display("FAIL: A=%b B=%b | GT=%b LT=%b EQ=%b (expected GT=%b LT=%b EQ=%b)",
                   t_a, t_b, t_gt, t_lt, t_eq, exp_gt, exp_lt, exp_eq);
          errors = errors + 1;
        end else begin
          $display("PASS: A=%b B=%b | GT=%b LT=%b EQ=%b",
                   t_a, t_b, t_gt, t_lt, t_eq);
        end
      end
    end


    if (errors == 0)
      $display("ALL TESTS PASSED");
    else
      $display("TESTS FAILED: %0d error(s)", errors);


    $finish;
  end


endmodule
