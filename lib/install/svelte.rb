require "webpacker/configuration"

say "Copying svelte rule to config/webpack/rules"
copy_file "#{__dir__}/rules/svelte.js", Rails.root.join("config/webpack/rules/svelte.js").to_s

say "Adding svelte rule to config/webpack/environment.js"
insert_into_file Rails.root.join("config/webpack/environment.js").to_s,
  "const svelte = require('./rules/svelte')\n",
  after: /require\(('|")@rails\/webpacker\1\);?\n/

insert_into_file Rails.root.join("config/webpack/environment.js").to_s,
  "environment.rules.prepend('svelte', svelte)\n",
  before: "module.exports"

say "Copying Svelte example entry file to #{Webpacker.config.source_entry_path}"
copy_file "#{__dir__}/examples/svelte/hello_svelte.js",
  "#{Webpacker.config.source_entry_path}/hello_svelte.js"

say "Copying Svelte app file to #{Webpacker.config.source_path}"
copy_file "#{__dir__}/examples/svelte/app.svelte",
  "#{Webpacker.config.source_path}/app.svelte"

say "Installing all Svelte dependencies"
run "yarn add svelte svelte-loader"

say "Updating webpack paths to include .svelte file extension"
insert_into_file Webpacker.config.config_path, "- .svelte\n".indent(4), after: /\s+extensions:\n/

say "Webpacker now supports Svelte 🎉", :green
