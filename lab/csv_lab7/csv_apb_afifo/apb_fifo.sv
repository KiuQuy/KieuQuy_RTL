module apb_fifo
    (
	
	// clock domain 3
    input clk3, rst_n3,
    
	// apb slave: interface for register block
    apb_intf.slv    apb_intf_slv1,  // => apb_slave 1
    apb_intf.slv    apb_intf_slv2  // => apb_slave 2
    );
	
	// interface between register block and async fifo 
	// dstm_intf 
	// domain 1
	dstm_intf   dstm_intf_write_tx_1();
    dstm_intf   dstm_intf_read_rx_1();	
	// domain 2
	dstm_intf   dstm_intf_write_tx_2();
    dstm_intf   dstm_intf_read_rx_2();
	
	
	//  status
	// domain 1
	fifo_stalvl fifo_stalvl_status_tx1();
	fifo_stalvl fifo_stalvl_status_tx2();
	// domain 2
	fifo_stalvl fifo_stalvl_status_rx1();
	fifo_stalvl fifo_stalvl_status_rx2();
	
	// config
	
	fifo_stalvl config_rx1();
	fifo_stalvl config_rx2();
	fifo_stalvl config_tx1();
	fifo_stalvl config_tx2();
	// interface between async fifo in domain 1 and async fifo in domain 2
	// handshaking
	dstm_intf   write();
	dstm_intf   read();
	
	//assign write.
// instantiate register block
register_block  regblock1
    (
    .apb_slave( apb_intf_slv1),
	.write_tx(dstm_intf_write_tx_1),
	.config_tx(config_tx1),
	.status_tx(fifo_stalvl_status_tx1),
	.read_rx(dstm_intf_read_rx_1),
	.config_rx(config_rx1),
	.status_rx(fifo_stalvl_status_rx1)
	);
	
register_block  regblock2
    (
    .apb_slave( apb_intf_slv2),
	.write_tx(dstm_intf_write_tx_2),
	.config_tx(config_tx2),
	.status_tx(fifo_stalvl_status_tx2),
	.read_rx(dstm_intf_read_rx_2),
	.config_rx(config_rx2),
	.status_rx(fifo_stalvl_status_rx2)
	);
// instantiate fifo
csv_afifo afifo_tx1
    (
	.i_clk_s (apb_intf_slv1.pclk),
	.i_rst_n_s(apb_intf_slv1.preset_n),
	.s_dstm(dstm_intf_write_tx_1),
	.s_config(config_tx1),
	
	.i_clk_m(clk3),
	.i_rst_n_m(rst_n3),
	.m_dstm(write),
	.m_stalvl(fifo_stalvl_status_tx1)
	);
	
csv_afifo afifo_tx2
    (
	.i_clk_s (clk3),
	.i_rst_n_s(rst_n3),
	.s_dstm(dstm_intf_write_tx_2),
	.s_config(config_tx2),
	
	.i_clk_m(apb_intf_slv2.pclk),
	.i_rst_n_m(apb_intf_slv2.preset_n),
	.m_dstm(read),
	.m_stalvl(fifo_stalvl_status_tx2)
	);
	
csv_afifo afifo_rx1
    (
	.i_clk_s (apb_intf_slv1.pclk),
	.i_rst_n_s(apb_intf_slv1.preset_n),
	.s_dstm(read),
	.s_config(config_rx1),
	
	.i_clk_m(clk3),
	.i_rst_n_m(rst_n3),
	.m_dstm(dstm_intf_read_rx_1),
	.m_stalvl(fifo_stalvl_status_rx1)
	);
	
csv_afifo afifo_rx2
    (
	.i_clk_s (clk3),
	.i_rst_n_s(rst_n3),
	.s_dstm(write),
	.s_config(config_rx2),
	
	.i_clk_m(apb_intf_slv2.pclk),
	.i_rst_n_m(apb_intf_slv2.preset_n),
	.m_dstm(dstm_intf_read_rx_2),
	.m_stalvl(fifo_stalvl_status_rx2)
	);
	

endmodule: apb_fifo