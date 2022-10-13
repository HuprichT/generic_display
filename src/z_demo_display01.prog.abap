*&---------------------------------------------------------------------*
*& Report Z_DEMO_DISPLAY01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
*& "Test Display with SALV Framework
*& "Use different Options to modify Table
*&---------------------------------------------------------------------*
REPORT Z_DEMO_DISPLAY01.

DATA:
title TYPE STRING value 'Demo Vorführung',
view TYPE REF TO zif_bc_alv_report_view.

INITIALIZATION.
view = NEW zcl_bc_view_salv_table( ).

**********************************************************************
START-OF-SELECTION.
**********************************************************************
BREAK-POINT.

SELECT * FROM sflight
INTO TABLE @DATA(flights)
UP TO 20 ROWS.

view->prepare_display_data(
  EXPORTING
    id_report_name        = sy-repid
*    id_variant            =
     id_title              = title
*    id_edit_control_field =
    it_technicals         = VALUE #( ( 'CARRID' )  )
    it_hidden             = VALUE #( ( 'CURRENCY' )  )
*    it_hotspots           =
*    it_checkboxes         =
*    it_editable_fields    =
*    it_subtotal_fields    =
*    it_field_texts        =
     is_layout             = VALUE #( no_toolbar = abap_true )
*    it_user_commands      =
*    if_start_in_edit_mode = ABAP_TRUE
*    it_sort_criteria      =
*    io_container          =
  CHANGING
    ct_data_table         = flights
).
