<?php

require_once(ABSPATH . WPINC . '/formatting.php');
global $linkssc_default_template;

$linkssc_default_template = "[link_url]";


// enable Links
$linkssc_enable_links_manager = get_option('linkssc_enable_links_manager', 'no');

add_filter( 'pre_option_link_manager_enabled', '__return_true' );

// Hook for adding admin menus
if ( is_admin() ){ 
	
		add_action('admin_menu', 'linkssc_add_options_page'); // add option page for plugin to Links menu
	
	add_action('admin_init', 'linkssc_register_mysettings');
	add_action('admin_head', 'linkssc_add_LastMod_box'); // add last updated meta box on link editing page
	add_action('edit_link', 'linkssc_update_link_editied'); // update link edited field on editing a link
	add_action('add_link', 'linkssc_update_link_editied'); // update link edited field on adding a link

add_action('admin_head', 'my_custom_css');


} 

function my_custom_css() {
  echo '<style>
  

  </style>';
}
// action function for above hook
function linkssc_add_options_page() 
{
    // Add a new submenu under Links:
    add_submenu_page( 'link-manager.php', __('Links Shortcode','links-shortcode'), __('Links Shortcode','links-shortcode'), 'manage_options', 'links-shortcode-settings', 'linkssc_options_page');
}





function linkssc_getdate($text)
{

	$result = new StdClass;
	
	if(preg_match("/\d\d\d\d-\d\d-\d\d:/",$text))
	{
		$result->date = substr($text,0,10);
		$result->title = substr($text,11);
	} 
	else
	{
		$result->date = '';
		$result->title = $text;	
	}
	return $result;
}

add_shortcode('links', 'linkssc_shortcode');
function linkssc_shortcode($atts, $content = null) 
{
	global $linkssc_default_template;
	$fblike = '';
	$fbrecommend = '';

	$fbcolors = get_option('linkssc_fbcolors', 'light');
	$template = get_option('linkssc_template', $linkssc_default_template);
		if ($template=='') { $template = $linkssc_default_template; update_option('linkssc_template', $linkssc_default_template); }


	extract(shortcode_atts(array(
			'fblike'		 => $fblike,
			'fbrecommend'	 => $fbrecommend,
			'fbcolors'		 => $fbcolors,
			'orderby'        => get_option('linkssc_orderby', 'name'), 
			'order'          => get_option('linkssc_order', 'DESC'),
			'limit'          => get_option('linkssc_howmany', '-1'), 
			'category'       => null,
			'category_name'  => null, 
			'hide_invisible' => 1,
			'show_updated'   => 0, 
			'include'        => null,
			'exclude'        => null,
			'search'         => '',
			'get_categories' => 0, 
			'links_per_page' => 0, 
			'links_list_id'  => '',
			'class'          => '',
			), $atts)
	);
	
	$args = array(
            'orderby'        => $orderby, 
            'order'          => $order,
            'limit'          => $limit, 
            'category'       => $category,
            'category_name'  => $category_name, 
            'hide_invisible' => $hide_invisible,
            'show_updated'   => $show_updated, 
            'include'        => $include,
            'exclude'        => $exclude,
            'search'         => $search);
			

		$bms = get_bookmarks( $args );
    
	
	// if category names need to be retrieved

	
	if ($fblike == '1'|| $fbrecommend == '1')
	{
		if ($fblike == '1') { $fbaction = 'like'; } else { $fbaction = 'recommend'; } 
	}
	else
	{
		$template = $linkssc_default_template;
	}
	
	// calculate pagination details if applicable
	$countlinks = count($bms);
	$pagenav = ''; // will be assigned if pagination is necessary
	if (($links_per_page > 0) && ($countlinks > 0)) // if $links_per_page == 0, the logic below is irrelevant and all links will be shown
	{
		if (isset($_GET['links_list_id']) && isset($_GET['links_page']) && ($links_list_id == $_GET['links_list_id']) && is_numeric($_GET['links_page']))
		{
			$links_page = max(abs(intval($_GET['links_page'])),1); // page number is minimal 1;

			$start = ($links_page - 1) * $links_per_page; // the first link is number 0;
			$end = min($countlinks - 1, $start + $links_per_page - 1); // '-1' because start is also included and the lowest start is 0
			if ($end < $start) // then someone tried to enter a page number that does not exists -> go to first page
			{
				$start = 0;
				$end = $links_per_page - 1;
				$links_page = 1;
			}
			
		}
		else
		{
			$start = 0;
			$end = $links_per_page - 1;
			$links_page = 1;
		}
		$next_page = 0;
		$previous_page = 0;
		$page_links = array();
		if ($start - $links_per_page >= 0)
		{
			$previous_page = $links_page - 1;
			$page_links[] = '<a href="./?links_page='.$previous_page.'&links_list_id='.$links_list_id.'">'.__('Previous page','links-shortcode').'</a>';
		}
		if ($countlinks > $start + $links_per_page)
		{	
			$next_page = $links_page + 1;
			$page_links[] = '<a href="./?links_page='.$next_page.'&links_list_id='.$links_list_id.'">'.__('Next page','links-shortcode').'</a>';
		}
		$pagenav = '<div class="links-page-nav">'.join(' - ', $page_links).'</div>'; // TODO: do this better, in UL/LI format
		
	}
		
	$text = "";
	$link_no = 0;
	foreach ($bms as $bm)
	{
		if ($links_per_page == 0 || ($link_no >= $start && $link_no <= $end) )
		{
			$newlinktext = $template.'';
			$title = linkssc_getdate($bm->link_name);
			$linkinfo = array();
			$linkinfo['class'] = $class; 
			$linkinfo['link_name'] = $title->title;
			$linkinfo['link_url'] = $bm->link_url;
			
			if (isset($bm->link_category)) {$linkinfo['link_category'] = $bm->link_category;} 
			
			if (preg_match('#^[\-0 :]*$#', $bm->link_updated)) { 
				$linkinfo['link_updated'] = ''; 
				$linkinfo['date'] = ''; 
			} 
			else {
				$linkinfo['link_updated'] = $bm->link_updated;
				$a = explode(' ', $bm->link_updated); 
				$linkinfo['date'] = $a[0];
			}
			if ($title->date != '') { $linkinfo['date'] = $title->date; }
			if (substr_count($linkinfo['date'], '-') == 2) {
				list($linkinfo['date_year'],$linkinfo['date_month'],$linkinfo['date_day']) = explode('-', $linkinfo['date']);
			}
			
			$reallinkinfo = array_diff($linkinfo, array('')); // remove all elements with empty value;
			foreach ($reallinkinfo as $k=>$v)
			{
				$newlinktext = str_replace('['.$k.']',$v,$newlinktext);
			}
			$c = preg_match_all ('/\[optional (.*)\|\|(.*)\]/U',$newlinktext,$optionals, PREG_PATTERN_ORDER);
			for (;$c > 0;$c--)
			{
				if ((preg_match('/\[(.*)\]/U',$optionals[1][$c-1],$tag)) && (isset($linkinfo[$tag[1]]))) 
				{
					$newlinktext = str_replace ($optionals[0][$c-1],$optionals[2][$c-1],$newlinktext); 
				}
				else
				{
					$newlinktext = str_replace ($optionals[0][$c-1],$optionals[1][$c-1],$newlinktext); 
				}
			}
			foreach ($linkinfo as $k=>$v)
			{
				$newlinktext = str_replace('['.$k.']','',$newlinktext);
			}
			
			$text .= $newlinktext; 
		
		}
		$link_no++;
    }
	$text .= "";
	
	if ($countlinks == 0 && $alttext != '') {
		$text = $alttext;
	}
	
	return do_shortcode($text); 



// Activation action
function linkssc_activation(){
	global $linkssc_default_template;

	add_option('linkssc_template', $linkssc_default_template); 

}
register_activation_hook( __FILE__, 'linkssc_activation' );

//Uninstalling Action
function linkssc_uninstall(){

	delete_option('linkssc_template');
	
}
register_uninstall_hook( __FILE__, 'linkssc_uninstall' );

function linkssc_register_mysettings() { // whitelist options
	
	register_setting( 'links-shortcode-settings', 'linkssc_template' );
	
}




function linkssc_options_page() 
{
	global $linkssc_default_template;
	if (!current_user_can( 'manage_options' ) ) {
		wp_die ( __( 'You do not have sufficient permissions to access this page' ) );
	}
	
	?>
	<div class="wrap">
	<div class="postbox" style="width:333px"><div class="inside" style="margin:10px; padding:6%">
		[links include="1"]
	</div></div>
	<?php
}



// function to update the link_edited field
function linkssc_update_link_editied($link_ID) {
    global $wpdb;
    $sql = "update ".$wpdb->links." set link_updated = NOW() where link_id = " . $link_ID . ";";
    $wpdb->query($sql);
}

// add meta box to show this date in the link editing screen
function linkssc_add_LastMod_box() {
    
    add_meta_box(
        'linkssclinkmodifieddiv', 
        'Last Modified', //title
        'linkssc_meta_box_add_last_modfied', 
        'link', 
        'side'  
    );

}
// This function echoes the content of our meta box
function linkssc_meta_box_add_last_modfied($link) {
     if (! empty($link->link_id))
     {
    echo "Last Modified Date: ";
    echo $link->link_updated;
    }
    else
    { echo "New Link";}
}


?>