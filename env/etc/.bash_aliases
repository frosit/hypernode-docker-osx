# Bash aliases
# @todo add aliases from froscli

# Magerun shorthands
alias mr=magerun
alias mr2=magerun2

# Automatically defines those values from ~/.my.cnf, @todo move to elsewhere
export DB_PASS=`cat /data/web/.my.cnf  | grep pass | awk '{print$3}'`
export DB_USER=`cat /data/web/.my.cnf  | grep user | awk '{print$3}'`
export DB_HOST=`cat /data/web/.my.cnf  | grep host | awk '{print$3}'`