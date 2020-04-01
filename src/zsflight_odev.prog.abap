*&---------------------------------------------------------------------
*
*& Report  ZMELIH_ODEV_FLIGHT
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT zsflight_odev.

INCLUDE ZSFLIGHT_TOP.
*INCLUDE z_top.      "Structure - Tables - Select Options Tanımlamaları
INCLUDE ZSFLIGHT_EXECUTE.
*INCLUDE z_execute.  "İşlem Kodları

*include zmelih_odev_flight_top.

INITIALIZATION.

AT SELECTION-SCREEN.

  PERFORM at_selection_screen.

START-OF-SELECTION.
  PERFORM set_layout.
  PERFORM secimler.

END-OF-SELECTION.






*&---------------------------------------------------------------------*
*& - Melih EREN
*&
*&---------------------------------------------------------------------*
