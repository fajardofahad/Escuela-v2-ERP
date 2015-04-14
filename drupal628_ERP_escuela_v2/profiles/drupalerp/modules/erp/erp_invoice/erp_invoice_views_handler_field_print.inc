<?php

/**
 * @file
 * Handler to make invoices easily printable from views
 */

class erp_invoice_views_handler_field_print extends views_handler_field_custom {
  function render( $values ) {
    return l('print', 'print/'. $values->nid);
  }
}