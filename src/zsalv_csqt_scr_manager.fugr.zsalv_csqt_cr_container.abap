FUNCTION ZSALV_CSQT_CR_CONTAINER.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(R_CONTENT_MANAGER) TYPE REF TO
*"        IF_SALV_CSQT_CONTENT_MANAGER
*"     REFERENCE(TITLE) TYPE  STRING
*"----------------------------------------------------------------------
  gr_content_manager = r_content_manager.
  g_title = title.

  call screen 100.

endfunction.
