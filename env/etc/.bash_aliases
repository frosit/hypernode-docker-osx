# Bash aliases
# @todo add aliases from froscli

alias mr=magerun
alias mr2=magerun2

# @todo make this work with magerun yaml
export dbPass=`cat /data/web/.my.cnf  | grep pass | awk '{print$3}'`