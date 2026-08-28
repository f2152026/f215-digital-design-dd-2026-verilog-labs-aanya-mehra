
module dut(

    input  [63:0] a,
    input  [63:0] b,
    input         cin,

    output [63:0] sum,
    output        cout

);

    // ---- Bonus: hierarchical 64-bit carry-lookahead adder ----

    cla64_hier U_IMPL (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );

    // ---- For comparison: uncomment only ONE at a time ----

    // rca64 U_IMPL (
    //     .a(a),
    //     .b(b),
    //     .cin(cin),
    //     .sum(sum),
    //     .cout(cout)
    // );

    // cla64_flat U_IMPL (
    //     .a(a),
    //     .b(b),
    //     .cin(cin),
    //     .sum(sum),
    //     .cout(cout)
    // );

    // cla64_blocked U_IMPL (
    //     .a(a),
    //     .b(b),
    //     .cin(cin),
    //     .sum(sum),
    //     .cout(cout)
    // );

endmodule

