/*=============================================================================
 * Title        : Decoder test bench
 *
 * File Name    : TB_DECODER.sv
 * Project      : DECODER
 * Block        : 
 * Tree         : 
 * Designer     : SUZUKI,T. (HDK)
 * Created      : 2019/11/10
 *============================================================================*/

`timescale 1ns/1ns

`define Comment(variable) \
$messagelog("%:S %:0F(%:0L) %:O.", "Note", `__FILE__, `__LINE__, variable);
`define MessageOK(variable, value) \
$messagelog("%:S %:0F(%:0L) OK:Assertion %:O = %:O.", "Note", `__FILE__, `__LINE__, variable, Func2Str(value,$bits(value)/4));
`define MessageERROR(variable, value) \
$messagelog("%:S %:0F(%:0L) ERROR:Assertion %:O = %:O failed.", "Error", `__FILE__, `__LINE__, variable, Func2Str(value,$bits(value)/4));
`define ChkValue(variable, value) \
    if ((variable)===(value)) \
        `MessageOK(variable, value) \
    else \
        `MessageERROR(variable, value)

module TB_DECODER ;

// Simulation module signal
// System
bit             CLK;                //(c) System clock
bit             RESET_n;            //(n) System reset
// Control
bit             SINK_VALID;         //(p) Sink data valid
bit  [3:0]      SINK_DATA;          //(p) Sink data
bit             SOURCE_VALID;       //(p) Source data valid
bit  [15:0]     SOURCE_DATA;        //(p) Source data

// Parameter
parameter       ClkCyc    = 10;     // Signal change interval(10ns/50MHz)
parameter       ResetTime = 20;     // Reset hold time

// Internal signals
shortint        expect_value;       // SOURCE_DATA expect value

// DUT
DECODER U_DECODER(
.CLK(CLK),
.RESET_n(RESET_n),
.SINK_VALID(SINK_VALID),
.SINK_DATA(SINK_DATA),
.SOURCE_VALID(SOURCE_VALID),
.SOURCE_DATA(SOURCE_DATA)
);


/*=============================================================================
 * Clock
 *============================================================================*/
always begin
    CLK = 0;
    #(ClkCyc);
    CLK = 1;
    #(ClkCyc);
end

/*=============================================================================
 * Reset
 *============================================================================*/
initial begin
    RESET_n = 0;
    #(ResetTime);
    RESET_n = 1;
end

/*=============================================================================
 * Signal initialization
 *============================================================================*/
initial begin
    SINK_VALID = 1'b0;
    SINK_DATA = 4'd0;

    expect_value = 16'd1;

    #(ResetTime);
    @(posedge CLK);

/*=============================================================================
 * Data decode
 *============================================================================*/
    for (byte i=0;i<16;i++) begin
        SINK_VALID = 1'b1;
        SINK_DATA = i;
        @(posedge CLK);
        SINK_VALID = 1'b0;
        wait(SOURCE_VALID);
        assert (SOURCE_DATA == expect_value)
            `MessageOK(SOURCE_DATA,expect_value)
        else
            `MessageERROR(SOURCE_DATA,expect_value)
        @(posedge CLK);
        expect_value <<= 1;
    end

    $finish;
end

/*=============================================================================
 * Convert to string function
 *============================================================================*/
function string Func2Str(int data, byte length);
    logic [3:0] data_slice;
    logic [31:0] data_shift;
    string str_slice;
    string str_data;

    str_slice = "\0";
    str_data = "\0";
    data_shift = data;

    // repeat (length) begin
    for (int i=0;i<length;i++) begin
        case (i)
            0 : data_slice = data_shift[3:0];
            1 : data_slice = data_shift[7:4];
            2 : data_slice = data_shift[11:8];
            3 : data_slice = data_shift[15:12];
            4 : data_slice = data_shift[19:16];
            5 : data_slice = data_shift[23:20];
            6 : data_slice = data_shift[27:24];
            7 : data_slice = data_shift[31:28];
        endcase
        case (data_slice)
            0  : str_slice = "0";
            1  : str_slice = "1";
            2  : str_slice = "2";
            3  : str_slice = "3";
            4  : str_slice = "4";
            5  : str_slice = "5";
            6  : str_slice = "6";
            7  : str_slice = "7";
            8  : str_slice = "8";
            9  : str_slice = "9";
            10 : str_slice = "A";
            11 : str_slice = "B";
            12 : str_slice = "C";
            13 : str_slice = "D";
            14 : str_slice = "E";
            15 : str_slice = "F";
        endcase
        str_data = {str_slice, str_data};
    end

    return str_data;

endfunction

endmodule
// TB_DECODER