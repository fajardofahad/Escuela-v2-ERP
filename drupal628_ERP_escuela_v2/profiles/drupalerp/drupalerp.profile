<?php
// $Id: drupalerp.profile,v 1.1.2.5 2010/02/27 10:25:47 simon Exp $

/**
 * Return a description of the profile for the initial installation screen.
 *
 * @return
 *   An array with keys 'name' and 'description' describing this profile.
 */
function drupalerp_profile_details() {
  return array(
    'name' => 'Drupal ERP',
    'description' => 'This installation profile will setup Drupal as a basic ERP system.'
  );
}

/**
 * Return an array of the modules to be enabled when this profile is installed.
 *
 * @return
 *  An array of modules to be enabled.
 */
function drupalerp_profile_modules() {
  return array(
    // Core drupal modules
    'comment', 'help', 'menu', 'taxonomy', 'book', 'search', 'upload', 'dblog',

    // Installation helpers
    'install_profile_api',
  
    // Other contrib modules we use
    'ctools', 'autologout', 'admin_menu', 'advanced_help', 'calendar', 'context', 'context_ui', 'countdowntimer', 'date_api', 'date_popup', 'date_timezone', 'dirtyforms', 'gmap', 'nice_menus', 'onbeforeunload', 'print', 'print_mail', 'print_pdf', 'quicktabs', 'token', 'views', 'views_ui', 'workflow',

    // Now the erp modules - core
    'erp', 'erp_cart', 'erp_store',

    // Accounting/sales
    'erp_accounting', 'erp_tax', 'erp_stock', 'erp_quote', 'erp_cash_sale',
    'erp_invoice', 'erp_purchase_order', 'erp_item',
    'erp_goods_receive', 'erp_payment', 'erp_supplier',
    'erp_recurring', 'erp_pricing',

    // Customer
    'erp_contact', 'erp_customer',

    // Job modules
    'erp_job',

    // Auxillary utilities
    'erp_franchise', 'erp_google_maps', 'erp_email', 'erp_formfixes', 'erp_price_list_update', 'erp_reports'
  );
}

function drupalerp_profile_task_list() {
	return array(
	  'erpconfig' => st('ERP Configuration'),
	);
}

function drupalerp_profile_tasks(&$task, $url) {
	install_include(drupalerp_profile_modules());
  _drupalerp_profile_std_setup();
  _drupalerp_profile_baseconfig_setup();

  // Ensure no confusing drupal core stuff is displayed
  $task = 'done';
  
  drupal_set_title(st('@drupal installation complete', array('@drupal' => drupal_install_profile_name())));
  $output = '<p>'. st('Congratulations, @drupal has been successfully installed.', array('@drupal' => drupal_install_profile_name())) .'</p>';
  $output .= '<p>'. erp_initial_setup_check() .'</p>';
  
  return $output;
}

/**
 * Perform erp specific installation tasks for this profile.
 *
 * @return
 *   An optional HTML string to display to the user on the final installation
 *   screen.
 */
function _drupalerp_profile_std_setup() {
  // Default page to not be promoted and have comments disabled.
  variable_set('node_options_page', array('status'));
  variable_set('comment_page', COMMENT_NODE_DISABLED);

  // Don't display date and author information for page nodes by default.
  $theme_settings = variable_get('theme_settings', array());
  $theme_settings['toggle_node_info_page'] = FALSE;

  variable_set('theme_settings', $theme_settings);

  // Make an administrator role
  $admin_role = install_add_role('administrator');
  install_add_user_to_role(1, $admin_role);
  install_add_permissions($admin_role, array(
    'administer blocks', 'create book pages', 'create new books', 'edit book pages', 'edit own book pages', 'outline posts in books',
    'see printer-friendly version', 'access comments', 'administer comments', 'post comments', 'post comments without approval', 
    'access erp', 'admin erp', 'erp quick find block', 'admin erp accounting', 'view erp accounting', 'access erp cart', 'admin erp cart',
    'add cash_sale', 'admin cash_sale', 'edit cash_sale', 'edit own cash_sale', 'erp contact edit', 'erp contact list', 'erp contact remove',
    'erp contact save', 'admin customers', 'autocomplete customers', 'create customer', 'customer quick find block', 'edit all customers', 
    'edit customer', 'edit own customer', 'list customers', 'admin erp_email', 'send email', 'admin franchise', 'add goods_receipt', 'admin goods_receive',
    'edit goods_receipt', 'edit own goods_receipt', 'admin google_maps', 'view erp google map', 'add invoice', 'admin invoice', 'edit invoice', 
    'edit own invoice', 'view statements', 'admin item', 'item cart', 'item edit', 'item list', 'item price list', 'item wholesale', 'add job',
    'admin job', 'edit all jobs', 'edit job', 'edit own job', 'job list', 'open jobs', 'admin payment', 'edit payment', 'list payments', 'receive payment',
    'admin pricing', 'view pricing levels', 'erp print', 'add purchase_order', 'admin purchase_order', 'edit own purchase_order', 'edit purchase_order',
    'add quote', 'admin quote', 'edit own quote', 'edit quote', 'admin stock', 'stock adjust', 'stock cart', 'stock edit', 'stock list', 'stock wholesale',
    'admin store', 'create store', 'edit all stores', 'edit own store', 'edit store', 'store list', 'admin supplier', 'create supplier', 'edit supplier',
    'supplier autocomplete', 'supplier list', 'access erp tax', 'admin erp tax', 'create timesheet', 'edit timesheet', 'list timesheets', 'administer filters',
    'administer menu', 'access content', 'administer content types', 'administer nodes', 'revert revisions', 'view revisions', 'administer organic groups',
    'create pdf', 'administer search', 'search content', 'use advanced search', 'access administration pages', 'administer site configuration',
    'select different theme', 'administer taxonomy', 'upload files', 'view uploaded files', 'access user profiles', 'administer access control',
    'administer users', 'change own username', 'access all views', 'administer views', 'administer workflow', 'schedule workflow transitions')
  );

  // Make a staff role
  $staff_role = install_add_role('staff');
  install_add_user_to_role(1, $staff_role);
  install_add_permissions($staff_role, array(
    'create book pages', 'edit book pages', 'edit own book pages', 'see printer-friendly version', 'access comments', 'post comments', 
    'post comments without approval', 'access erp', 'erp quick find block', 'view erp accounting', 'access erp cart', 'add cash_sale', 
    'edit cash_sale', 'edit own cash_sale', 'erp contact edit', 'erp contact list', 'erp contact remove', 'erp contact save', 'autocomplete customers', 
    'create customer', 'customer quick find block', 'edit all customers', 'edit customer', 'edit own customer', 'list customers', 'send email', 
    'add goods_receipt', 'edit goods_receipt', 'edit own goods_receipt', 'view erp google map', 'add invoice', 'edit invoice', 'edit own invoice', 
    'view statements', 'item cart', 'item edit', 'item list', 'item price list', 'item wholesale', 'add job', 'edit all jobs', 'edit job', 
    'edit own job', 'job list', 'open jobs', 'edit payment', 'list payments', 'receive payment', 'view pricing levels', 'erp print', 'add purchase_order', 
    'edit own purchase_order', 'edit purchase_order', 'add quote', 'edit own quote', 'edit quote', 'stock adjust', 'stock cart', 'stock edit', 
    'stock list', 'stock wholesale', 'create store', 'edit all stores', 'edit own store', 'edit store', 'store list', 'create supplier', 
    'edit supplier', 'supplier autocomplete', 'supplier list', 'access erp tax', 'create timesheet', 'edit timesheet', 'list timesheets', 
    'access content', 'create pdf', 'search content', 'use advanced search', 'upload files', 'access user profiles')
  );

  // Set some drupal defaults
  variable_set('site_frontpage', 'erp/jobs/my');
  variable_set('erp_accounting_currency_format', '%-12.2f');
  variable_set('erp_default_email_format', 2);
  
  // Turn off all "promoting", drupal things first
  $types = array('book', 'story', 'page',
                 // Now erp things
                 'erp_cash_sale', 'erp_customer', 'erp_goods_receive', 'erp_invoice', 'erp_item',
                 'erp_job', 'erp_payment', 'erp_purchase_order', 'erp_quote', 'erp_store',
                 'erp_supplier', 'erp_timesheet');

  foreach ($types as $type) {
    variable_set('node_options_'. $type, array('status'));
  }

  menu_rebuild();
  _block_rehash();
}


/**
 * Setup specific standard/common parts of erp
 *
 */
function _drupalerp_profile_baseconfig_setup() {
  module_load_include('inc', 'node', 'node.pages');

  // Provide default values for the install profile for use with Aegir
  $values['erp_store_name'] = t('ERP Store');
  $values['erp_store_street_address'] = t('ERP Store Address');
  $values['erp_store_suburb'] = t('ERP Suburb');
  $values['erp_store_state'] = t('ERP State');
  $values['erp_store_postcode'] = t('0000');
  $values['erp_store_phone'] = t('6-5000');
  
  drupal_get_schema(NULL, TRUE);

  // Create taxonomies
  install_taxonomy_add_vocabulary('Manufacturers', array('erp_item' => 'erp_item'), array('tags' => 1));
  install_taxonomy_add_vocabulary('Category', array('erp_item' => 'erp_item'), array('tags' => 1));  
  
  $default_user = db_result(db_query("SELECT name FROM {users} WHERE uid = 1"));

  // Create default customer book, default supplier book, default store book
  $node = array();
  $node['type'] = 'book'; // node type

  $form_state = array();
  $form_state['values']['title'] = t('Customer Documentation'); // node title
  $form_state['values']['body'] = t('This book is used to contain all customer documentation'); // node body
  $form_state['values']['taxonomy'] = array('tags' => array('1' => ('Customer Documentation')));
  $form_state['values']['name'] = $default_user;
  $form_state['values']['book']['bid'] = "new"; // Create new book

  $form_state['values']['op'] = t('Save'); // required
  drupal_execute('book_node_form', $form_state, (object)$node);

  variable_set('erp_customer_doc_book', $form_state['nid']);
  variable_get('erp_customer_doc_parent', $form_state['nid']);

  $node = array();
  $node['type'] = 'book'; // node type

  $form_state = array();
  $form_state['values']['title'] = t('Supplier Documentation'); // node title
  $form_state['values']['body'] = t('This book is used to contain all supplier documentation'); // node body
  $form_state['values']['taxonomy'] = array('tags' => array('1' => ('Supplier Documentation')));
  $form_state['values']['name'] = $default_user;
  $form_state['values']['book']['bid'] = "new"; // Create new book

  $form_state['values']['op'] = t('Save'); // required
  drupal_execute('book_node_form', $form_state, (object)$node);

  variable_set('erp_supplier_doc_book', $form_state['nid']);
  variable_get('erp_supplier_doc_parent', $form_state['nid']);

  $node = array();
  $node['type'] = 'book'; // node type
  $form_state = array();

  $form_state['values']['title'] = t('Store Documentation'); // node title
  $form_state['values']['body'] = t('This book is used to contain all store documentation'); // node body
  $form_state['values']['taxonomy'] = array('tags' => array('1' => ('Store Documentation')));
  $form_state['values']['name'] = $default_user;
  $form_state['values']['book']['bid'] = "new"; // Create new book

  $form_state['values']['op'] = t('Save'); // required
  drupal_execute('book_node_form', $form_state, (object)$node);

  variable_set('erp_store_doc_book', $form_state['nid']);
  variable_get('erp_store_doc_parent', $form_state['nid']);

  // Create a store and make it the default
  $node = array();
  $node['type'] = 'erp_store'; // node type

  $form_state = array();
  $form_state['values']['title'] = $values['erp_store_name'];
  $form_state['values']['company'] = $values['erp_store_name'];
  $form_state['values']['address'] = $values['erp_store_street_address'];
  $form_state['values']['suburb'] = $values['erp_store_suburb'];
  $form_state['values']['state'] = $values['erp_store_state'];
  $form_state['values']['postcode'] = $values['erp_store_postcode'];
  $form_state['values']['phone'] = $values['erp_store_phone'];
  $form_state['values']['name'] = $default_user;

  $form_state['values']['op'] = t('Save'); // required
  drupal_execute('erp_store_node_form', $form_state, (object)$node);

  variable_set('erp_default_store', $form_state['nid']);

  // Create default customer "test"
  $node = array();
  $node['type'] = 'erp_customer'; // node type

  $form_state = array();
  $form_state['values']['title'] = 'Test customer'; // node title
  $form_state['values']['body'] = 'Test customer'; // node body
  $form_state['values']['address'] = '65 Main Road';  // Use our Address as a default, so Google maps works.
  $form_state['values']['suburb'] = 'Nairne';
  $form_state['values']['postcode'] = '5252';
  $form_state['values']['phone'] = '+40-6-5000'; // Transylvania 6-5000!
  $form_state['values']['name'] = $default_user;

  $form_state['values']['franchisee'] = $default_user;

  $form_state['values']['op'] = t('Save'); // required
  drupal_execute('erp_customer_node_form', $form_state, (object)$node);

  // Create default supplier "internal"
  $node = array();
  $node['type'] = 'erp_supplier'; // node type

  $internal_supplier = $values['erp_store_name'] .' '. t('Supplier');

  $form_state = array();
  $form_state['values']['title'] = $internal_supplier;
  $form_state['values']['body'] = 'Internal use supplier'; // node body
  $form_state['values']['company'] = $values['erp_store_name'];
  $form_state['values']['address'] = $values['erp_store_street_address'];
  $form_state['values']['suburb'] = $values['erp_store_suburb'];
  $form_state['values']['state'] = $values['erp_store_state'];
  $form_state['values']['postcode'] = $values['erp_store_postcode'];
  $form_state['values']['phone'] = $values['erp_store_phone'];
  $form_state['values']['name'] = $default_user;

  $form_state['values']['op'] = t('Save'); // required
  drupal_execute('erp_supplier_node_form', $form_state, (object)$node);

  // Create default item "LABOUR"
  $node = array();
  $node['type'] = 'erp_item'; // node type

  $form_state = array();
  $form_state['values']['title'] = t('LABOUR'); // node title
  $form_state['values']['code'] = t('LABOUR');
  $form_state['values']['supp_code'] = t('LABOUR');
  $form_state['values']['supplier'] = $internal_supplier;
  $form_state['values']['item_type'] = 'service';
  $form_state['values']['item_locked'] = 1;
  $form_state['values']['active'] = 1;
  $form_state['values']['full_desc'] = t('Use this item to charge our labour to clients');
  $form_state['values']['rrp_price'] = 110;
  $form_state['values']['sell_price'] = 110;
  $form_state['values']['buy_price'] = 0;
  $form_state['values']['name'] = $default_user;

  $form_state['values']['op'] = t('Save'); // required
  drupal_execute('erp_item_node_form', $form_state, (object)$node);

  // Setup theme
  install_disable_theme('garland');
  install_default_theme('erp_theme');
  
  // Setup left blocks
  install_disable_block('user', 1, 'erp_theme');
  install_set_block('user', 0, 'erp_theme', 'left', -21);
  install_add_block('erp_customer', 0, 'erp_theme', 1, -19, 'left');
  install_add_block('nice_menus', 2, 'erp_theme', 1, -18, 'left');
  install_add_block('erp', 0, 'erp_theme', 1, -17, 'left');
  install_add_block('autologout', 0, 'erp_theme', 1, -16, 'left');

  // Setup right blocks
  install_add_block('erp_cart', 0, 'erp_theme', 1, -20, 'right');
  install_add_block('views', 'erp_job_calendar-block_1', 'erp_theme', 1, -19, 'right');  

  // Setup data parts for other modules that dont yet have install_profile_api hooks
  db_query("INSERT INTO `quicktabs` (`qtid`, `ajax`, `title`, `tabs`, `style`) VALUES (NULL, 0, 'customer tabs', '%s', 'Basic')",
    'a:7:{i:0;a:5:{s:3:"bid";s:40:"views_delta_erp_invoice_customer-block_1";s:10:"hide_title";i:1;s:5:"title";s:8:"invoices";s:6:"weight";s:3:"-10";s:4:"type";s:5:"block";}i:1;a:5:{s:3:"bid";s:44:"views_delta_4800c5eaa1772297a56142ea0d52c826";s:10:"hide_title";i:1;s:5:"title";s:15:"purchase orders";s:6:"weight";s:2:"-9";s:4:"type";s:5:"block";}i:2;a:5:{s:3:"bid";s:38:"views_delta_erp_quote_customer-block_1";s:10:"hide_title";i:1;s:5:"title";s:6:"quotes";s:6:"weight";s:2:"-8";s:4:"type";s:5:"block";}i:3;a:5:{s:3:"bid";s:36:"views_delta_erp_job_customer-block_1";s:10:"hide_title";i:1;s:5:"title";s:4:"jobs";s:6:"weight";s:2:"-7";s:4:"type";s:5:"block";}i:4;a:5:{s:3:"bid";s:42:"views_delta_erp_cash_sale_customer-block_1";s:10:"hide_title";i:1;s:5:"title";s:10:"cash sales";s:6:"weight";s:2:"-6";s:4:"type";s:5:"block";}i:5;a:5:{s:3:"bid";s:40:"views_delta_erp_payment_customer-block_1";s:10:"hide_title";i:1;s:5:"title";s:8:"payments";s:6:"weight";s:2:"-5";s:4:"type";s:5:"block";}i:6;a:5:{s:3:"bid";s:37:"views_delta_erp_book_customer-block_1";s:10:"hide_title";i:1;s:5:"title";s:10:"book pages";s:6:"weight";s:2:"-4";s:4:"type";s:5:"block";}}');

  db_query("INSERT INTO `variable` (`name`, `value`) VALUES ('gmap_default', '%s')",
    'a:13:{s:5:"width";s:5:"700px";s:6:"height";s:5:"300px";s:7:"latlong";s:39:"40.017623730353485,-0.02986907958984375";s:4:"zoom";s:2:"12";s:7:"maxzoom";s:2:"14";s:6:"styles";a:2:{s:12:"line_default";a:5:{i:0;s:6:"0000ff";i:1;s:1:"5";i:2;s:2:"45";i:3;s:0:"";i:4;s:0:"";}s:12:"poly_default";a:5:{i:0;s:6:"000000";i:1;s:1:"3";i:2;s:2:"25";i:3;s:6:"ff0000";i:4;s:2:"45";}}s:11:"controltype";s:5:"Small";s:3:"mtc";s:8:"standard";s:7:"maptype";s:3:"Map";s:10:"baselayers";a:4:{s:3:"Map";i:1;s:9:"Satellite";i:1;s:6:"Hybrid";i:1;s:8:"Physical";i:0;}s:8:"behavior";a:12:{s:7:"locpick";b:0;s:6:"nodrag";i:0;s:10:"nokeyboard";i:1;s:11:"nomousezoom";i:0;s:10:"nocontzoom";i:0;s:8:"autozoom";i:0;s:10:"dynmarkers";i:0;s:8:"overview";i:0;s:12:"collapsehack";i:0;s:5:"scale";i:0;s:17:"extramarkerevents";b:0;s:15:"clickableshapes";b:0;}s:10:"markermode";s:1:"0";s:11:"line_colors";a:3:{i:0;s:7:"#00cc00";i:1;s:7:"#ff0000";i:2;s:7:"#0000ff";}}');
  
}

