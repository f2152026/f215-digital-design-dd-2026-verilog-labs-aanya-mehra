
module cla64_hier(

    input  [63:0] a,
    input  [63:0] b,
    input         cin,

    output [63:0] sum,
    output        cout

);

    wire [15:0] Gblk, Pblk;
    wire [16:0] c;

    assign #(2) c[0] = cin;

    // ------------------------------------------------------------
    // Block generate/propagate signals
    // ------------------------------------------------------------

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : gen_blocks

            cla4 block (
                .a   (a[i*4 +: 4]),
                .b   (b[i*4 +: 4]),
                .cin (c[i]),
                .sum (sum[i*4 +: 4]),
                .cout()
            );

            assign #(2) Pblk[i] =
                (a[i*4] ^ b[i*4]) &
                (a[i*4+1] ^ b[i*4+1]) &
                (a[i*4+2] ^ b[i*4+2]) &
                (a[i*4+3] ^ b[i*4+3]);

            assign #(2) Gblk[i] =
                (a[i*4+3] & b[i*4+3]) |
                ((a[i*4+3] ^ b[i*4+3]) &
                 (a[i*4+2] & b[i*4+2])) |
                ((a[i*4+3] ^ b[i*4+3]) &
                 (a[i*4+2] ^ b[i*4+2]) &
                 (a[i*4+1] & b[i*4+1])) |
                ((a[i*4+3] ^ b[i*4+3]) &
                 (a[i*4+2] ^ b[i*4+2]) &
                 (a[i*4+1] ^ b[i*4+1]) &
                 (a[i*4] & b[i*4]));

        end
    endgenerate

    // ------------------------------------------------------------
    // Second-level carry lookahead
    //
    // Each carry uses the recursive lookahead relation:
    // c[k+1] = Gblk[k] | (Pblk[k] & c[k])
    //
    // ------------------------------------------------------------

    genvar j;
    generate
        for (j = 0; j < 16; j = j + 1) begin : gen_carries

            assign #(2) c[j+1] =
                Gblk[j] | (Pblk[j] & c[j]);

        end
    endgenerate

    assign #(2) cout = c[16];

endmodule
