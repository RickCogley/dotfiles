# Backup and database functions

function tdbackup-esolia {
  cd $HOME/Google\ Drive/\!Backups/PROdb/15331
  /usr/local/bin/mono tdbackup.exe
}

function tdbackup-cookjp {
  cd $HOME/Google\ Drive/\!Backups/PROdb/15361
  /usr/local/bin/mono tdbackup.exe
}

function tdbackup-cookap {
  cd $HOME/Google\ Drive/\!Backups/PROdb/25822
  /usr/local/bin/mono tdbackup.exe
}

function tdbackup-jrc {
  cd $HOME/Google\ Drive/\!Backups/PROdb/26644
  /usr/local/bin/mono tdbackup.exe
}

function confirmprodbbackup (){
  echo Confirming local PROdb backup ...
  ls -la ~/Google\ Drive/\!Backups/PROdb/15331-eSolia-DB-$(date +'%Y')/
  echo Confirming webfaction PROdb backup ...
  ssh rcogley@cogley.info ls -la /home/rcogley/webapps/es_dbflexbackup01/15331-eSolia-DB-$(date +'%Y')
}