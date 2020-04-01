*&---------------------------------------------------------------------*
*&  Include           Z_EXECUTE
*&---------------------------------------------------------------------*



*&---------------------------------------------------------------------*
*&      Form  AT_SELECTION_SCREEN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM at_selection_screen .


ENDFORM.                    " AT_SELECTION_SCREEN
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       Gerekli olan data çekildi.
*----------------------------------------------------------------------*

FORM get_data .

  SELECT  sflight~carrid
          sflight~connid
          sflight~fldate
          sflight~price
          sflight~currency
          sflight~paymentsum
          sflight~planetype
          spfli~countryfr
          spfli~cityfrom
          spfli~airpfrom
          spfli~countryto
          spfli~cityto
          spfli~airpto
          spfli~fltime

          scarr~carrname

          INTO CORRESPONDING FIELDS OF TABLE gt_flight
          FROM sflight
          INNER JOIN spfli
                      ON sflight~carrid = spfli~carrid
          INNER JOIN scarr
                      ON sflight~carrid = scarr~carrid

                      WHERE sflight~carrid  IN so_carid
                       AND  sflight~connid  IN so_conid
                       AND  sflight~fldate  IN so_date.

  IF sy-subrc = 0.
    MESSAGE s003(z_odev3_msg).
  ENDIF.





*  SELECT  sflight~carrid,
*          sflight~fldate,
*          sflight~connid,
*          sflight~fldate,
*          sflight~price,
*          sflight~currency,
*          sflight~paymentsum,
*          sflight~planetype,
*          spfli~countryfr,
*          spfli~cityfrom,
*          spfli~airpfrom,
*          spfli~countryto,
*          spfli~cityto,
*          spfli~airpto,
*          spfli~fltime,
*          scarr~carrname
*          FROM sflight
*          INNER JOIN spfli ON sflight~carrid = spfli~carrid
*          INNER JOIN scarr ON sflight~carrid = scarr~carrid
*          INTO TABLE @data(lt_Data)
*            WHERE sflight~carrid IN @so_carid
*             AND  sflight~connid IN @so_conid
*             AND  sflight~fldate IN @so_date.

* eksik patch var yeni kod tanımlaması

*Öenmli not
*into corresponding ile into table arasında performans farkı var
* into correspondibg select attığın alan adını gider tabloda tek tek
* search eder ve yavaşlar mesela sen en başta carrid çektin ama senin
* tablonda en son sırada ise tek tek bakar en son da bulur buda yavaşlar
* select sıran ile tablondaki alanların sırası aynı olacak ve into table
*olcak
ENDFORM.                    " GET_DATA


*&---------------------------------------------------------------------*
*&      Form  SET_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_layout .
  CLEAR ct_layout.
 "ct_layout-colwidth_optimize = 'X'.         " Optimization of Col width
  ct_layout-coltab_fieldname = 'CELLCOLOR'.  " Cell color Column Name
  ct_layout-info_fieldname   = 'LINE_COLOR'.
*  ct_layout-INFO_FNAME       = 'LINE_COLOR'.
  ct_layout-window_titlebar  = 'Tur Sirketi Odev'.
  ct_layout-box_fieldname    = 'SEL'.
  ct_layout-zebra            = 'X'.
* daha düzenli olur
ENDFORM.                    " SET_LAYOUT
*&---------------------------------------------------------------------*
*&      Form  ALV_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM alv_display .
* fonksiyon çağırınca kullanmadığın alanları sil kalabalık görünmesin.
* fonksiyon çağırınca exeption aç aksi taktirdehata alırsa dump alırsın.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
        i_callback_program       = sy-repid
        i_callback_pf_status_set = 'SET_PF_STATUS'
        i_callback_user_command  = 'SET_USER_COMMAND'
        is_layout                = ct_layout
        it_fieldcat              = ct_fcat[]
      TABLES
        t_outtab                 = gt_flight
     EXCEPTIONS
     program_error            = 1
     OTHERS                   = 2
      .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.                    " ALV_DISPLAY
*&---------------------------------------------------------------------*
*&      Form  SET_CATALOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_catalog .


  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
      EXPORTING
        i_program_name         = sy-repid
        i_internal_tabname     = 'GT_FLIGHT'
        i_inclname             = sy-repid
      CHANGING
        ct_fieldcat            = ct_fcat[]
      EXCEPTIONS
        inconsistent_interface = 1
        program_error          = 2
        OTHERS                 = 3.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

*catalog olustuktan sonra mgüdahale etmek için;

  LOOP AT ct_fcat INTO wa_fcat. "NOT Alanı Editliyoruz.

    "hangi alana müdahale etmek için bir if ihtiyacimiz var.
    CASE wa_fcat-fieldname.
      WHEN 'NOT'.
        wa_fcat-seltext_l = 'Tutulan Notlar'. "uzun adi
        wa_fcat-seltext_m = 'Notlar'. "orta adi
        wa_fcat-seltext_s = 'Not.'.     "kisa adi
        wa_fcat-row_pos   = 16.   "Sütün pozisizyonu
        wa_fcat-edit      = 'X'.   "Düzenlemeyi açıyoruz

    ENDCASE.
    MODIFY ct_fcat FROM wa_fcat.
    CLEAR wa_fcat.
  ENDLOOP.


ENDFORM.                    " SET_CATALOG


*&---------------------------------------------------------------------*
*&      SET_PF_STATUS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
"Perform Status Tamiliyoruz Menu Bardaki butonlarin etkilesimi icin
FORM set_pf_status USING p_extab TYPE slis_t_extab.
  "STATUS tanimlamada herhangi bir isimde verilebilir.
  SET PF-STATUS 'STANDARD'.
ENDFORM.

*&---------------------------------------------------------------------*
*&      SET_USER_COMMAND
*&---------------------------------------------------------------------*
* "USER Command icinde ayrica Perform tanimlamasi
*----------------------------------------------------------------------*

FORM set_user_command USING p_ucomm "Hangi butona bastigimizi ceker
                            p_selfield TYPE slis_selfield.

  DATA: gt_kayit TYPE zodev_1 OCCURS 0 WITH HEADER LINE,
        gs_kayit TYPE zodev_1
      .
  "cursor hangi parametre uzerinde ?

  CASE  p_ucomm.
    WHEN 'KAYDET'.
      PERFORM kaydet CHANGING p_selfield.

  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  KAYDET
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM kaydet CHANGING is_selfield TYPE slis_selfield.
  "DATA: lt_save_data TYPE TABLE OF zodev_1 WITH HEADER LINE.
  DATA: lt_save_data TYPE  zodev_1 OCCURS 0 WITH HEADER LINE.
*        lv_save_wa TYPE zodev_1.

  "böyle header line verirsen tabloyu aynı zamanda wa olarak
  "kullanabilrisn
  LOOP AT gt_flight WHERE sel = 'X'.

lt_save_data-MANDT = sy-mandt.
lt_save_data-KAYIT_TARIHI = sy-datum.
lt_save_data-KAYIT_SAATI = sy-uzeit.
lt_save_data-KAYDEDEN_KULLANICI = sy-uname.
lt_save_data-DEGISTIREN_TARIHI = sy-datum.
lt_save_data-DEGISTIREN_SAATI = sy-uzeit.
lt_save_data-DEGISTIREN_KULLANICI = sy-uname.
lt_save_data-CARRID = gt_flight-CARRID.
lt_save_data-CONNID = gt_flight-CONNID.
lt_save_data-FLDATE = gt_flight-FLDATE.
lt_save_data-PRICE = gt_flight-PRICE.
lt_save_data-CURRENCY = gt_flight-CURRENCY.
lt_save_data-PAYMENTSUM = gt_flight-PAYMENTSUM.
lt_save_data-PLANETYPE = gt_flight-PLANETYPE.
lt_save_data-COUNTRYFR = gt_flight-COUNTRYFR.
lt_save_data-CITYFROM = gt_flight-CITYFROM.
lt_save_data-AIRPFROM = gt_flight-AIRPFROM.
lt_save_data-COUNTRYTO = gt_flight-COUNTRYTO.
lt_save_data-CITYTO = gt_flight-CITYTO.
lt_save_data-AIRPTO = gt_flight-AIRPTO.
lt_save_data-FLTIME = gt_flight-FLTIME.
lt_save_data-NOTLAR = gt_flight-NOTLAR.
APPEND lt_save_data.
  ENDLOOP.
  IF lt_save_data[] IS NOT INITIAL.
    MODIFY zodev_1 FROM TABLE  lt_save_data.
        CLEAR: gt_flight,
            lt_save_data.
    IF sy-subrc = 0.
*      COMMIT WORK AND WAIT.
      COMMIT WORK.
      MESSAGE i001(z_odev3_msg).
    ENDIF.
    is_selfield-refresh = 'X'.
  ELSE.
    MESSAGE s002(z_odev3_msg) DISPLAY LIKE 'E'.
  ENDIF.
ENDFORM.                    " KAYDET
*&---------------------------------------------------------------------*
*&      Form  GUNCEL_VERI_GETIR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM guncel_veri_getir .
*****  "For ROW Colors
*****  Populate color variable with color properties
*****  Char 1 = C (This is color property)
*****  Char 2 = 3 (Color Codes : 1-7)
*****  Char 3 = Intensified Display on/off (1 or 0)
*****  Char 4 = Inverse display on/off (1 or 0)
*****  Example : wa_ekko-line_color = C410

* Color the Quantity cell where quantity is less than 5

  LOOP AT gt_flight WHERE fltime GT 500.
    gt_flight-line_color = 'C600'.
    MODIFY gt_flight.
    CLEAR gt_flight.
  ENDLOOP.

  PERFORM set_catalog.
  PERFORM alv_display.

ENDFORM.                    " GUNCEL_VERI_GETIR
*&---------------------------------------------------------------------*
*&      Form  SECIMLER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM secimler .
  PERFORM get_data.
  PERFORM get_data_ztable.
  CASE 'X'.
    WHEN p_gun.
      PERFORM guncel_veri_getir.

    WHEN p_log.
      PERFORM log_verisi_getir.

*      PERFORM set_catalog_ztable.
*      PERFORM alv_display_ztable.
    WHEN OTHERS.
  ENDCASE.
ENDFORM.                    " SECIMLER
*&---------------------------------------------------------------------*
*&      Form  LOG_VERISI_GETIR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM log_verisi_getir .


ENDFORM.                    " LOG_VERISI_GETIR
*&---------------------------------------------------------------------*
*&      Form  GET_DATA_ZTABLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data_ztable .

*  SELECT
*           mandt
*           kayit_tarihi
*           kayit_saati
*           kaydeden_kullanici
*           degistiren_tarihi
*           degistiren_saati
*           degistiren_kullanici
*           carrid
*           connid
*           fldate
*           price
*           currency
*           paymentsum
*           planetype
*           countryfr
*           cityfrom
*           airpfrom
*           countryto
*           cityto
*           airpto
*           fltime
*           notlar
*
*
*           INTO CORRESPONDING FIELDS OF TABLE gt_zflight
*            FROM  zodev_1
*                          WHERE      carrid IN so_carid  "sflight~
*                              and    connid IN so_conid
*                              and     fldate IN so_date.
*  IF sy-subrc = 0.
*    SORT gt_zflight BY kayit_tarihi.
*  ENDIF.
ENDFORM.                    " GET_DATA_ZTABLE
