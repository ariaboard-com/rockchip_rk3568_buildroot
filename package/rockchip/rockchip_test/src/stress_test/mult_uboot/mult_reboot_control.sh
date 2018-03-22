#!/bin/sh

REBOOT_S95=/etc/init.d/S95rebootmult

if [ ! -f ${REBOOT_S95} ]
then
  cp /test_plan/mult_uboot/auto_reboot_run_mult.sh /etc/init.d/S95rebootmult
  chmod 777 ${REBOOT_S95}
fi

sh /test_plan/mult_uboot/mult_bl2_tpl_test_u.sh
