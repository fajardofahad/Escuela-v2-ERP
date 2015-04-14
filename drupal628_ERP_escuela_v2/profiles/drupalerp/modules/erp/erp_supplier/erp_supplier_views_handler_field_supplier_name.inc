<?php

/**
 * @file
 * Handler for the supplier name field
 */

class erp_supplier_views_handler_field_supplier_name extends views_handler_field {
  function render( $values ) {
    return $values->node_title;
  }
}