#!/bin/bash


rm wp-config-sample.php

history -c

wp theme delete --all

wp theme install https://github.com/ThomasTSWD/WPCLI/raw/main/Divi.zip --activate

wp theme install https://github.com/ThomasTSWD/WPCLI/raw/main/Divi_child.zip

wp plugin delete akismet hello

wp plugin install https://github.com/ThomasTSWD/tswd-front-end/archive/refs/heads/main.zip simple-divi-shortcode wp-custom-body-class better-search-replace enable-media-replace disable-comments bulk-page-creator ewww-image-optimizer --activate

wp plugin install really-simple-ssl cookie-law-info wordpress-seo google-analytics-for-wordpress wp-fastest-cache wow-carousel-for-divi-lite popups-for-divi contact-form-7 favicon-by-realfavicongenerator wp-pagenavi autoptimize wp-pagenavi

wp plugin install woocommerce woocommerce-pdf-invoices-packing-slips --activate

wp plugin install side-cart-woocommerce woocommerce-table-rate-shipping smntcs-woocommerce-quantity-buttons

wp comment delete --force $(wp comment list --format=ids)

wp widget delete block-2 block-4 sidebar-1

wp post delete 2 --force

PAGE_ID=$(wp post create --post_type=page --post_title="Accueil" --post_status=publish --post_content='[et_pb_section fb_built="1" _module_preset="default" global_colors_info="{}"][et_pb_row _module_preset="default" global_colors_info="{}"][et_pb_column type="4_4" _module_preset="default" global_colors_info="{}"][et_pb_text _module_preset="default" hover_enabled="0" global_colors_info="{}" sticky_enabled="0"] <h1>Titre 1</h1> &nbsp; <h2>Titre 2</h2> &nbsp; <h3>Titre 3</h3> &nbsp; [lorem x=333] [/et_pb_text][/et_pb_column][/et_pb_row][et_pb_row _module_preset="default"][et_pb_column _module_preset="default" type="4_4"][et_pb_button _module_preset="default" button_text="mon bouton" button_url="#" hover_enabled="0" sticky_enabled="0"][/et_pb_button][/et_pb_column][/et_pb_row][/et_pb_section]' --porcelain)


wp option update show_on_front 'page'

wp option update page_on_front $PAGE_ID

wp post delete 3 --force

PAGE_ID=$(wp post create --post_type=page --post_title='Politique de confidentialit&eacute;' --post_name="politique-de-confidentialite" --post_status=publish --post_content='[et_pb_section fb_built="1" _builder_version="4.23.1" hover_enabled="0" global_colors_info="{}" module_id="legal-page" admin_label="# legal-page" sticky_enabled="0"][et_pb_row _builder_version="4.16" background_size="initial" background_position="top_left" background_repeat="repeat" global_colors_info="{}"][et_pb_column type="4_4" _builder_version="4.16" custom_padding="|||" global_colors_info="{}" custom_padding__hover="|||"][et_pb_text _builder_version="4.23.1" _module_preset="default" hover_enabled="0" sticky_enabled="0"]<h1>Politique de confidentialité</h1>[/et_pb_text][et_pb_text _builder_version="4.23.1" _module_preset="default" hover_enabled="0" sticky_enabled="0"][/et_pb_text][/et_pb_column][/et_pb_row][/et_pb_section]' --porcelain)


wp option update wp_page_for_privacy_policy $PAGE_ID

PAGE_ID=$(wp post create --post_type=page --post_title='Mentions légales' --post_status=publish --post_content='[et_pb_section fb_built="1" _builder_version="4.23.1" hover_enabled="0" global_colors_info="{}" module_id="legal-page" admin_label="# legal-page" sticky_enabled="0"][et_pb_row _builder_version="4.16" background_size="initial" background_position="top_left" background_repeat="repeat" global_colors_info="{}"][et_pb_column type="4_4" _builder_version="4.16" custom_padding="|||" global_colors_info="{}" custom_padding__hover="|||"][et_pb_text _builder_version="4.23.1" _module_preset="default" hover_enabled="0" sticky_enabled="0"]<h1>Mentions légales</h1>[/et_pb_text][et_pb_text _builder_version="4.23.1" _module_preset="default" hover_enabled="0" sticky_enabled="0"][/et_pb_text][/et_pb_column][/et_pb_row][/et_pb_section]' --porcelain)

wp post update 1 --post_title="Article de blog" --post_name=article-de-blog

wp menu create "Menu principal FR"

wp option update blogdescription "Site en développement"

wp option update blog_public 0

wp option update permalink_structure '/%postname%/'

wp option update default_comment_status closed

wp option update show_avatars 0

wp option update thumbnail_size_w 350

wp option update thumbnail_size_h 350

wp option update thumbnail_crop 1

wp option update medium_size_w 900

wp option update medium_size_h 900

wp option update large_size_w 1200

wp option update large_size_h 1200

wp config set AUTOMATIC_UPDATER_DISABLED true --raw

wp config set WP_AUTO_UPDATE_CORE false --raw

wp media import https://github.com/ThomasTSWD/WPCLI/raw/main/placeholder.jpg

echo "define('ALLOW_UNFILTERED_UPLOADS', true);" >> wp-config.php

wp config set WP_MAX_MEMORY_LIMIT '512M' --type=constant

wp config set WP_MEMORY_LIMIT '256M' --type=constant

wp cache flush

history -c
