---
title: Display a CCK Filefield or Imagefield Upload Widget on Your Own Custom Form
permalink: /content/2010/01/26/display-cck-filefield-or-imagefield-upload-widget-your-own-custom-form
layout: post
categories:
- Drupal
- Drupal Planet
comments: true
sharing: true
footer: true
---
Took a fair amount of googling around to find the solution to this one. With
the [Node Gallery](http://drupal.org/project/node_gallery) 3.x branch, we
needed a way to quickly add an image to an existing gallery. We could have
displayed the whole node form, but there's a lot of things on that form that
we can just use the defaults for 99% of the time. We need just three fields
filled in: Title, Caption, and the imagefield itself.  To use the same
imagefield widget that handles all the hard work for you on the node add field
on your own field, first create a handler in hook_menu such as this:
{% highlight php startinline=true %}
$items['node/%node_gallery_gallery/upload'] = array(
    'title' => 'Upload New Image',
    'page callback' => 'drupal_get_form',
    'page arguments' => array('node_gallery_upload_image_form', 1),
    'access callback' => 'node_gallery_user_access',
    'access arguments' => array('upload', 1),
    'file' => 'node_gallery.pages.inc',
    'type' => MENU_LOCAL_TASK,
  );

{% endhighlight %}

Then, in node_gallery.pages.inc, you create the form function
that does the work: 
{% highlight php startinline=true %}
function node_gallery_upload_image_form($form_state, $gallery) {
  $imagetype = 'node_gallery_image';
  $form_id = $imagetype . '_node_form';
  
  module_load_include('inc', 'content', 'includes/content.node_form');
  $field = content_fields('field_node_gallery_image',$imagetype);
  
  $form['title'] = array(
    '#title' => t('Title'),
    '#type' => 'textfield',
    '#required' => TRUE,
    '#weight' => -10,
  );
  $form['body'] = array(
    '#title' => t('Caption'),
    '#type' => 'textarea',
    '#weight' => -9,
  );
  $form['type'] = array(
    '#type' => 'value',
    '#value' => $imagetype,
  );
  $form['gid'] = array(
    '#type' => 'value',
    '#value' => $gallery->nid,
  );
  $form['#field_info']['field_node_gallery_image'] = $field;
  $form['#field_info']['field_node_gallery_image']['#required'] = TRUE;
  $form += (array) content_field_form($form, $form_state, $field);
  
  $form['submit'] = array('#type' => 'submit', '#weight' => 10, '#value' => 'Save');
  
  return $form;
}
{% endhighlight %}

This is pretty straightforward, up
until lines 28 - 30. Those three lines setup the form array and then append
the results from content_field_form() to our existing form. Still, very easy,
but I wasn't able to find any documentation on how to do this. Just in case
you're curious, here's the submit handler for that form.
{% highlight php startinline=true %}
function node_gallery_upload_image_form_submit($form, &$form_state) {
  global $user;
  $image = new stdClass;
  $image->uid = $user->uid;
  $image->name = (isset($user->name) ? $user->name : '');
  $values = $form_state['values'];
  foreach ($values as $key => $value) {
    $image->$key = $value;
  }
  node_gallery_image_save($image);
}
{% endhighlight %}
Nothing new
there. The end result is a nice looking, concise form that allows you to
quickly upload an image to a gallery. Sweet!

