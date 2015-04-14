<?php

/**
 * @file
 * Email handler to make the email from a customer field clickable
 */
class erp_customer_views_handler_field_email extends views_handler_field {
  function render( $values ) {
    return l($values->erp_customer_email, 'mailto:'. $values->erp_customer_email);
  }
}