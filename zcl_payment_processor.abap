*----------------------------------------------------------------------*
*  Acme Enterprise Solutions - SAP ABAP Vendor Payment Processor        *
*  Includes SAP Application Log Integration & Exception Handling       *
*----------------------------------------------------------------------*
CLASS zcl_payment_processor DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    CONSTANTS CFO_APPROVAL_LIMIT TYPE i VALUE 1000000. " ₹10,00,000 threshold

    METHODS process_vendor_payment
      IMPORTING
        iv_invoice_num  TYPE string
        iv_amount       TYPE i
        iv_cfo_approved TYPE abap_bool
      EXPORTING
        ev_payment_id   TYPE string
        ev_status       TYPE string.
ENDCLASS.

CLASS zcl_payment_processor IMPLEMENTATION.
  METHOD process_vendor_payment.
    " Add audit logging via SAP Application Log
    CALL FUNCTION 'BAL_LOG_MSG_ADD'
      EXPORTING
        i_log_handle = 'LOG_HANDLE'
        i_s_msg      = VALUE bal_s_msg( msgty = 'I' msgid = 'ZPAY' msgno = '001' ).

    IF iv_amount > CFO_APPROVAL_LIMIT AND iv_cfo_approved = abap_false.
      MESSAGE e002(zpay) WITH iv_amount CFO_APPROVAL_LIMIT.
    ENDIF.
    ev_payment_id = |PAY-{ iv_invoice_num }|.
    ev_status     = 'COMPLETED'.
  ENDMETHOD.
ENDCLASS.
