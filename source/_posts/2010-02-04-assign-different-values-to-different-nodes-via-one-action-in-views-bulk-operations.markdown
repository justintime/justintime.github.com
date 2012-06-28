---
title: Assign Different Values to Different Nodes via One Action in Views Bulk Operations
permalink: /content/2010/02/04/assign-different-values-different-nodes-one-action-views-bulk-operations
layout: post
categories:
- Code
- Drupal
- Drupal Planet
comments: true
sharing: true
footer: true
---
The [Views Bulk
Operations](http://drupal.org/project/views_bulk_operations) module
(a.k.a. VBO), is a godsend for busy [Drupal](http://drupal.org) site
administrators. Don't just take my word for it -
[Lullabot](http://www.lullabot.com) wrote a chapter about it in
[O'Reilly's Using Drupal](http://oreilly.com/catalog/9780596515805/),
it's included in the [Open Atrium Drupal
distribution](http://openatrium.com/), and it's even used on
[Drupal.org](http://drupal.org/node/520290)! Out of the box, VBO does a
lot to streamline the things you do everyday, so that you spend less
time doing them. A perfect example is bulk content moderation - with a
few clicks of the mouse, you can mark a huge amount of comments as spam.
You can even enable batch processing with a single click of a mouse so
that you can literally do thousands of these without timing out.

VBO was
attractive enough that we decided to offload the bulk/batch operations
of [Node Gallery](http://drupal.org/project/node_gallery) to VBO.
Integration for the most part was surprisingly easy - VBO "speaks" in
Drupal Actions, so by [writing actions](http://drupal.org/node/172152),
we were writing integration with VBO. 

There's one undocumented case
where VBO can be used that was critical for us. Most VBO actions you
will find perform one action to a set of nodes, one at a time. Often
times, that one action is to set a value of some sort on said nodes. In
the case of [Node Gallery](http://drupal.org/project/node_gallery), we
wanted to be able to assign different weight values (used for sorting)
to a bunch of nodes. The key here is that we aren't assigning a value of
'2' to all selected node's weight, we want to assign a weight of 2 to
node \#1, 3 to node \#2, 8 to node \#3, and so on. While not
straightforward, it's definitely achievable.

The general idea we'll be
taking is to have VBO display a list of nodes to the admin. The admin
can place a checkmark next to the nodes that he wishes to change the
weight on, then select "Change the image's weight" from the action
dropdown, and click submit. We will then draw a form that includes some
summary information about the nodes, and a select box with the node's
current weight. The admin sets the weight he wants for each node, then
clicks submit. VBO then takes over, assigning each node the proper
weight. Let's get into the code - first we implement
hook\_action\_info(), telling Drupal that we have actions to provide:
{% highlight php %}
<?php
/**
* Implementation of hook_action_info().
*/
function node_gallery_action_info() {
  return array(
    'node_gallery_change_image_weight_action' => array(
      'description' => t('Change image weight (sort order)'),
      'type' => 'node',
      'behavior' => array('changes_node_property'),
      'configurable' => TRUE,
      'hooks' => array(
        'node' => array('presave'),
      ),
    ),
  );
}
{% endhighlight %}

The only real items of note in the hook above are setting 'configurable'
to true, and setting 'behavior' to 'changes\_node\_property'. Setting
'configurable' allows us to display a custom form, and setting the
behavior tells VBO that we'll be modifying the node. In turn, VBO will
call $node-\>save on each node after it's been processed. Next, we
define our configurable action's form function:
{% highlight php %}
<?php
function node_gallery_change_image_weight_action_form($context = array()) {
  //We're being called from VBO - we can do extra validation
  if ($context['view']->plugin_name == 'bulk') {
    //@todo: Add imagefield support in our sort form, and theme it with draggable items
    $sql = "SELECT n.nid, n.title, ngi.weight FROM {node} n " .
            "INNER JOIN {node_gallery_images} ngi ON n.nid = ngi.nid " .
            "WHERE n.nid IN (". db_placeholders($context['selection']) .")";
    $result = db_query($sql,$context['selection']);
    $delta = count($context['selection']) > 20 ? intval(count($context['selection'])/2) : 10;
    $form['node_gallery_change_image_weight_action']['#tree'] = TRUE;
    while ($image = db_fetch_object($result)) {
      $form['node_gallery_change_image_weight_action'][$image->nid]['title'] = array(
        '#type' => 'item',  
        '#value' => $image->title,
      );
      $form['node_gallery_change_image_weight_action'][$image->nid]['weight'] = array(
        '#type' => 'weight',
        '#title' => t('Weight'),
        '#default_value' => $image->weight,
        '#delta' => $delta,
      );
    }
  }
  //We're called from a standard advanced action where we assign one weight to all nodes
  else {
    $form['node_gallery_change_image_weight_action'] = array(
      '#type' => 'weight',
      '#title' => t('Weight'),
      '#description' => t('When listing images in a gallery, heavier items will sink at the lighter items will be positioned near the top'),
      '#delta' => 10,
    );
    if (isset($context['imageweight'])) {
      $form['node_gallery_change_image_weight_action']['#default_value'] = $context['imageweight'];
    }
  }
  return $form;
}
{% endhighlight %}

To define your form function, simply append '\_form' to your action name
and you have the function name. Nothing too wild and crazy in the form
function above, but there's two key points:

-   Line 3 shows you how you can detect when your function is being
    called from a VBO view.
-   When your function is called from VBO, it will pass you the nid's of
    the selected nodes in the array $context['selected']

Next, we define our submit function (you can define a validate function
if needed). Our submit function will pull the important data from the
submitted form and assemble it into a concise array that our action can
use. Here's our submit function:
{% highlight php %}
<?php
function node_gallery_change_image_weight_action_submit($form, $form_state) {
  //We're setting all nodes to the same weight
  if (is_numeric($form_state['values']['node_gallery_change_image_weight_action'])) {
    $weight = $form_state['values']['node_gallery_change_image_weight_action']; 
  }
  //VBO is passing us a set of nids
  else {
    foreach ($form_state['values']['node_gallery_change_image_weight_action'] as $nid => $val) {
      $weight[$nid] = $val['weight'];
    }
  }
  return array('imageweight' => $weight);
}
{% endhighlight %}

The key here is that if we are passed in the "single value" form, we
stick the value into the variable $weight as a simple scalar. If we are
passed in form data from the VBO "multi value" form, then $weight
becomes an associative array where the key is the nid, and the value is
the weight for that node.

Finally, we define our action function. Our
action is pretty simple, because it will only be called with one node
and one value. This is a key thing to remember when writing code for VBO
- even though you are working with batches of nodes, VBO is essentially
one big loop around the actions -- it executes the action once for each
node. So, in our action, we simply check to see if the value of the
$context['imageweight'] index that we passed from our submit function is
an integer or an array, and perform the correct operation on the node to
assign it it's new weight. Once this function returns, VBO will call
$node-\>save for us.
{% highlight php %}
<?php
function node_gallery_change_image_weight_action(&$node, $context = array()) {
  if (in_array($node->type, (array)node_gallery_get_types('image'))) {
    //All nodes are set to the same weight
    if (is_numeric($context['imageweight'])) {
      $node->weight = $context['imageweight'];
    }
    //VBO is sending us a list of nodes to modify with different weights
    else {
      $node->weight = $context['imageweight'][$node->nid];
    }
  } 
}
{% endhighlight %}

While not always obvious, there's not too many bulk operation conditions
that VBO can't handle. Hats off to
[infojunkie](http://drupal.org/user/48424) for writing such a helpful
module that is also easily integrated with!

