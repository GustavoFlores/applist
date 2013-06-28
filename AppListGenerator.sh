#!/bin/bash
#Version 1.0 by Gustavo Flores

irpapps='adn ads adv amp cpl dir elt iip loy mid mog pap pdl pne png pub que rdi res roc sel shd'
irtapps='aps cdh etk nox ppp raf rev'
iapapps='aml apa ess ghi gsv gsw had jfs lss mds mrs mss mws rfd scs ssc tds'
iadapps='cml fml ocs'
iriapps='apb ape apk apl asf bfm dsh feh mcd ngi pfx rms ses sit'
ietapps='car hca hcr hos orn rdp'
phases='dev pdt uat mig ap1 fvt qrt btprd sup skl ppt prd'

case "$1" in
    irp)
        ;;
    irt)
        ;;
    iap)
        ;;
    iad)
        ;;
    iri)
        ;;
    iet)
        ;;
    *)
        echo "Need a parameter for the app mgt group after the command like."
        echo "Possible values: irp irt iap iad iri iet"
        exit 1
esac

if [ $# -ge 1 ]
then
    eval apps=\$${1}apps
else
    apps=$irpapps
fi
echo "Begin == " > log.txt
# First let's get the list of nodes

for app in $apps
do
   for phase in $phases
      do
         cat /home/gflores/CFG/application_setup/config/${app}/${phase} 2>/dev/null| \
          grep app_failover | grep -vE '^#'| sed 's/app_failover//g'| sed 's/\s\+$//g'| \
          sed 's/\s\+/ /g'| sed 's/^\s\+//g'|sed '/^$/d'|tr ' ' '\n'| \
          sed "s/\(.*\)/\1 $app-$phase/g"
         cat /home/gflores/CFG/application_setup/config/${app}/${phase} 2>/dev/null| \
          grep hacs_failover | grep -vE '^#'| sed 's/hacs_failover//g'| sed 's/\s\+$//g'| \
          sed 's/\s\+/ /g'| sed 's/^\s\+//g'|sed '/^$/d'|tr ' ' '\n'| \
          sed "s/\(.*\)/\1 $app-$phase-HACS/g"
         cat /home/gflores/CFG/application_setup/config/${app}/${phase} 2>/dev/null| \
          grep peak_failover | grep -vE '^#'| sed 's/peak_failover_[pP][kK][0-9]\+//g'| sed 's/\s\+$//g'| \
          sed 's/\s\+/ /g'| sed 's/^\s\+//g'|sed '/^$/d'|tr ' ' '\n'| \
          sed "s/\(.*\)/\1 $app-$phase-PEAK/g"
         cat /home/gflores/CFG/application_setup/config/${app}/${phase} 2>/dev/null| \
          grep gqs_failover_ | grep -vE '^#'| sed 's/gqs_failover_[pP][kK][0-9]\+//g'| sed 's/\s\+$//g'| \
          sed 's/\s\+/ /g'| sed 's/^\s\+//g'|sed '/^$/d'|tr ' ' '\n'| \
          sed "s/\(.*\)/\1 $app-$phase-GQS-PEAK/g"
         cat /home/gflores/CFG/application_setup/config/${app}/${phase} 2>/dev/null| \
          grep gqs_failover | grep -v gqs_failover_ |grep -vE '^#'| sed 's/gqs_failover//g'| sed 's/\s\+$//g'| \
          sed 's/\s\+/ /g'| sed 's/^\s\+//g'|sed '/^$/d'|tr ' ' '\n'| \
          sed "s/\(.*\)/\1 $app-$phase-GQS/g"
         echo "Finished $app-$phase" >> log.txt
      done
done | sort | awk 'BEGIN { curNode = "" } { if (curNode != $1) {curNode=$1; printf "\n%s %s",$1,$2;} else if (curNode == $1) {curNode=$1; printf " %s",$2;}}'
echo

