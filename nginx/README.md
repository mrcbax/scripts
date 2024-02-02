# NGINX Rules

these rules are meant to be imported in the http block and used in if statements within server or location blocks.

There are several snippets in the `snippets` directory that can be used with `import` directives.

These rules are designed to be used in conjunction with a [TeapotFortune Server](https://github.com/mrcbax/TeapotFortune)

The main goal of these rules is to prevent the scraping of website data by large language model crawlers. The secondary goal of these rules is to stop exploitation and service abuse.

> "Everyone and their mother is getting into AI"
~ Random Netizen 

These rules are incompatible with Wordpress installations as they block anyone accessing common Wordpress paths (most exploitation attempts start by scanning for wordpress). If you intend to use these rules with a Wordpress installation (or really anything PHP based) you probably do not want to utilize `bad_paths.rule`

There is an Ansible playbook for applying updates to these rules to multiple servers in one go.
