library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity tb_smbus is
end tb_smbus;

architecture tb_Behavioral of tb_smbus is

  signal clk_tb,reset_tb,ena_tb,pec_tb,rw_tb,busy_tb,sda_tb,scl_tb,ack_error_tb,data_valid_tb,read_req_tb: std_logic;
  signal addr_tb: std_logic_vector(6 downto 0);
  signal data_wr_tb,data_rd_tb,data_to_master_tb : std_logic_vector(7 downto 0);
  
  component SMBus_master is
    generic(
      input_clk : integer := 50_000_000; --input clock speed from user logic in Hz
      bus_clk   : integer := 400_000);   --speed the SMbus (scl) will run at in Hz
    port(
      clk       : in     std_logic;                   
      reset_n   : in     std_logic;                   
      ena       : in     std_logic;                   
      pec       : in     std_logic;
      addr      : in     std_logic_vector(6 downto 0); 
      rw        : in     std_logic;                    
      data_wr   : in     std_logic_vector(7 downto 0); 
      busy      : out    std_logic;                   
      data_rd   : out    std_logic_vector(7 downto 0); 
      ack_error : inout std_logic;                    
      sda       : inout  std_logic;                    --serial data output 
      scl       : inout  STD_LOGIC);                   --serial clock output 
  end component;
  
component smbus_slave is
  generic (
    SLAVE_ADDR : std_logic_vector(6 downto 0) );
  port (
   
    clk              : in    std_logic;
    reset_n          : in    std_logic;
    pec              : in   std_logic;
    read_req         : out   std_logic;
    data_to_master   : in    std_logic_vector(7 downto 0);
    data_valid       : out   std_logic;
    --data_from_master : out   std_logic_vector(7 downto 0);
    scl              : inout std_logic;
    sda              : inout std_logic);  
end component;
  
  
  
component tester_SMBus is
port(
    clk       : out     std_logic;                   
    reset_n   : out     std_logic;                   
    ena       : out     std_logic;                   
    pec       : out     std_logic;
    addr      : out     std_logic_vector(6 downto 0); 
    rw        : out     std_logic;                    
    data_wr   : out     std_logic_vector(7 downto 0); 
    data_to_master   : out    std_logic_vector(7 downto 0);
    busy      : in    std_logic;                   
    data_rd   : in    std_logic_vector(7 downto 0); 
    ack_error : inout std_logic;                    
    sda       : inout  std_logic;                    --serial data output of SMbus
    scl       : inout  std_logic);                   --serial clock output of SMbus
END component;
 begin
        slv1 : smbus_slave generic map(   
                                          SLAVE_ADDR =>"1100101"
                                       )
        port map (clk => clk_tb,
				            reset_n=>reset_tb,
				            pec=>pec_tb,
				            read_req=>read_req_tb,
				            --data_from_master=>data_from_master_tb,
				            data_valid=>data_valid_tb,
				            data_to_master=>data_to_master_tb,
				            sda=>sda_tb,
				            scl=>scl_tb 	  		            
				             	  );
        slv2 : smbus_slave generic map(   
                                          SLAVE_ADDR =>"1010101"
                                       )
        port map (clk => clk_tb,
				            reset_n=>reset_tb,
				            pec=>pec_tb,
				            read_req=>read_req_tb,
				            --data_from_master=>data_from_master_tb,
				            data_valid=>data_valid_tb,
				            data_to_master=>data_to_master_tb,
				            sda=>sda_tb,
				            scl=>scl_tb 	  		            
				             	  );
					         
					     
        mstr : SMBus_master port map (clk => clk_tb,
				     reset_n=>reset_tb,
				     ena=>ena_tb,
				     pec=>pec_tb,
				     addr=>addr_tb,
				     rw=>rw_tb,
				     data_wr=>data_wr_tb,
				     busy=>busy_tb,
				     data_rd=>data_rd_tb,
				     ack_error=>ack_error_tb,
				     sda=>sda_tb,
				     scl=>scl_tb );

        tstr : tester_SMBus port map(clk => clk_tb,
				     reset_n=>reset_tb,
				     ena=>ena_tb,
				     pec=>pec_tb,
				     addr=>addr_tb,
				     rw=>rw_tb,
				     data_wr=>data_wr_tb,
				     busy=>busy_tb,
				     data_to_master=>data_to_master_tb,
				     data_rd=>data_rd_tb,
				     ack_error=>ack_error_tb,
				     sda=>sda_tb,
				     scl=>scl_tb );
end tb_Behavioral;
 







