module ksa(

    //////////// CLOCK //////////
    CLOCK_50,

    //////////// LED //////////
    LEDR,

    //////////// KEY //////////
    KEY,

    //////////// SW //////////
    SW,

    //////////// SEG7 //////////
    HEX0,
    HEX1,
    HEX2,
    HEX3,
    HEX4,
    HEX5,
);

//////////// CLOCK //////////
input                       CLOCK_50;

//////////// LED //////////
output           [9:0]      LEDR;

//////////// KEY //////////
input            [3:0]      KEY;

//////////// SW //////////
input            [9:0]      SW;

//////////// SEG7 //////////
output           [6:0]      HEX0;
output           [6:0]      HEX1;
output           [6:0]      HEX2;
output           [6:0]      HEX3;
output           [6:0]      HEX4;
output           [6:0]      HEX5;


//=======================================================
//  REG/WIRE declarations
//=======================================================
// Input and output declarations
logic CLK_50M;
logic  [9:0] LED;
logic reset_n;
assign CLK_50M =  CLOCK_50;
//assign LEDR[9:0] = LED[9:0];

//=======================================================================================================================
//
// Insert your code for Lab4 here!
//
//
reg[23:0] secret_key;
//always_comb secret_key[9:0] = SW[9:0];
reg[23:0] curr_key;

wire decrypt_reset;
//assign decrypt_reset = KEY[3];
wire init_reset;
wire shuffle_reset;
wire compute_reset;

wire decrypt_start;
wire init_start;
wire shuffle_start;
wire compute_start;
wire brute_force_start = 1'b1;

wire decrypt_complete;
wire init_complete;
wire shuffle_complete;
wire compute_complete;
wire brute_force_complete;

reg[7:0] data_init;
reg[7:0] address_init;
wire wren_init;

reg[7:0] data_shuffle;
reg[7:0] address_shuffle;
wire wren_shuffle;

reg[7:0] data_compute;
reg[7:0] address_compute;
wire wren_compute;

reg[7:0] data_out;
reg[7:0] address_out;
reg[7:0] q_out;
wire wren_out;

reg[7:0] q_rom_out;
reg[4:0] address_rom_out;

reg[7:0] data_decrypt_out;
reg[7:0] address_decrypt_out;
reg[7:0] q_decrypt_out;
wire wren_decrypt_out;

wire led_sel;

brute_force
brute_force_insta(
.clk(CLK_50M),
.start(1),
.decrypt_msg_data(data_decrypt_out),
.wren_start(wren_decrypt_out),
.compute_complete(compute_complete),
.LED_sel(led_sel),
.start_decrypt(decrypt_start),
.reset_decrypt(decrypt_reset),
.secret_key(secret_key),
.HEX_out(curr_key)
);

assign LEDR = led_sel ? 10'b11111_11111 : {9'b0,1'b1}; 

decrypt
decrypt_insta(
.clk(CLK_50M),
.reset(decrypt_reset),
.decrypt_start(decrypt_start),
.decrypt_complete(decrypt_complete),
//init
.init_start(init_start),
.init_complete(init_complete),
.address_init(address_init),
.data_init(data_init),
.wren_init(wren_init),
.init_reset(init_reset),
//shuffle
.shuffle_start(shuffle_start),
.shuffle_complete(shuffle_complete),
.address_shuffle(address_shuffle),
.data_shuffle(data_shuffle),
.wren_shuffle(wren_shuffle),
.shuffle_reset(shuffle_reset),
//compute
.compute_start(compute_start),
.compute_complete(compute_complete),
.address_compute(address_compute),
.data_compute(data_compute),
.wren_compute(wren_compute),
.compute_reset(compute_reset),
//output
.address_out(address_out),
.data_out(data_out),
.wren_out(wren_out));

init
init_insta(
.clk(CLK_50M),
.start(init_start),
.reset(init_reset),
.data(data_init),
.address(address_init),
.wren(wren_init),
.complete(init_complete)
);

shuffle
shuffle_insta(
.clk(CLK_50M),
.key(secret_key),
.reset(shuffle_reset),
.start(shuffle_start),
.q(q_out),
.data(data_shuffle),
.address(address_shuffle),
.wren(wren_shuffle),
.complete(shuffle_complete)
);

compute
compute_insta(
.clk(CLK_50M),
.reset(compute_reset),
.start(compute_start),
.rom_data(q_rom_out),
.q(q_out),
.data(data_compute),
.address(address_compute),
.wren(wren_compute),
.rom_addr(address_rom_out),
.data_decrypt(data_decrypt_out),
.address_decrypt(address_decrypt_out),
.wren_decrypt(wren_decrypt_out),
.complete(compute_complete)
);

r_memory
r_memory_insta(
.address(address_rom_out),
.clock(CLK_50M),
.q(q_rom_out)
);

d_memory
d_memory_insta(
.address(address_decrypt_out),
.clock(CLK_50M),
.data(data_decrypt_out),
.wren(wren_decrypt_out),
.q(q_decrypt_out)
);

s_memory
s_memory_insta(
.address(address_out),
.clock(CLK_50M),
.data(data_out),
.wren(wren_out),
.q(q_out)
);

//=====================================================================================
//
//  Seven-Segment and speed control
//
//=====================================================================================
     
        
logic [7:0] Seven_Seg_Val[5:0];
logic [3:0] Seven_Seg_Data[5:0];
    
SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst0(.ssOut(Seven_Seg_Val[0]), .nIn(Seven_Seg_Data[0]));
SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst1(.ssOut(Seven_Seg_Val[1]), .nIn(Seven_Seg_Data[1]));
SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst2(.ssOut(Seven_Seg_Val[2]), .nIn(Seven_Seg_Data[2]));
SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst3(.ssOut(Seven_Seg_Val[3]), .nIn(Seven_Seg_Data[3]));
SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst4(.ssOut(Seven_Seg_Val[4]), .nIn(Seven_Seg_Data[4]));
SevenSegmentDisplayDecoder SevenSegmentDisplayDecoder_inst5(.ssOut(Seven_Seg_Val[5]), .nIn(Seven_Seg_Data[5]));

assign HEX0 = Seven_Seg_Val[0];
assign HEX1 = Seven_Seg_Val[1];
assign HEX2 = Seven_Seg_Val[2];
assign HEX3 = Seven_Seg_Val[3];
assign HEX4 = Seven_Seg_Val[4];
assign HEX5 = Seven_Seg_Val[5];
            
        
logic [23:0] actual_7seg_output;
reg [23:0] regd_actual_7seg_output;

always @(posedge CLK_50M)
begin
    regd_actual_7seg_output <= actual_7seg_output;
end


assign Seven_Seg_Data[0] = regd_actual_7seg_output[3:0];
assign Seven_Seg_Data[1] = regd_actual_7seg_output[7:4];
assign Seven_Seg_Data[2] = regd_actual_7seg_output[11:8];
assign Seven_Seg_Data[3] = regd_actual_7seg_output[15:12];
assign Seven_Seg_Data[4] = regd_actual_7seg_output[19:16];
assign Seven_Seg_Data[5] = regd_actual_7seg_output[23:20];
    
assign actual_7seg_output =  curr_key;


endmodule