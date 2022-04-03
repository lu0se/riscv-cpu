`include "ctrl_encode_def.v"

module EXT(input	[11:0]			iimm,
           input	[11:0]			simm,         //instr[31:25, 11:7], 12 bits
           input	[11:0]			bimm,         //instrD[31], instrD[7], instrD[30:25], instrD[11:8], 12 bits
           input	[19:0]			uimm,
           input	[19:0]			jimm,
           input	[4:0]			EXTOp,
           output	reg [31:0] 	 immout);
    
    always  @(*)
        case (EXTOp)
            `EXT_CTRL_ITYPE:	immout    <= {{20{iimm[11]}}, iimm[11:0]};
            `EXT_CTRL_STYPE:	immout    <= {{20{simm[11]}}, simm[11:0]};
            `EXT_CTRL_BTYPE:    immout <= {{19{bimm[11]}}, bimm[11:0],1'b0};
            `EXT_CTRL_UTYPE:	immout    <= {uimm[19:0], 12'b0};
            `EXT_CTRL_JTYPE:	immout    <= {{12{jimm[19]}},jimm[7:0],jimm[8],jimm[18:9],1'b0};
            `SHAMT:				immout          <= {{26{iimm[11]}}, iimm[4:0]};
            default:	        immout    <= 32'b0;
        endcase
    
    
endmodule
