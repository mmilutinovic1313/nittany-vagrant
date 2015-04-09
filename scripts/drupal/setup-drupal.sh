#!/usr/bin/sh
# go to web root
cd /var/www/html/
# vagrant user or passed in
if [ -z $1 ]; then
    owner='vagrant'
  else
    owner=$1
fi
# find all files that are bash scripts here
IFS=$'\r\n' GLOBIGNORE='*' :; files=($(find /vagrant/scripts/drupal/distros/*.sh))
echo $files
# render the menu options
menuitems() {
  echo "Available options:"
  for i in ${!files[@]}; do
   val=`sed -n '2p' ${files[i]}`
    echo $((i+1)) "$val"
  done
  [[ "$msg" ]] && echo "" && echo "$msg"; :
}

# prompt the user
prompt="Enter an option: "
while menuitems && read -rp "$prompt" num && [[ "$num" ]]; do
  (( num > 0 && num <= ${#files[@]} )) || {
      msg="Invalid option: $num"; continue
  }
  if [ $num == ${#files[@]} ];then
    ((num--)); choice="${files[num]}"
    bash $choice
    bash /vagrant/scripts/drupal/drupal-cleanup.sh
    exit
  fi
done
