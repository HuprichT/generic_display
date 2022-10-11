*----------------------------------------------------------------------*
***INCLUDE LSALV_CSQT_SCREEN_MANAGERO01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  D_0100_PBO  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module pbo output.
  perform pbo.
endmodule.

form pbo.

  set pf-status 'D0100'.

  if gr_container is initial.
    if cl_salv_table=>is_offline( ) eq if_salv_c_bool_sap=>false.
      create object gr_container
        exporting
          container_name = 'CONTAINER'.
    endif.

    set titlebar 'STANDARD' with g_title.

    gr_content_manager->fill_container_content(
        r_container = gr_container ).
  endif.

endform.


module pai input.
  perform pai.
endmodule.


form pai.

  data: l_okcode like sy-ucomm.

  l_okcode = okcode.
  clear okcode.

  case l_okcode.
    when 'EXIT' or 'CANC' or 'BACK'.
      call method gr_container->free.
      call method cl_gui_cfw=>flush.

      clear gr_container.

      set screen 0.
      leave screen.
  endcase.

endform.
