<?php

/* TODO db_next_id() is gone, and replaced as db_last_insert_id()
   Since db_next_id() introduce some problems, and the use of this function
   can be replaced by database level auto increment handling, db_next_id()
   is now gone and replaced as db_last_insert_id() with help of serial type
   under Schema API (check out http://drupal.org/node/149176 for more details).
   Please refer to drupal_write_record() as demonstration. */

/* TODO FormAPI image buttons are now supported.
   FormAPI now offers the 'image_button' element type, allowing developers to
   use icons or other custom images in place of traditional HTML submit buttons.

$form['my_image_button'] = array(
  '#type'         => 'image_button',
  '#title'        => t('My button'),
  '#return_value' => 'my_data',
  '#src'          => 'my/image/path.jpg',
); */

/* TODO Node previews and adding form fields to the node form.
   There is a subtle but important difference in the way node previews (and other
   such operations) are carried out when adding or editing a node. With the new
   Forms API, the node form is handled as a multi-step form. When the node form
   is previewed, all the form values are submitted, and the form is rebuilt with
   those form values put into $form['#node']. Thus, form elements that are added
   to the node form will lose any user input unless they set their '#default_value'
   elements using this embedded node object. */

/* TODO New user_mail_tokens() method may be useful.
   user.module now provides a user_mail_tokens() function to return an array
   of the tokens available for the email notification messages it sends when
   accounts are created, activated, blocked, etc. Contributed modules that
   wish to make use of the same tokens for their own needs are encouraged
   to use this function. */

/* TODO
   There is a new hook_watchdog in core. This means that contributed modules
   can implement hook_watchdog to log Drupal events to custom destinations.
   Two core modules are included, dblog.module (formerly known as watchdog.module),
   and syslog.module. Other modules in contrib include an emaillog.module,
   included in the logging_alerts module. See syslog or emaillog for an
   example on how to implement hook_watchdog.
function example_watchdog($log = array()) {
  if ($log['severity'] == WATCHDOG_ALERT) {
    mysms_send($log['user']->uid,
      $log['type'],
      $log['message'],
      $log['variables'],
      $log['severity'],
      $log['referer'],
      $log['ip'],
      format_date($log['timestamp']));
  }
} */

/* TODO Implement the hook_theme registry. Combine all theme registry entries
   into one hook_theme function in each corresponding module file.
function item_import_theme() {
  return array(
  );
}; */


/* TODO
   An argument for replacements has been added to format_plural(),
   escaping and/or theming the values just as done with t().*/

module_load_include('inc', 'item_import', 'includes/bootstrap');
drupal_bootstrap(DRUPAL_BOOTSTRAP_FULL);

// If not in 'safe mode', increase the maximum execution time:
if (!ini_get('safe_mode')) {
  set_time_limit(3000);
}

ob_implicit_flush (TRUE);

global $user;

$user->name = 'admin';
$user->uid = 1;

// Iterate through the modules calling their cron handlers (if any):
module_invoke('erp_item', 'import', 'cmd');


