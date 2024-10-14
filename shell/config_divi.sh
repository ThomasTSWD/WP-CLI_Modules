#!/bin/bash


# Autres mises à jour
wp eval '
$options = get_option("et_divi");
if (is_array($options)) {
    $on_options = [
        "et_enable_classic_editor",
        "divi_gallery_layout_enable",
        "divi_dynamic_module_framework"
    ];

    $off_options = [
        "divi_show_postcomments",
        "divi_show_pagescomments",
        "et_pb_static_css_file",
        "divi_page_thumbnails",
        "divi_google_fonts_inline"
    ];

    foreach ($on_options as $option) {
        $options[$option] = "on";
    }
    foreach ($off_options as $option) {
        $options[$option] = "off";
    }

    $options["divi_date_format"] = "j M, Y";
    $options["divi_custom_css"] = ":root { --color-tomato: tomato; } #footer-info { width: 100%; display: flex; justify-content: center; } #footer-info a { font-weight: 400 !important; font-size: .935em; } #footer-info a:not(:nth-last-of-type(1)) { margin-right: 1.5em; position: relative; } #footer-info a:not(:nth-last-of-type(1)):after { content: ''; height: .75em; width: 1px; position: absolute; background: white; top: 28%; right: -.75em; } #legal-page h1 { font-size: 2.2em; text-transform:uppercase; } #legal-page h2{ padding-top:.85em } #legal-page h2 , #legal-page h3{ padding-bottom:.75em; text-transform:uppercase; }";
    $options["divi_color_palette"] = "#3b82f6|#9333ea|#f97316|#eab308|#34d399|#fca5a1|#64748b|#dbeafe";
    $options["custom_footer_credits"] = "<a href=\"/\">© <span class=\"tswd-year\">2024</span> Company </a> <a href=\"/politique-de-confidentialite/\">Politique de confidentialité</a> <a href=\"/mentions-legales/\">Mentions légales</a> <a target=\"_blank\" href=\"https://tswd.fr/\">Création <span>TSWD</span></a>";

    update_option("et_divi", $options);
    echo "Options mises à jour avec succès pour les autres paramètres.";
} else {
    echo "Erreur : options non valides.";
}'
