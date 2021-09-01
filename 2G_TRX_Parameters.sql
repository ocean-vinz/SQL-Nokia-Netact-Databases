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

column bscId        format A6
column bcfId        format A6
column btsId        format A6
column trxId        format A6

ALTER SESSION SET NLS_DATE_FORMAT = 'MM/DD/YYYY HH24:MI:SS';

spool &1

select DISTINCT   
	 bsc.object_instance                                    bscId
	,bcf.object_instance                                    bcfId
	,bts.object_instance                                    btsId
	,trx.object_instance                                    trxId
    ,c_trx.GPRS_ENABLED_TRX
    ,decode(c_trx.HALF_RATE_SUPPORT,0,'N',1,'Y') HRS
    ,c_trx.INITIAL_FREQUENCY
    ,c_trx.PREFERRED_BCCH_MARK
    ,c_trx.TSC
    ,decode(c_trx.DAP_ID,65535,'N',c_trx.DAP_ID) DAP_ID
    ,c_trx.CH_0_TYPE
    ,c_trx.CH_1_TYPE
    ,c_trx.CH_2_TYPE
    ,c_trx.CH_3_TYPE
    ,c_trx.CH_4_TYPE
    ,c_trx.CH_5_TYPE
    ,c_trx.CH_6_TYPE
    ,c_trx.CH_7_TYPE
    ,c_trx.CH_0_PCM
    ,c_trx.CH_0_TSL
    ,c_trx.OPTIMUM_RX_LEV_UL
    ,c_trx.OPTIMUM_RX_LEV_DL
    ,c_trx.LAPD_LINK_NAME
    ,s_trx.stateinmode1                                     adminState
    ,to_char(c_trx.LAST_MODIFIED,'MM/DD/YYYY')             	LAST_MODIFIED_DATE
    ,to_char(c_trx.LAST_MODIFIED,'HH24:MI:SS')             	LAST_MODIFIED_TIME
    ,c_trx.LAST_MODIFIER
    ,c_trx.ABILITIES
    ,c_trx.AUTO_CONFIG
    ,c_trx.BG_DIRECT_ACCESS_LEVEL
    ,c_trx.BG_DIRECT_ACCESS_LEVEL_FLAG
    ,c_trx.BG_INITIAL_FREQUENCY
    ,c_trx.BG_INITIAL_FREQUENCY_FLAG
    ,c_trx.BG_INTF_CELLS_USED_FLAG
    ,c_trx.BG_OPTIMUM_RX_LEV_UL
    ,c_trx.BG_OPTIMUM_RX_LEV_UL_FLAG
    ,c_trx.BG_TRX_FREQUENCY_TYPE
    ,c_trx.BG_TRX_FREQUENCY_TYPE_FLAG
    ,c_trx.BG_TSC
    ,c_trx.BG_TSC_FLAG
    ,c_trx.CH_0_ADMIN_STATE
    ,c_trx.CH_0_MAIO
    ,c_trx.CH_0_PCM
    ,c_trx.CH_0_SUBSLOT
    ,c_trx.CH_0_TSL
    ,c_trx.CH_1_ADMIN_STATE
    ,c_trx.CH_1_MAIO
    ,c_trx.CH_1_PCM
    ,c_trx.CH_1_SUBSLOT
    ,c_trx.CH_1_TSL
    ,c_trx.CH_1_TYPE
    ,c_trx.CH_2_ADMIN_STATE
    ,c_trx.CH_2_MAIO
    ,c_trx.CH_2_PCM
    ,c_trx.CH_2_SUBSLOT
    ,c_trx.CH_2_TSL
    ,c_trx.CH_2_TYPE
    ,c_trx.CH_3_ADMIN_STATE
    ,c_trx.CH_3_MAIO
    ,c_trx.CH_3_PCM
    ,c_trx.CH_3_SUBSLOT
    ,c_trx.CH_3_TSL
    ,c_trx.CH_3_TYPE
    ,c_trx.CH_4_ADMIN_STATE
    ,c_trx.CH_4_MAIO
    ,c_trx.CH_4_PCM
    ,c_trx.CH_4_SUBSLOT
    ,c_trx.CH_4_TSL
    ,c_trx.CH_4_TYPE
    ,c_trx.CH_5_ADMIN_STATE
    ,c_trx.CH_5_MAIO
    ,c_trx.CH_5_PCM
    ,c_trx.CH_5_SUBSLOT
    ,c_trx.CH_5_TSL
    ,c_trx.CH_5_TYPE
    ,c_trx.CH_6_ADMIN_STATE
    ,c_trx.CH_6_MAIO
    ,c_trx.CH_6_PCM
    ,c_trx.CH_6_SUBSLOT
    ,c_trx.CH_6_TSL
    ,c_trx.CH_6_TYPE
    ,c_trx.CH_7_ADMIN_STATE
    ,c_trx.CH_7_MAIO
    ,c_trx.CH_7_PCM
    ,c_trx.CH_7_SUBSLOT
    ,c_trx.CH_7_TSL
    ,c_trx.CH_7_TYPE
    ,c_trx.COMBINED_SIGNALLING
    ,c_trx.DFCA_INDIC
    ,c_trx.DIRECT_ACCESS_LEVEL
    ,c_trx.E_TRX_IND
    ,c_trx.HP_METRO
    ,c_trx.LAPD_LINK_NAME
    ,c_trx.LAPD_LINK_NUMBER
    ,c_trx.OM_LAPD_LINK_NAME
    ,c_trx.OM_LAPD_LINK_NUMBER
    ,c_trx.OPTIMUM_RX_LEV_DL
    ,c_trx.OPTIMUM_RX_LEV_UL
    ,c_trx.SUBSLOTS_FOR_SIGNALLING
    ,c_trx.TRX_FREQUENCY_TYPE

from  	 	 
     OBJECTS                BSC
    ,OBJECTS                BCF
    ,OBJECTS                BTS    
	,OBJECTS                TRX
    ,C_TRX
    ,OBJECT_MODESTATES 	    S_TRX
where
    (1=1)
	AND C_TRX.CONF_NAME = '<ACTUAL>'    
	AND TRX.INT_ID = C_TRX.INT_ID
    AND S_TRX.INT_ID = TRX.INT_ID
	AND TRX.PARENT_INT_ID = BTS.INT_ID
	AND BTS.PARENT_INT_ID = BCF.INT_ID
	AND BCF.PARENT_INT_ID = BSC.INT_ID
	AND BTS.OBJECT_CLASS = 4
	AND BCF.OBJECT_CLASS = 27
	AND BSC.OBJECT_CLASS = 3
	AND BSC.OBJECT_INSTANCE <> '0'
order by
	bsc.object_instance,bcf.object_instance,bts.object_instance,trx.object_instance
;

spool off;
quit;
