FUNCTION-POOL ZSALV_CSQT_SCR_MANAGER.     "MESSAGE-ID ..

data: okcode type sy-ucomm.
data: gr_content_manager type ref to if_salv_csqt_content_manager.
data: g_title type string.
data: gr_container type ref to cl_gui_custom_container.

* INCLUDE LSALV_CSQT_SCREEN_MANAGERD...      " Local class definition
