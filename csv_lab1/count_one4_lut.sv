// Code your design here
// Code your design here
/*
way to implement LUT
[1] case statement
[2] use always_ff to save data
[3] use mem
*/
module count 
    #(parameter N = 32)
    (
	input clk, rst_n,
    input [N - 1 : 0] data,
    output logic [$clog2(N) : 0] cout_o
	); 
    localparam [2 : 0] LUT [0 : 15] = {3'd0, 3'd1, 3'd1, 3'd2, 3'd1, 3'd2, 3'd2, 3'd3, 3'd1, 3'd2, 3'd2, 3'd3, 3'd2, 3'd3, 3'd3, 3'd4};
    logic [2 : 0] LUT4 [7 : 0];
	logic [$clog2(N) - 1 : 0] carry [1 : 0];
	logic [$clog2(N) - 1 : 0] cout;
	always_comb
	    begin
		    for(int i = 0; i < 8; i++)
			    begin
				    LUT4[i] = LUT[{data[4 * i + 0], data[4 * i + 1], data[4 * i + 2], data[4 * i + 3]}];
				end
			carry[0] = LUT4[0] + LUT4[1] + LUT4[2] + LUT4[3];
			carry[1] = LUT4[4] + LUT4[5] + LUT4[6] + LUT4[7];
			cout = carry[0] + carry[1];
			
		end
	
	always_ff @(posedge clk or negedge rst_n)
	    if(!rst_n)
		    cout_o <= 0;
		else
		    cout_o <= cout;

endmodule: count
/*
#include <iostream>
using namespace std;
#include <fstream>
unsigned int countSetBits(unsigned int n)
{
    unsigned int count = 0;
    while (n) {
        count += n & 1;
        n >>= 1;
    }
    return count;
}
 

int main()
{

    freopen("design.v", "w", stdout);
    
    cout << "module count (" << endl;
    cout << "input [3 : 0] data," << endl;
    cout << "output [2 : 0] cout); " << endl;
    cout << "localparam [2 : 0] LUT [0 : 15] = {";
    for (int i = 0; i < 16; i++)
    {
        int k = countSetBits(i);
        cout << "3'd"<< k <<", ";
    }
    cout << "};" << endl;
    cout <<"assign cout = LUT[data];" << endl;
    cout << "endmodule: count" << endl;
    return 0;
}
*/