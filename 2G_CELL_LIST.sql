REM *********************************************************************
REM >>>>>>>>>Dont use or change this script without permission<<<<<<<<<<<
REM *********************************************************************
REM
REM     Author: Irvino
REM     e-mail: irvino@irvino.com
REM     Copyright (c) Irvino 2011
REM
REM *********************************************************************

clear breaks
set termout on
set colsep ,
set headsep off
set underline off
set echo off heading on
set feedback off
set pagesize 50000
set newpage 1
set linesize 3000
set trimspool on
set trimout on
set verify off
set wrap off
spool cell_list.csv
column cell format A18 heading 'BTS_NAME'
column bsc format A18 heading 'BSC_NAME'
column BSC_SW_RELEASE format 999990 heading 'BSC_VER'
column NE_SW_VERSION format a10 heading 'SW_VER'
column segname format A18 heading 'SEGMENT_NAME'
column int_id format 999999999990 heading 'INT_ID'
column bsc_id format a7 heading 'BSC_ID'
column bcf_id format a7 heading 'BCF_ID'
column bts_id format a7 heading 'BTS_ID'
column master_bts format a1 heading 'MASTER_BTS'
column seg_id format 999990 heading 'SEG_ID'
column lac format 9990 heading 'LAC'
column cell_id format 99990 heading 'CI'
column ncc format 990 heading 'NCC'
column bcc format 990 heading 'BCC'
column freq format 9990 heading 'FREQ'
column NSEI format 99990 heading 'NSEI'
column FRU format 990 heading 'FRU'
column FRL format 990 heading 'FRL'
column bcf_bts_st format a8 heading 'STATES' JUSTIFY right
SELECT
     o_bsc.name bsc,
     o_bts.name cell,
     o_bcf.name bcf_name,
     c_bts.SEGMENT_NAME segname,
     c_bts.SEGMENT_ID seg_id,
     to_char(o_bsc.object_instance,'999990') bsc_id,
     to_char(o_bcf.object_instance,'999990') bcf_id,
     to_char(o_bts.object_instance,'999990') bts_id,
     decode(c_bts.master_bts,0,'S',1,'M') master_bts,
     o_bts.int_id int_id,
     c_bts.la_id_lac lac,
     c_bts.cell_id cell_id,
     c_bts.bsic_ncc ncc,
     c_bts.bsic_bcc bcc,
     c_trx.INITIAL_FREQUENCY freq,
     c_bts.NSEI NSEI,
     c_bts.BTS_SP_LOAD_DEP_TCH_RATE_UPPER FRU,
     c_bts.BTS_SP_LOAD_DEP_TCH_RATE_LOWER FRL,
     decode(s_bcf.stateinmode1,0,'N',1,'U',2,'S',3,'L')||decode(s_bts.stateinmode1,0,'N',1,'U',2,'S',3,'L') bcf_bts_st
     ,c_bts.MAIO_OFFSET MAIO_OFFSET
     ,c_bts.MAIO_STEP MAIO_STEP
     ,c_bts.USED_MOBILE_ALLOC_LIST_ID USED_MOBILE_ALLOC_LIST_ID
     ,c_power_control.pc_ctrl_enabled  
     ,c_bts.HOPPING_MODE
     ,c_bts.GPRS_ENABLED
     ,c_bts.EGPRS_ENABLED
     ,c_bts.HSN_1
     ,c_bts.HSN_2              
FROM
     objects o_bsc,
     objects o_bcf,
     objects o_bts,
     objects o_trx,
     objects poc,
     c_trx,
     c_bts,
     object_modestates s_bts,
	 object_modestates s_bcf,
	 object_modestates s_bsc,
     c_power_control
WHERE
   		c_trx.conf_name= '<ACTUAL>'
        AND
        c_bts.conf_name= '<ACTUAL>'
        AND
        o_trx.int_id = c_trx.int_id
        AND
        o_bts.int_id = c_bts.int_id
        AND
        o_trx.parent_int_id = o_bts.int_id
        AND
        o_bts.parent_int_id = o_bcf.int_id
        AND
        o_bcf.parent_int_id = o_bsc.int_id
        AND
        o_bsc.object_instance > '1'
        AND
        o_bsc.object_class =3
        AND
        c_trx.CH_0_TYPE=4 
   		AND
		s_bts.int_id = o_bts.int_id
	 	AND
	    s_bcf.int_id = o_bcf.int_id
	 	AND
	   	s_bsc.int_id = o_bsc.int_id
        AND
	    c_power_control.int_id = poc.int_id
        AND
	    c_bts.int_id = poc.parent_int_id
        AND
 	    c_power_control.conf_name= c_bts.conf_name
        /* and
        o_bsc.name = 'E635' */
ORDER BY 
        bsc_id, bcf_id, bts_id
;


spool off	
exit
