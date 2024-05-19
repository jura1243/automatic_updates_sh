#show available updates
pathtocomposer=~/.local/bin

$pathtocomposer/composer update -W --dry-run
read -n1 -r -p "Press any key to continue..." key
