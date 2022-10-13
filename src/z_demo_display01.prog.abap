*&---------------------------------------------------------------------*
*& Report Z_DEMO_DISPLAY01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
*& "Test Display with SALV Framework
*& "Use different Options to modify Table
*&---------------------------------------------------------------------*
REPORT Z_DEMO_DISPLAY01.

CLASS lcl_event_handler DEFINITION.

  PUBLIC SECTION.
    METHODS : user_command_received FOR EVENT user_command_received OF zif_bc_alv_report_view
                           IMPORTING
                           ed_user_command
                           ed_row
                           ed_column.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_event_handler IMPLEMENTATION.

  METHOD user_command_received.
    "You can here read out User Comannd, Column and Row for extracting the Values
    MESSAGE |User Command: { ed_user_command }| TYPE 'W' DISPLAY LIKE 'I'.
  ENDMETHOD.

ENDCLASS.                    "lcl_event_handler DEFINITION

DATA:
title TYPE STRING value 'Demo Vorführung',
view TYPE REF TO zif_bc_alv_report_view,
event_handler TYPE REF TO lcl_event_handler.

INITIALIZATION.
event_handler = NEW #( ).
SET HANDLER event_handler->user_command_received FOR ALL INSTANCES.

view = NEW zcl_bc_view_salv_table( ).

**********************************************************************
START-OF-SELECTION.
**********************************************************************

SELECT * FROM sflight
INTO TABLE @DATA(flights)
UP TO 20 ROWS.

view->prepare_display_data(
  EXPORTING
    id_report_name        = sy-repid
*    id_variant            =
     id_title              = title
*    id_edit_control_field =
*    it_technicals         =
*    it_hidden              =
*    it_hotspots           = VALUE lvc_t_fnam( ( 'CARRID' )  )
    it_checkboxes         =  VALUE lvc_t_fnam( ( 'CARRID' )  )
*    it_editable_fields    =
*    it_subtotal_fields    =
*    it_field_texts        =
     is_layout             = VALUE #( no_toolbar = abap_true )
*    it_user_commands      =
*    if_start_in_edit_mode = ABAP_TRUE
    it_sort_criteria      = VALUE zty_bc_alv_sort_criterias( ( columname = 'FLDATE' descending = abap_false ) )
*    io_container          =
  CHANGING
    ct_data_table         = flights
).
