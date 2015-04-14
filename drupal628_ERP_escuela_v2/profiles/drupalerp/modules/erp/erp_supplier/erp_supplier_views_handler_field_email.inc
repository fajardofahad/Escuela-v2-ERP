<?php

/**
 * @file
 * Handler for the supplier email field
 */

class erp_supplier_views_handler_field_email extends views_handler_field {
  function render( $values ) {
    return l($values->erp_supplier_email, 'mailto:'. $values->erp_supplier_email);
  }
}