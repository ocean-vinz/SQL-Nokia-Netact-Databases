REM *********************************************************************
REM >>>>>>>>>Dont use or change this script without permission<<<<<<<<<<<
REM *********************************************************************
REM
REM     Author: Irvino
REM     e-mail: irvino@irvino.com
REM     Copyright (c) Irvino 2011
REM
REM *********************************************************************

set termout on
prompt
prompt Spooling data into a file,Please wait !
set termout off

set linesize 10000
set pagesize 50000
set trimspool on
set trimout on
set colsep ,
set underline off;
set feedback off;
set verify off;

column bscId	        format a6
column name             format a25
column LAST_MODIFIER    format a25

ALTER SESSION SET NLS_DATE_FORMAT = 'MM/DD/YYYY HH24:MI:SS';


spool &1

SELECT DISTINCT
     bts.name cell,
     c_bts.la_id_lac lac,
     c_bts.cell_id cell_id,
     bsc.object_instance bsc_id,
     bcf.object_instance bcf_id,
     bts.object_instance bts_id,
     C_ADJACENT_CELL.ADJ_CELL_LAC adj_cell_lac,
     C_ADJACENT_CELL.ADJ_CELL_CI adj_cell_ci,
     bts_target.NAME adj_cell_name,
     C_ADJACENT_CELL.ADJ_CELL_BSIC_NCC ADJ_CELL_BSIC_NCC,
     C_ADJACENT_CELL.ADJ_CELL_BSIC_BCC ADJ_CELL_BSIC_BCC,
     C_ADJACENT_CELL.ADJ_CELL_BCCH_FREQUENCY ADJ_CELL_BCCH_FREQUENCY,
     C_ADJACENT_CELL.HO_PRIORITY_LEVEL,
     C_ADJACENT_CELL.RX_LEV_MIN_CELL,
     C_ADJACENT_CELL.HO_MARGIN_PBGT,
     C_ADJACENT_CELL.HO_MARGIN_LEV,
     C_ADJACENT_CELL.HO_MARGIN_QUAL,
     C_ADJACENT_CELL.HO_LEVEL_UMBRELLA,
     C_ADJACENT_CELL.ENABLE_HO_MARGIN_L_Q,
     C_ADJACENT_CELL.HO_LOAD_FACTOR,
     C_ADJACENT_CELL.MS_PWR_OPT_LEVEL_OPTIMIZATION,
     C_ADJACENT_CELL.MS_PWR_OPT_LEVEL,
     C_ADJACENT_CELL.SYNCHRONIZED,
     C_ADJACENT_CELL.FAST_MOVING_THRESHOLD,
     C_ADJACENT_CELL.ADJ_CELL_LAYER,
     C_ADJACENT_CELL.BG_BSIC_NCC,
     C_ADJACENT_CELL.BG_BSIC_BCC,
     C_ADJACENT_CELL.BG_BCCH_FREQUENCY,
     C_OBJ_RESOLVE_VW.OBJ_DN TargetCellDN
FROM
     OBJECTS BSC,
     OBJECTS BCF,
     OBJECTS BTS,
     OBJECTS BTS_TARGET,
     OBJECTS ADCE,
     C_BTS,
     C_ADJACENT_CELL,
     C_OBJ_RESOLVE_VW
WHERE
	BTS_TARGET.INT_ID = C_ADJACENT_CELL.ADJ_CELL_INT_ID
	AND BTS_TARGET.OBJECT_CLASS = 4
	AND ADCE.INT_ID = C_ADJACENT_CELL.INT_ID
	AND C_BTS.INT_ID = BTS.INT_ID
	AND BTS.INT_ID = ADCE.PARENT_INT_ID 
	AND BTS.INT_ID = C_ADJACENT_CELL.BTS_INT_ID
	AND C_BTS.CONF_NAME = '<ACTUAL>'
	AND C_ADJACENT_CELL.CONF_NAME = '<ACTUAL>'
	AND BTS.PARENT_INT_ID = BCF.INT_ID
	AND BCF.PARENT_INT_ID = BSC.INT_ID
	AND BTS.OBJECT_CLASS = 4
	AND BCF.OBJECT_CLASS = 27
	AND BSC.OBJECT_CLASS = 3
	AND BSC.OBJECT_INSTANCE <> '0' 
	AND BTS.NAME NOT LIKE '%TEST%'
	and C_OBJ_RESOLVE_VW.int_id = C_ADJACENT_CELL.int_id
ORDER BY 
	bts.name 
;
spool off;
quit;
