class ZCL_BC_VIEW_SALV_TABLE definition
  public
  create public .

  PUBLIC SECTION.
  INTERFACES: zif_bc_alv_report_view,
              if_salv_csqt_content_manager. "Used to respond to calls from FuBa
  ALIASES: set_column_attributes FOR zif_bc_alv_report_view~set_column_attributes,
           add_sort_criteria FOR zif_bc_alv_report_view~add_sort_criteria,
           display FOR zif_bc_alv_report_view~display,
           refresh_display FOR zif_bc_alv_report_view~refresh_display,
           create_container_prep_display FOR zif_bc_alv_report_view~create_container_prep_display,
           prepare_display_data FOR zif_bc_alv_report_view~PREPARE_DISPLAY_DATA,
           application_specific_changes FOR zif_bc_alv_report_view~application_specific_changes,
           set_striped_pattern FOR zif_bc_alv_report_view~set_striped_pattern,
           set_no_merging FOR zif_bc_alv_report_view~set_no_merging.
  DATA:
  mo_alv_grid TYPE REF TO cl_salv_table,
  mo_controller TYPE REF TO /zob/bc_controller.
  DATA:
  mo_aggregations TYPE REF TO cl_salv_aggregations,
  mo_column TYPE REF TO cl_salv_column_table,
  mo_columns TYPE REF TO cl_salv_columns_table,
  mo_events TYPE REF TO cl_salv_events_table,
  mo_functions TYPE REF TO cl_salv_functions,
  mo_layout TYPE REF TO cl_salv_layout,
  mo_selections TYPE REF TO cl_salv_selections,
  mo_sorts TYPE REF TO cl_salv_sorts,
  mo_settings TYPE REF TO cl_salv_display_settings.
  METHODS constructor.

  "! <p class="shorttext synchronized" lang="en"></p>
  "! <h1>Provide View with generic Functionality and Data</h1>
  "! <p>Configuring and initializing View Data which is the same for all Objects of this kind<br/>
  "! For Application specific Data please use other Methods</p>
  "! @parameter ID_REPORT_NAME | <p class="shorttext synchronized" lang="en"></p>
  "! @parameter ID_VARIANT | <p class="shorttext synchronized" lang="en"></p>
  "! @parameter IO_CONTAINER | <p class="shorttext synchronized" lang="en"></p>
  "! @parameter IT_USER_COMMANDS | <p class="shorttext synchronized" lang="en"></p>
  "! @parameter CT_DATA_TABLE | <p class="shorttext synchronized" lang="en"></p>
  methods INITIALIZE
  final
    importing
      !ID_REPORT_NAME type SY-REPID optional
      !ID_VARIANT type DISVARIANT-VARIANT optional
      !IO_CONTAINER type ref to CL_GUI_CONTAINER optional
      !IT_USER_COMMANDS type TTB_BUTTON optional
    changing
      !CT_DATA_TABLE type ANY TABLE .


  methods SET_HANDLERS .
PRIVATE SECTION.
  CONSTANTS:
  "! This User Command is set by System if the User has clicked on a cell of the ALV Table
  mc_user_command_click_on_cell TYPE salv_de_function VALUE '&IC1' ##NO_TEXT.

  METHODS set_list_header
    IMPORTING
      !i_is_layout_list_header TYPE ZSBC_ALV_LAYOUT-list_header .
  METHODS optimise_column_width .
  METHODS set_checkbox
    IMPORTING
      !i_fieldname TYPE lvc_fname
    RAISING
      cx_salv_not_found .
  METHODS set_hotspot
    IMPORTING
      !i_id_field_name TYPE lvc_fname .
  METHODS set_visible
    IMPORTING
      !id_field_name TYPE lvc_fname
      !if_is_visible TYPE abap_bool .
  METHODS set_tooltip
    IMPORTING
      !id_field_name TYPE lvc_fname
      !id_tooltip    TYPE lvc_tip
    RAISING
      cx_salv_not_found .
  METHODS set_short_text
    IMPORTING
      !id_field_name TYPE lvc_fname
      !id_short_text TYPE scrtext_s
      RAISING cx_salv_not_found.
  METHODS set_medium_text
    IMPORTING
      !id_field_name  TYPE lvc_fname
      !id_medium_text TYPE scrtext_m
      RAISING cx_salv_not_found.
  METHODS set_technical
    IMPORTING
      !i_id_field_name TYPE lvc_fname
    RAISING
      cx_salv_not_found .
  METHODS set_column_as_button
    IMPORTING
      !i_id_field_name TYPE lvc_fname
    RAISING
      cx_salv_not_found .
  "! <p class="shorttext synchronized" lang="en"></p>
  "! <p>If the Longtext is short enough, the Value will be applied to Long-, Medium- and Shortttext</p>
  "! @parameter id_field_name | <p class="shorttext synchronized" lang="en"></p>
  "! @parameter id_long_text | <p class="shorttext synchronized" lang="en"></p>
  "! @raising cx_salv_not_found | <p class="shorttext synchronized" lang="en"></p>
  METHODS set_long_text
    IMPORTING
      !id_field_name TYPE lvc_fname
      !id_long_text  TYPE scrtext_l
    RAISING
      cx_salv_not_found .
  METHODS set_subtotal
    IMPORTING
      !i_id_field_name TYPE lvc_fname .
  METHODS set_layout
    IMPORTING
       i_id_variant TYPE disvariant-variant .
  METHODS add_commands_to_toolbar
    IMPORTING
      i_it_user_commands TYPE ttb_button.
  METHODS display_basic_toolbar .
  METHODS handle_link_click
        FOR EVENT link_click OF cl_salv_events_table
    IMPORTING
        row
        column.
  METHODS handle_user_command
        FOR EVENT added_function OF cl_salv_events
    IMPORTING
        e_salv_function.

  DATA:
      md_report_name        TYPE sy-repid,
      md_edit_control_field TYPE lvc_fname,
      mf_start_in_edit_mode TYPE sap_bool,
      ms_layout             TYPE lvc_s_layo,
      mt_data_table         TYPE REF TO data,
      mt_editable_fields    TYPE lvc_t_fnam,
      mt_technicals         LIKE mt_editable_fields,
      mt_hidden             LIKE mt_editable_fields,
      mt_hotspots           LIKE mt_editable_fields,
      mt_checkboxes         LIKE mt_editable_fields,
      mt_subtotal_fields    LIKE mt_editable_fields,
      mt_sort_criteria      TYPE /ZOB/TY_BC_ALV_SORT_CRITERIAS,
      mt_field_texts        TYPE /zob/ty_bc_alv_texts,
      mt_user_commands      TYPE ttb_button,
      ms_variant            TYPE disvariant.
ENDCLASS.



CLASS ZCL_BC_VIEW_SALV_TABLE IMPLEMENTATION.

  METHOD CONSTRUCTOR.

    CREATE OBJECT MO_SETTINGS.

  ENDMETHOD.


  METHOD zif_bc_alv_report_view~add_sort_criteria.
    DATA:
      sort_sequence TYPE salv_de_sort_sequence.

    IF if_descending = abap_true.
      sort_sequence = if_salv_c_sort=>sort_down.
    ELSE.
      sort_sequence = if_salv_c_sort=>sort_up.
    ENDIF.

    mo_sorts = mo_alv_grid->get_sorts( ).
    mo_sorts->add_sort(
      columnname = id_columnname
      position = id_position
      sequence = sort_sequence
      subtotal = if_subtotal
      group = id_group
      obligatory = if_obligatory ).
    "… same error handling as in SET_SUBTOTALS …

  ENDMETHOD.


  METHOD zif_bc_alv_report_view~display.

  mo_alv_grid->display( ).

  ENDMETHOD.


  METHOD zif_bc_alv_report_view~prepare_display_data.
    initialize(
      EXPORTING
        id_report_name        = id_report_name
        id_variant            = id_variant
        "if_start_in_edit_mode = if_start_in_edit_mode
        "id_edit_control_field = ''
        "it_editable_fields    = it_editable_fields
        io_container          = io_container
        it_user_commands      = it_user_commands
      CHANGING
        ct_data_table         = ct_data_table
    ).

    application_specific_changes(
      EXPORTING
        it_technicals  = it_technicals
        it_hidden      = it_hidden
        it_hotspots    = it_hotspots
        it_checkboxes  = it_checkboxes
        it_subtotals   = it_subtotal_fields
        it_field_texts = it_field_texts
        it_sort_criteria = it_sort_criteria
    ).

    display( ).
  ENDMETHOD.


  METHOD zif_bc_alv_report_view~set_column_attributes.
* Preconditions
    CHECK id_field_name IS NOT INITIAL.

    IF if_is_a_checkbox = abap_true.
      set_checkbox( id_field_name ).
      set_hotspot( id_field_name ).
    ENDIF.

    IF if_is_hotspot = abap_true.
      set_hotspot( id_field_name ).
    ENDIF.

    IF if_is_visible IS SUPPLIED.
      set_visible( id_field_name = id_field_name
      if_is_visible = if_is_visible ).
    ENDIF.

    IF if_is_technical = abap_true.
      set_technical( id_field_name ).
    ENDIF.

    IF if_is_a_button = abap_true.
      set_column_as_button( id_field_name ).
    ENDIF.

    IF if_is_subtotal = abap_true.
      set_subtotal( id_field_name ).
    ENDIF.

    IF id_long_text IS NOT INITIAL.
      set_long_text( id_field_name = id_field_name
      id_long_text = id_long_text ).
    ENDIF.

    IF id_medium_text IS NOT INITIAL.
      set_medium_text( id_field_name = id_field_name
      id_medium_text = id_medium_text ).
    ENDIF.

    IF id_short_text IS NOT INITIAL.
      set_short_text( id_field_name = id_field_name
      id_short_text = id_short_text ).
    ENDIF.

    IF id_tooltip IS NOT INITIAL.
      set_tooltip( id_field_name = id_field_name
      id_tooltip = id_tooltip ).
    ENDIF.

  ENDMETHOD.


  METHOD zif_bc_alv_report_view~application_specific_changes.
**************************************************************
* The model’s job is to say what fields can be drilled into
* and what alternative names they have etc...
* The job of the view is to realise this technically
* This is CL_SALV_TABLE so we cannot make fields editable here
* but we can do all the other adjustments needed
**************************************************************
    FIELD-SYMBOLS:
      <fieldname>      TYPE lvc_fname,
      <alv_txt_fields> TYPE /zob/bc_alv_texts,
      <sort_crit>      TYPE /zob/bc_alv_sort_criteria.
    TRY.
        "Layout related Settings
        set_list_header( is_layout-list_header ).
        set_layout( is_layout-variant ).

        IF is_layout-colwidth_optimize = abap_true.
          optimise_column_width( ).
        ENDIF.

        IF is_layout-striped_pattern = abap_true.
          set_striped_pattern( ).
        ENDIF.

        IF is_layout-no_cell_mergin = abap_true.
          set_no_merging( ).
        ENDIF.

        "Technical Fields
        LOOP AT it_technicals ASSIGNING <fieldname>.

          set_column_attributes(
          id_field_name = <fieldname>
          if_is_technical = abap_true
          ).
        ENDLOOP.

          "Hidden Fields
          LOOP AT it_hidden ASSIGNING <fieldname>.
            set_column_attributes(
              EXPORTING
                id_field_name   = <fieldname>
                if_is_visible = abap_true
            ).
          ENDLOOP.

          "Hotspots
          LOOP AT it_hotspots ASSIGNING <fieldname>.
            set_column_attributes(
              EXPORTING
                id_field_name   = <fieldname>
                if_is_hotspot = abap_true
            ).
          ENDLOOP.

          "Renamed Fields/Tooltips
          LOOP AT it_field_texts ASSIGNING <alv_txt_fields>.
            IF <alv_txt_fields>-tooltip IS NOT INITIAL.
              set_column_attributes( id_field_name = <alv_txt_fields>-field_name
              id_tooltip = <alv_txt_fields>-tooltip ).
            ENDIF.
            IF <alv_txt_fields>-long_text IS NOT INITIAL.
              set_column_attributes( id_field_name = <alv_txt_fields>-field_name
              id_long_text = <alv_txt_fields>-long_text ).
            ENDIF.
            IF <alv_txt_fields>-medium_text IS NOT INITIAL.
              set_column_attributes( id_field_name = <alv_txt_fields>-field_name
              id_medium_text = <alv_txt_fields>-medium_text ).
            ENDIF.
            IF <alv_txt_fields>-short_text IS NOT INITIAL.
              set_column_attributes( id_field_name = <alv_txt_fields>-field_name
              id_short_text = <alv_txt_fields>-short_text ).
            ENDIF.
          ENDLOOP.
* Checkboxes
          LOOP AT it_checkboxes ASSIGNING <fieldname>.
            set_checkbox( <fieldname> ).
          ENDLOOP.
* Subtotals
          LOOP AT it_subtotals ASSIGNING <fieldname>.
            set_column_attributes( id_field_name = <fieldname>
                                    if_is_subtotal = abap_true ).
          ENDLOOP.

*Sort Criteria
        LOOP AT it_sort_criteria ASSIGNING <sort_crit>.
          add_sort_criteria(
          EXPORTING
              id_columnname = <sort_crit>-columname
              id_position = CONV #( <sort_crit>-position )
              if_descending = <sort_crit>-descending
              if_subtotal = <sort_crit>-subtotal
              id_group = <sort_crit>-group
              if_obligatory = <sort_crit>-obligatory ).
        ENDLOOP.

      CATCH cx_salv_not_found INTO DATA(not_found_exception).
        DATA(an_error_occurred) = abap_true.
        "Object = Column
        "Key = Field Name e.g. VBELN
*        zcl_dbc=>require(
*        that = |{ not_found_exception->object } { not_found_exception->key } must exist|
*        which_is_true_if = boolc( an_error_occurred = abap_false ) ).
        MESSAGE not_found_exception->get_text( ) TYPE 'E'.
      CATCH cx_salv_data_error INTO DATA(data_error_exception).
        DATA(error_information) = data_error_exception->get_message( ).
        MESSAGE ID error_information-msgid TYPE 'E' NUMBER error_information-msgno
        WITH error_information-msgv1 error_information-msgv2
        error_information-msgv3 error_information-msgv4.
      CATCH cx_salv_msg INTO DATA(generic_salv_exception).
        error_information = generic_salv_exception->get_message( ).
        MESSAGE ID error_information-msgid TYPE 'E' NUMBER error_information-msgno
        WITH error_information-msgv1 error_information-msgv2
        error_information-msgv3 error_information-msgv4.
    ENDTRY.
  ENDMETHOD.


  METHOD display_basic_toolbar.

    mo_functions = mo_alv_grid->get_functions( ).
    mo_functions->set_all( value = if_salv_c_bool_sap=>true ).

  ENDMETHOD.


  method handle_link_click.
    RAISE EVENT zif_bc_alv_report_view~user_command_received
        EXPORTING
            ed_user_command = mc_user_command_click_on_cell
            ed_row = row
            ed_column = column.
  endmethod.


  method HANDLE_USER_COMMAND.
  RAISE EVENT zif_bc_alv_report_view~user_command_received
    EXPORTING ed_user_command = e_salv_function.
  endmethod.


 METHOD initialize.
*------------------------------------------------------------*
* If we have a container, then we can add our own user-defined
* commands programatically
*------------------------------------------------------------*+
DATA: custom_commands_provided TYPE sap_bool.

   IF io_container IS SUPPLIED AND io_container IS BOUND.
     IF it_user_commands[] IS NOT INITIAL.
        custom_commands_provided = abap_true.
     ENDIF.
     TRY.
     cl_salv_table=>factory(
     EXPORTING
        r_container = io_container
     IMPORTING
        r_salv_table = mo_alv_grid
     CHANGING
        t_table = ct_data_table[] ).
     CATCH cx_salv_msg.    "
       "There is a serious bug in the Programm -> Terminate
       RETURN.
     ENDTRY.
   ELSE.
   TRY.
       cl_salv_table=>factory(
         IMPORTING
           r_salv_table   = mo_alv_grid " Basis Class Simple ALV Tables
         CHANGING
           t_table        = ct_data_table
       ).
     CATCH cx_salv_msg.    "
       "There is a serious bug in the Programm -> Terminate
       RETURN.
   ENDTRY.
   ENDIF.

set_handlers( ).
 display_basic_toolbar( ).
 mo_columns = mo_alv_grid->get_columns( ).

 set_layout( id_variant ).
  IF custom_commands_provided = abap_true.  "Only shown if method is called from container_prep_display
    add_commands_to_toolbar( it_user_commands ).
  ENDIF.
 ENDMETHOD.


  METHOD optimise_column_width.

    mo_columns->set_optimize( ).

  ENDMETHOD.


  METHOD set_checkbox.

    mo_column ?= mo_columns->get_column( i_fieldname ).
    mo_column->set_cell_type( if_salv_c_cell_type=>checkbox_hotspot ).

  ENDMETHOD.


  METHOD set_column_as_button.

TRY.
mo_column ?= mo_columns->get_column(  i_id_field_name  ).
mo_column->set_icon( if_salv_c_bool_sap=>true ).
ENDTRY.
  ENDMETHOD.


  METHOD set_handlers.
    mo_events = mo_alv_grid->get_event( ).

    SET HANDLER handle_link_click FOR mo_events.
    SET HANDLER handle_user_command FOR mo_events.
   " SET HANDLER handle_user_command FOR ALL INSTANCES.
  ENDMETHOD.


  METHOD set_hotspot.

  ENDMETHOD.


  METHOD set_layout.
    "Local variables
    DATA: layout_key_information TYPE salv_s_layout_key.

    mo_layout = mo_alv_grid->get_layout( ).

    "Set the Layout Key
    layout_key_information-report = sy-cprog.

    mo_layout->set_key( layout_key_information ).

    "Set usage of default Layouts
    mo_layout->set_default( 'X' ).

    "Set initial layout
    IF i_id_variant IS NOT INITIAL.
      mo_layout->set_initial_layout( i_id_variant ).
    ENDIF.

    "Set save restrictions
    "Here you would check if a Custom Auth Obj if user is allowed to save global Variants

    mo_layout->set_save_restriction( if_salv_c_layout=>restrict_user_dependant ).

  ENDMETHOD.


  METHOD set_list_header.

  ENDMETHOD.


  METHOD set_long_text.
    DATA: lv_longtext TYPE c LENGTH 40.
    lv_longtext = id_long_text.

    IF mo_column IS NOT BOUND.
      mo_columns = mo_alv_grid->get_columns( ).
    ENDIF.

    TRY.
        mo_column ?= mo_columns->get_column( id_field_name ).
        mo_column->set_long_text( lv_longtext ).
        IF strlen( id_long_text ) LE 20.
          mo_column->set_medium_text( CONV #( id_long_text ) ).
        ENDIF.
        IF strlen( id_long_text ) LE 10.
          mo_column->set_short_text( CONV #( id_long_text ) ).
        ENDIF.
        "… same error handling as usual ….
    ENDTRY.
  ENDMETHOD.


  METHOD set_medium_text.

    IF mo_column IS NOT BOUND.
      mo_columns = mo_alv_grid->get_columns( ).
    ENDIF.

    TRY.
        mo_column ?= mo_columns->get_column( id_field_name ).
        mo_column->set_medium_text( id_medium_text ).
    ENDTRY.
  ENDMETHOD.


  METHOD zif_bc_alv_report_view~set_no_merging.
*--------------------------------------------------------------------*
* The default behaviour for any ALV grid is to merge cells which
* have the same value with the cells immediately below them, e.g.
* if every cell in a column had the same value, you would just see
* one great big, very tall, cell
* Sometimes you want to switch that setting off, so every value lives
* inside it's own cell
*--------------------------------------------------------------------*
  mo_settings = mo_alv_grid->get_display_settings( ).

  mo_settings->set_no_merging( abap_true ).
  ENDMETHOD.


  METHOD set_short_text.
    IF mo_column IS NOT BOUND.
      mo_columns = mo_alv_grid->get_columns( ).
    ENDIF.

    TRY.
        mo_column ?= mo_columns->get_column( id_field_name ).
        mo_column->set_short_text( id_short_text ).
    ENDTRY.
  ENDMETHOD.


  METHOD zif_bc_alv_report_view~set_striped_pattern.

    IF mo_settings IS NOT BOUND.
      mo_settings = mo_alv_grid->get_display_settings( ).
    ENDIF.

    mo_settings->set_striped_pattern( abap_true ).

  ENDMETHOD.


  METHOD set_subtotal.
    TRY.
        mo_aggregations->add_aggregation( columnname =  i_id_field_name  ).
      CATCH cx_salv_not_found INTO DATA(not_found).

      CATCH cx_salv_data_error INTO DATA(salv_data_error).

      CATCH cx_salv_existing INTO DATA(duplicate_error).

        DATA(error_message) = duplicate_error->get_text( ).

        MESSAGE 'Fehler' TYPE 'E'.
    ENDTRY.
  ENDMETHOD.


  METHOD set_technical.

    mo_column ?= mo_columns->get_column( i_id_field_name ).
    mo_column->set_technical( abap_true ).
    "… usual error handling ….

  ENDMETHOD.


  METHOD set_tooltip.

    mo_column ?= mo_columns->get_column( columnname = id_field_name ).
    mo_column->set_tooltip( value = id_tooltip ).

  ENDMETHOD.


  METHOD set_visible.
    TRY.
    mo_column ?= mo_columns->get_column( id_field_name ).
    mo_column->set_visible( if_is_visible ).
    "… usual error handling ….
    CATCH cx_salv_not_found.
    ENDTRY.
  ENDMETHOD.
  METHOD zif_bc_alv_report_view~refresh_display.
* Local Variables
DATA: stable_refresh_info TYPE lvc_s_stbl.
    "I am going to be mad and suggest that when a user refreshes
    "the display as data has changed, they want the cursor to stay
    "where it is and not jump six pages up to the start of the
    "report, which is the default behavior
    stable_refresh_info-row = abap_true.
    stable_refresh_info-col = abap_true.
    mo_alv_grid->refresh( s_stable = stable_refresh_info ).
  ENDMETHOD.

  METHOD zif_bc_alv_report_view~create_container_prep_display.

    md_report_name = id_report_name.
    md_edit_control_field = id_edit_control_field.
    mf_start_in_edit_mode = if_start_in_edit_mode.
    ms_layout = is_layout.
    mt_editable_fields[] = it_editable_fields[].
    mt_technicals[] = it_technicals[].
    mt_hidden[] = it_hidden[].
    mt_hotspots[] = it_hotspots[].
    mt_checkboxes[] = it_checkboxes[].
    mt_subtotal_fields[] = it_subtotal_fields[].
    mt_field_texts[] = it_field_texts[].
    mt_sort_criteria[] = it_sort_criteria[].
    mt_user_commands[] = it_user_commands[].
    ms_variant-report = id_report_name.

    CREATE DATA mt_data_table LIKE ct_data_table.
    GET REFERENCE OF ct_data_table INTO mt_data_table.

    CALL FUNCTION 'ZSALV_CSQT_CR_CONTAINER'
      EXPORTING
        r_content_manager = me
        title             = id_title.
  ENDMETHOD.

  METHOD IF_SALV_CSQT_CONTENT_MANAGER~FILL_CONTAINER_CONTENT.
*------------------------------------------------------------*
*This is called from function /ZOB/SALV_CSQT_CR_CONTAINER PBO
*module, which creates a screen and a container, and passes us
*that container in the form of importing parameter R_CONTAINER
* /ZOB/SALV_CSQT_CR_CONTAINER is copied from SALV_CSQT_CREATE_CONTAINER
*------------------------------------------------------------*
* Local variables
FIELD-SYMBOLS: <lt_data_table> TYPE ANY TABLE.
ASSIGN mt_data_table->* TO <lt_data_table>.

zif_bc_alv_report_view~prepare_display_data(
EXPORTING
id_report_name = md_report_name
if_start_in_edit_mode = mf_start_in_edit_mode
id_edit_control_field = md_edit_control_field
is_layout = ms_layout
it_editable_fields = mt_editable_fields
it_technicals = mt_technicals
it_hidden = mt_hidden
it_hotspots = mt_hotspots
it_checkboxes = mt_checkboxes
it_subtotal_fields = mt_subtotal_fields
it_sort_criteria = mt_sort_criteria
it_field_texts = mt_field_texts
io_container = r_container
it_user_commands = mt_user_commands
CHANGING
ct_data_table = <lt_data_table> ).
  ENDMETHOD.


  METHOD add_commands_to_toolbar.
    DATA: command_info TYPE stb_button  .
    TRY.
        LOOP AT i_it_user_commands INTO command_info.
          CHECK command_info-function <> mc_user_command_click_on_cell.
          mo_functions->add_function(
          name = command_info-function
          icon = CONV #( command_info-icon )
          text = CONV #( command_info-text )
          tooltip = CONV #( command_info-quickinfo )
          position = if_salv_c_function_position=>right_of_salv_functions ).
        ENDLOOP.
        "These two standard SAP exception classes are identical as far as I can see
      CATCH cx_salv_wrong_call INTO DATA(wrong_call).
        DATA(error_message) = wrong_call->get_text( ).
        "Object: &OBJECT&; name: &KEY& already exists (class: &CLASS&; method: &METHOD&)
        MESSAGE error_message TYPE 'E'.
      CATCH cx_salv_existing INTO DATA(duplicate_error).
        error_message = duplicate_error->get_text( ).
        "Object: &OBJECT&; name: &KEY& already exists (class: &CLASS&; method: &METHOD&)
        MESSAGE error_message TYPE 'E'.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
