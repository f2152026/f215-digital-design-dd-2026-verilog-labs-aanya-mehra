module tb;

reg [3:0] t_a, t_b;
reg t_op;
wire [3:0] t_result;

reg [3:0] expected;
integer i, j, k;
integer errors;
alu DUT (
.a (t_a),
.b (t_b),
.op (t_op),
.result (t_result)
);
// Waveform dump configuration
string vcd_file;
initial begin
if ($value$plusargs("vcd=%s", vcd_file)) begin
$dumpfile(vcd_file);
$dumpvars(0, tb);
end
end
initial begin
errors = 0;
for (k = 0; k < 2; k = k + 1) begin
for (i = 0; i < 16; i = i + 1) begin
for (j = 0; j < 16; j = j + 1) begin
t_op = k[0];
t_a = i[3:0];
t_b = j[3:0];
#5;
if (k == 0)
expected = i[3:0] + j[3:0];
else
expected = i[3:0] - j[3:0];
if (t_result !== expected) begin
$display("FAIL: op=%b a=%0d b=%0d | result=%0d expected=%0d";,
t_op, t_a, t_b, t_result, expected);
errors = errors + 1;
end
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