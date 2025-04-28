cat > app/assets/config/manifest.js << 'EOF'
//= link_tree ../images
//= link_directory ../javascripts .js
//= link_directory ../stylesheets .css
//= link application.css
//= link application.js
//= link products.css
//= link_tree ../../javascript .js
//= link_tree ../../../vendor/javascript .js
EOF