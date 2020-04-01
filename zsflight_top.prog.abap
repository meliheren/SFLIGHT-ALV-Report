*&---------------------------------------------------------------------*
*&  Include           Z_TOP
*&---------------------------------------------------------------------*
TABLES: sflight,spfli,scarr,sscrfields,zodev_1.

*Notes:...
*SSCRFIELDS is a predefined structure used to assign display values for
*function keys.
TYPE-POOLS: slis. "SLIS Contains all the ALV data Types


DATA : BEGIN OF gt_flight OCCURS 0, "tüm kayıtlar için structure

  carrid      LIKE  sflight-carrid,
  carrname    LIKE  scarr-carrname,
  connid      LIKE  sflight-connid,
  fldate      LIKE  sflight-fldate,
  price       LIKE  sflight-price,
  currency    LIKE  sflight-currency,
  paymentsum  LIKE  sflight-paymentsum,
  planetype   LIKE  sflight-planetype,
  countryfr   LIKE  spfli-countryfr,
  cityfrom    LIKE  spfli-cityfrom,
  airpfrom    LIKE  spfli-airpfrom,
  countryto   LIKE  spfli-countryto,
  cityto      LIKE  spfli-cityto,
  airpto      LIKE  spfli-airpto,
  fltime      LIKE  spfli-fltime,
  notlar(100),
  line_color(4), "Renk değerleri tutulur.
  cellcolor TYPE lvc_t_scol, "Cell Color
  sel,

  END OF gt_flight.

DATA: BEGIN OF gs_flight, "gs flight work area
  carrid      TYPE  sflight-carrid,
  carrname    TYPE  scarr-carrname,
  connid      TYPE  sflight-connid,
  fldate      TYPE  sflight-fldate,
  price       TYPE  sflight-price,
  currency    TYPE  sflight-currency,
  paymentsum  TYPE  sflight-paymentsum,
  planetype   TYPE  sflight-planetype,
  countryfr   TYPE  spfli-countryfr,
  cityfrom    TYPE  spfli-cityfrom,
  airpfrom    TYPE  spfli-airpfrom,
  countryto   TYPE  spfli-countryto,
  cityto      TYPE  spfli-cityto,
  airpto      TYPE  spfli-airpto,
  fltime      TYPE  spfli-fltime,
  not(100),
  line_color(4), "Renk değerleri tutulur.
  cellcolor TYPE lvc_t_scol, "Cell Color
  sel,
  END OF gs_flight.


DATA: BEGIN OF gt_zflight OCCURS 0, "ztablosu itab
  kayit_tarihi          LIKE sy-datum,
  kayit_saati           LIKE sy-uzeit,
  kaydeden_kullanici    LIKE sy-uname,
  degistiren_tarihi     LIKE sy-datum,
  degistiren_saati      LIKE sy-uzeit,
  degistiren_kullanici  LIKE sy-uname,
  carrid      LIKE sflight-carrid,
  carrname    LIKE scarr-carrname,
  connid      LIKE sflight-connid,
  fldate      LIKE sflight-fldate,
  price       LIKE sflight-price,
  currency    LIKE sflight-currency,
  paymentsum  LIKE sflight-paymentsum,
  planetype   LIKE sflight-planetype,
  countryfr   LIKE spfli-countryfr,
  cityfrom    LIKE spfli-cityfrom,
  airpfrom    LIKE spfli-airpfrom,
  countryto   LIKE  spfli-countryto,
  cityto      LIKE  spfli-cityto,
  airpto      LIKE  spfli-airpto,
  fltime      LIKE  spfli-fltime,
  not(100),
  END OF gt_zflight.

DATA: BEGIN OF gs_zflight, "ztablosu workarea
  kayit_tarihi          TYPE sy-datum,
  kayit_saati           TYPE sy-uzeit,
  kaydeden_kullanici    TYPE sy-uname,
  degistiren_tarihi     TYPE sy-datum,
  degistiren_saati      TYPE sy-uzeit,
  degistiren_kullanici  TYPE sy-uname,
  carrid      TYPE sflight-carrid,
  carrname    TYPE scarr-carrname,
  connid      TYPE sflight-connid,
  fldate      TYPE sflight-fldate,
  price       TYPE sflight-price,
  currency    TYPE sflight-currency,
  paymentsum  TYPE sflight-paymentsum,
  planetype   TYPE sflight-planetype,
  countryfr   TYPE spfli-countryfr,
  cityfrom    TYPE spfli-cityfrom,
  airpfrom    TYPE spfli-airpfrom,
  countryto   TYPE  spfli-countryto,
  cityto      TYPE  spfli-cityto,
  airpto      TYPE  spfli-airpto,
  fltime      TYPE  spfli-fltime,
  not(100),
  END OF gs_zflight.


*Local variable decleration
DATA: c_sel TYPE n.

*itab decleration
DATA: ct_fcat TYPE slis_t_fieldcat_alv WITH HEADER LINE,
      cs_fieldcat TYPE slis_fieldcat_alv,
      cs_field TYPE slis_t_specialcol_alv,
      ct_layout TYPE slis_layout_alv.



* work area declerations
DATA: wa_fcat             LIKE LINE OF ct_fcat,
      "ALV control: Structure for cell coloring
      wa_cellcolor        TYPE lvc_s_scol, "renklendirme wa
      lv_index            TYPE sy-tabix.


SELECTION-SCREEN: BEGIN OF BLOCK blk1 WITH FRAME TITLE text-001.
SELECT-OPTIONS so_carid FOR sflight-carrid.
SELECT-OPTIONS so_conid FOR sflight-connid.
*SELECT-OPTIONS so_ctime FOR spfli-fltime.
SELECT-OPTIONS so_date FOR sflight-fldate OBLIGATORY.
SELECTION-SCREEN END OF BLOCK blk1.

SELECTION-SCREEN: BEGIN OF BLOCK blk2 WITH FRAME TITLE text-002.

PARAMETERS: p_gun RADIOBUTTON GROUP gr1,
            p_log RADIOBUTTON GROUP gr1.

SELECTION-SCREEN END OF BLOCK blk2.
