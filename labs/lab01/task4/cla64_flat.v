module cla64_flat(
    input  [63:0] a,
    input  [63:0] b,
    input         cin,
    output [63:0] sum,
    output        cout
);

    wire [63:0] p, g;
    wire [64:1] c;

    // Step 1: Generate and Propagate signals
    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : gen_pg
            xor #(2) (p[i], a[i], b[i]);
            and #(2) (g[i], a[i], b[i]);
        end
    endgenerate

    // Step 2: Direct carry equations

    assign #(2) c[1] = g[0] | (p[0] & cin);

    assign #(2) c[2] = g[1] |
                        (p[1] & g[0]) |
                        (p[1] & p[0] & cin);

    assign #(2) c[3] = g[2] |
                        (p[2] & g[1]) |
                        (p[2] & p[1] & g[0]) |
                        (p[2] & p[1] & p[0] & cin);

    assign #(2) c[4] = g[3] |
                        (p[3] & g[2]) |
                        (p[3] & p[2] & g[1]) |
                        (p[3] & p[2] & p[1] & g[0]) |
                        (p[3] & p[2] & p[1] & p[0] & cin);

    // Generate c[5] through c[64]
    genvar k;
    generate
        for (k = 5; k <= 64; k = k + 1) begin : gen_carry

            assign #(2) c[k] =
                g[k-1] |
                (p[k-1] & g[k-2]) |
                (p[k-1] & p[k-2] & g[k-3]) |
                (p[k-1] & p[k-2] & p[k-3] & g[k-4]);

        end
    endgenerate

    assign #(2) cout = c[64];

    // Step 3: Sum
    assign #(2) sum = p ^ {c[63:1], cin};

endmodule
