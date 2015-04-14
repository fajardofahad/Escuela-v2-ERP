<?php

/**
 * @file
 * Currency field handler for views
 */

class erp_accounting_views_handler_field_currency extends views_handler_field {
  function render( $values ) {
    $value = $values->{$this->field_alias};
    return check_plain(erp_currency($value));
  }
}
