interface ZIF_BC_ALV_REPORT_VIEW
  public .

  events USER_COMMAND_RECEIVED
    exporting
      value(ED_USER_COMMAND) type SALV_DE_FUNCTION optional
      value(ED_ROW) type SALV_DE_ROW optional
      value(ED_COLUMN) type SALV_DE_COLUMN optional .

  methods PREPARE_DISPLAY_DATA
    importing
      !ID_REPORT_NAME like SY-REPID
      !ID_VARIANT type SLIS_VARI OPTIONAL
      ID_TITLE TYPE String OPTIONAL
      ID_EDIT_CONTROL_FIELD TYPE lvc_fname OPTIONAL
      !IT_TECHNICALS type lvc_t_fnam OPTIONAL
      !IT_HIDDEN type lvc_t_fnam OPTIONAL
      !IT_HOTSPOTS type lvc_t_fnam OPTIONAL
      !IT_CHECKBOXES type lvc_t_fnam OPTIONAL
      !IT_EDITABLE_FIELDS type lvc_t_fnam OPTIONAL
      !IT_SUBTOTAL_FIELDS type lvc_t_fnam OPTIONAL
      !IT_FIELD_TEXTS type ZTY_ALV_TEXTS OPTIONAL
      IS_LAYOUT TYPE lvc_s_layo OPTIONAL
      !IT_USER_COMMANDS type ttb_button OPTIONAL
      !IF_START_IN_EDIT_MODE type ABAP_BOOL default ABAP_TRUE
      !IT_SORT_CRITERIA type ZTY_BC_ALV_SORT_CRITERIAS optional
      !IO_CONTAINER type ref to CL_GUI_CONTAINER optional
    changing
      !CT_DATA_TABLE type TABLE .
    "! <p class="shorttext synchronized" lang="en"></p>
    "! <h1>Set the Attributes of a Field from a ALV Control Table</h1>
    "! <p>The Fieldname is mandatory. <br/>
    "! The Method automatically detects which attribute you like to change and modify it</p>
    "! @parameter ID_FIELD_NAME | ALV Control: Field name of internal table Field
    "! @parameter ID_TABLE_NAME | ALV Control: Reference Table Name for internal Table Field
    "! @parameter IF_IS_TECHNICAL | Is the Field for internal use only?
    "! @parameter if_is_visible | Is the Field hidden?
    "! @parameter if_is_a_checkbox | Is the Field a checkbox?
    "! @parameter if_is_a_button | Is the Field a push button?
    "! @parameter if_is_hotspot | Can you drill down?
    "! @parameter if_is_subtotal | Do we want a subtotal??
    "! @parameter id_short_text | Replace Short Text
    "! @parameter id_medium_text | Replace Medium Text
    "! @parameter id_long_text | Replace long text
    "! @parameter id_tooltip | ALV Control: Tool tip for column header
  methods SET_COLUMN_ATTRIBUTES
    importing
      !ID_FIELD_NAME type LVC_FNAME
      !IF_IS_TECHNICAL type ABAP_BOOL optional
      !IF_IS_VISIBLE type ABAP_BOOL optional
      !IF_IS_A_CHECKBOX type ABAP_BOOL optional
      !IF_IS_A_BUTTON type ABAP_BOOL optional
      !IF_IS_HOTSPOT type ABAP_BOOL optional
      !IF_IS_SUBTOTAL type ABAP_BOOL optional
      !ID_SHORT_TEXT type SCRTEXT_S optional
      !ID_MEDIUM_TEXT type SCRTEXT_M optional
      !ID_LONG_TEXT type SCRTEXT_L optional
      !ID_TOOLTIP type LVC_TIP optional
    raising
      CX_SALV_NOT_FOUND .
    "! <p class="shorttext synchronized" lang="en"></p>
    "!
    "! @parameter id_columnname | Name of the Column
    "! @parameter id_position | Determine Priority, 1 means first Position, 2 second and so on...
    "! @parameter if_descending | Mark wether the Column should be sorted descending, else ascending is default
    "! @parameter if_subtotal | Should the Change of a Value triggers Subtotal Calculation
    "! @parameter id_group | E.g. used for line or page breaks, check the provided constants of Data element
    "! @parameter if_obligatory |  Don't allow User to override this Sorting Criteria
  methods ADD_SORT_CRITERIA
    importing
      !ID_COLUMNNAME type LVC_FNAME
      !ID_POSITION type I optional
      !IF_DESCENDING type SAP_BOOL optional
      !IF_SUBTOTAL type SAP_BOOL default ABAP_FALSE
      !ID_GROUP type SALV_DE_SORT_GROUP default IF_SALV_C_SORT=>GROUP_NONE
      !IF_OBLIGATORY type SAP_BOOL default ABAP_FALSE .
  methods DISPLAY .
  methods REFRESH_DISPLAY.
  "! <p class="shorttext synchronized" lang="en"></p>
  "! <h1>Create Container implicit before executing regular Logic</h1>
  "! <p>With this Method it is possible to insert custom Icons and Action Tabs into SALV Table <br/>
  "! Originally, this is not possible with the CL_SALV_TABLE framework</p>
  "! @parameter ID_REPORT_NAME | <p class="shorttext synchronized" lang="en"></p>
  "! @parameter id_edit_control_field | <p class="shorttext synchronized" lang="en"></p>
  "! @parameter if_start_in_edit_mode | <p class="shorttext synchronized" lang="en"></p>
  "! @parameter is_layout | <p class="shorttext synchronized" lang="en"></p>
  "! @parameter IT_EDITABLE_FIELDS | <p class="shorttext synchronized" lang="en"></p>
  "! @parameter IT_TECHNICALS | <p class="shorttext synchronized" lang="en"></p>
  "! @parameter IT_HIDDEN | <p class="shorttext synchronized" lang="en"></p>
  "! @parameter IT_HOTSPOTS | <p class="shorttext synchronized" lang="en"></p>
  "! @parameter IT_CHECKBOXES | <p class="shorttext synchronized" lang="en"></p>
  "! @parameter IT_SUBTOTAL_FIELDS | <p class="shorttext synchronized" lang="en"></p>
  "! @parameter IT_FIELD_TEXTS | <p class="shorttext synchronized" lang="en"></p>
  "! @parameter IT_USER_COMMANDS | <p class="shorttext synchronized" lang="en"></p>
  "! @parameter IT_SORT_CRITERIA | <p class="shorttext synchronized" lang="en"></p>
  "! @parameter CT_DATA_TABLE | <p class="shorttext synchronized" lang="en"></p>
  methods CREATE_CONTAINER_PREP_DISPLAY
      importing
       ID_REPORT_NAME like SY-REPID
      ID_TITLE TYPE String OPTIONAL
      id_edit_control_field TYPE lvc_fname OPTIONAL
      if_start_in_edit_mode TYPE sap_bool DEFAULT ABAP_TRUE
      is_layout TYPE lvc_s_layo OPTIONAL
       IT_EDITABLE_FIELDS type lvc_t_fnam OPTIONAL
       IT_TECHNICALS type lvc_t_fnam OPTIONAL
       IT_HIDDEN type lvc_t_fnam OPTIONAL
       IT_HOTSPOTS type lvc_t_fnam OPTIONAL
       IT_CHECKBOXES type lvc_t_fnam OPTIONAL
       IT_SUBTOTAL_FIELDS type lvc_t_fnam OPTIONAL
       IT_FIELD_TEXTS type ZTY_ALV_TEXTS OPTIONAL
       IT_USER_COMMANDS type ttb_button OPTIONAL
      IT_SORT_CRITERIA type ZTY_BC_ALV_SORT_CRITERIAS optional
    changing
       CT_DATA_TABLE type TABLE .
  methods APPLICATION_SPECIFIC_CHANGES
    importing
       IS_LAYOUT type ZSBC_ALV_LAYOUT optional
       IT_TECHNICALS type LVC_T_FNAM optional
       IT_HIDDEN type LVC_T_FNAM optional
       IT_HOTSPOTS type LVC_T_FNAM optional
       IT_CHECKBOXES type LVC_T_FNAM optional
       IT_SUBTOTALS type LVC_T_FNAM optional
       IT_FIELD_TEXTS type ZTY_ALV_TEXTS optional
       IT_SORT_CRITERIA type ZTY_BC_ALV_SORT_CRITERIAS optional .
  methods SET_STRIPED_PATTERN .
  methods SET_NO_MERGING .
    "!
    "! @parameter ID_SELECTION_TYPE |
    "! SINGLE      Individual selection     1 <br/>
    "! MULTIPLE    Mult. Selection           2 <br/>
    "! CELL        Cell Selection            3 <br/>
    "! ROW_COLUMN  Line and Column Selection 4 <br/>
    "! NONE        No Selection              0 <br/>
    METHODS set_selections
        importing
      !ID_SELECTION_TYPE type I default 0 .
endinterface.
