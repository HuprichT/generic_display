class ZCL_VIEW_MOD_DATA definition
  public
  create public .

public section.
  METHODS: get_ms_layout RETURNING value(r_result) TYPE zsbc_alv_layout,
           set_ms_layout IMPORTING i_ms_layout TYPE zsbc_alv_layout,
           get_mt_technicals RETURNING value(r_result) TYPE lvc_t_fnam,
           set_mt_technicals IMPORTING i_mt_technicals TYPE lvc_t_fnam,
           get_mt_hidden RETURNING value(r_result) TYPE lvc_t_fnam,
           set_mt_hidden IMPORTING i_mt_hidden TYPE lvc_t_fnam,
           get_mt_hotspots RETURNING value(r_result) TYPE lvc_t_fnam,
           set_mt_hotspots IMPORTING i_mt_hotspots TYPE lvc_t_fnam,
           get_mt_checkboxes RETURNING value(r_result) TYPE lvc_t_fnam,
           set_mt_checkboxes IMPORTING i_mt_checkboxes TYPE lvc_t_fnam,
           get_mt_subtotals RETURNING value(r_result) TYPE lvc_t_fnam,
           set_mt_subtotals IMPORTING i_mt_subtotals TYPE lvc_t_fnam,
           get_mt_field_texts RETURNING value(r_result) TYPE zalv_texts,
           set_mt_field_texts IMPORTING i_mt_field_texts TYPE zalv_texts,
           get_mt_sort_criteria RETURNING value(r_result) TYPE zty_bc_alv_sort_criterias,
           set_mt_sort_criteria IMPORTING i_mt_sort_criteria TYPE zty_bc_alv_sort_criterias.
protected section.
DATA:
 "Data for modifying the View
       ms_LAYOUT type zsbc_alv_layout,
       mt_TECHNICALS type LVC_T_FNAM ,
       mt_HIDDEN type LVC_T_FNAM ,
       mt_HOTSPOTS type LVC_T_FNAM,
       mt_CHECKBOXES type LVC_T_FNAM,
       mt_SUBTOTALS type LVC_T_FNAM,
       mt_FIELD_TEXTS type zalv_texts,
       mt_SORT_CRITERIA type zty_bc_alv_sort_criterias.
private section.
ENDCLASS.

CLASS ZCL_VIEW_MOD_DATA IMPLEMENTATION.
  METHOD GET_MS_LAYOUT.
    R_RESULT = ME->MS_LAYOUT.
  ENDMETHOD.

  METHOD SET_MS_LAYOUT.
    ME->MS_LAYOUT = I_MS_LAYOUT.
  ENDMETHOD.

  METHOD GET_MT_TECHNICALS.
    R_RESULT = ME->MT_TECHNICALS.
  ENDMETHOD.

  METHOD SET_MT_TECHNICALS.
    ME->MT_TECHNICALS = I_MT_TECHNICALS.
  ENDMETHOD.

  METHOD GET_MT_HIDDEN.
    R_RESULT = ME->MT_HIDDEN.
  ENDMETHOD.

  METHOD SET_MT_HIDDEN.
    ME->MT_HIDDEN = I_MT_HIDDEN.
  ENDMETHOD.

  METHOD GET_MT_HOTSPOTS.
    R_RESULT = ME->MT_HOTSPOTS.
  ENDMETHOD.

  METHOD SET_MT_HOTSPOTS.
    ME->MT_HOTSPOTS = I_MT_HOTSPOTS.
  ENDMETHOD.

  METHOD GET_MT_CHECKBOXES.
    R_RESULT = ME->MT_CHECKBOXES.
  ENDMETHOD.

  METHOD SET_MT_CHECKBOXES.
    ME->MT_CHECKBOXES = I_MT_CHECKBOXES.
  ENDMETHOD.

  METHOD GET_MT_SUBTOTALS.
    R_RESULT = ME->MT_SUBTOTALS.
  ENDMETHOD.

  METHOD SET_MT_SUBTOTALS.
    ME->MT_SUBTOTALS = I_MT_SUBTOTALS.
  ENDMETHOD.

  METHOD GET_MT_FIELD_TEXTS.
    R_RESULT = ME->MT_FIELD_TEXTS.
  ENDMETHOD.

  METHOD SET_MT_FIELD_TEXTS.
    ME->MT_FIELD_TEXTS = I_MT_FIELD_TEXTS.
  ENDMETHOD.

  METHOD GET_MT_SORT_CRITERIA.
    R_RESULT = ME->MT_SORT_CRITERIA.
  ENDMETHOD.

  METHOD SET_MT_SORT_CRITERIA.
    ME->MT_SORT_CRITERIA = I_MT_SORT_CRITERIA.
  ENDMETHOD.

ENDCLASS.
