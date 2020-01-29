-- ============================================================================
--  Title       : DECODER
--
--  File Name   : DECODER.vhd
--  Project     : DECODER
--  Block       :
--  Tree        :
--  Designer    : toms74209200 <https://github.com/toms74209200>
--  Created     : 2019/11/10
--  Copyright   : 2019 toms74209200
--  License     : MIT License.
--                http://opensource.org/licenses/mit-license.php
-- ============================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity DECODER is
    port(
    -- System --
        CLK                 : in    std_logic;                          --(p) Clock
        RESET_n             : in    std_logic;                          --(n) Reset

    -- Control --
        SINK_VALID          : in    std_logic;                          --(p) Sink data valid
        SINK_DATA           : in    std_logic_vector(3 downto 0);       --(p) Sink data

        SOURCE_VALID        : out   std_logic;                          --(p) Source data valid
        SOURCE_DATA         : out   std_logic_vector(15 downto 0)       --(p) Source data
        );
end DECODER;

architecture RTL of DECODER is

-- Internal signal --
signal source_data_i        : std_logic_vector(15 downto 0);            -- Decode data
signal source_valid_i       : std_logic;                                -- Source data valid

begin
-- ============================================================================
--  Decoder
-- ============================================================================
process (CLK, RESET_n) begin
    if (RESET_n = '0') then
        source_data_i <= (others => '0');
    elsif (CLK'event and CLK = '1') then
        if (SINK_VALID = '1') then
            case (SINK_DATA) is
                when X"0" => source_data_i <= (0  => '1', others => '0');
                when X"1" => source_data_i <= (1  => '1', others => '0');
                when X"2" => source_data_i <= (2  => '1', others => '0');
                when X"3" => source_data_i <= (3  => '1', others => '0');
                when X"4" => source_data_i <= (4  => '1', others => '0');
                when X"5" => source_data_i <= (5  => '1', others => '0');
                when X"6" => source_data_i <= (6  => '1', others => '0');
                when X"7" => source_data_i <= (7  => '1', others => '0');
                when X"8" => source_data_i <= (8  => '1', others => '0');
                when X"9" => source_data_i <= (9  => '1', others => '0');
                when X"A" => source_data_i <= (10 => '1', others => '0');
                when X"B" => source_data_i <= (11 => '1', others => '0');
                when X"C" => source_data_i <= (12 => '1', others => '0');
                when X"D" => source_data_i <= (13 => '1', others => '0');
                when X"E" => source_data_i <= (14 => '1', others => '0');
                when X"F" => source_data_i <= (15 => '1', others => '0');
                when others => source_data_i <= (others => '0');
            end case;
        end if;
    end if;
end process;

SOURCE_DATA <= source_data_i;


-- ============================================================================
--  Data valid
-- ============================================================================
process (CLK, RESET_n) begin
    if (RESET_n = '0') then
        source_valid_i <= '0';
    elsif (CLK'event and CLK = '1') then
        source_valid_i <= SINK_VALID;
    end if;
end process;

SOURCE_VALID <= source_valid_i;


end RTL;    -- DECODER