{pkgs}: let
bc = "${pkgs.bc}/bin/bc";
in
  pkgs.writeShellScriptBin "fuzzel-battery" ''
    manufacturer=$(cat /sys/class/power_supply/BATT/manufacturer)
    model=$(cat /sys/class/power_supply/BATT/model_name)
    cycles=$(cat /sys/class/power_supply/BATT/cycle_count)
    status=$(cat /sys/class/power_supply/BATT/status)
    chargefulldesign=$(echo "$(cat /sys/class/power_supply/BATT/charge_full_design)/1000" | ${bc})
    chargefull=$(echo "$(cat /sys/class/power_supply/BATT/charge_full)/1000" | ${bc})
    chargenow=$(echo "$(cat /sys/class/power_supply/BATT/charge_now)/1000" | ${bc})
    charge=$(echo "scale=4;100/$chargefull*$chargenow" | ${bc})
    capacity=$(echo "scale=4;100/$chargefulldesign*$chargefull" | ${bc})
    threshold=$(cat /sys/class/power_supply/BATT/charge_control_end_threshold)
    current=$(cat /sys/class/power_supply/BATT/current_now)

    echo "Manufacturer: $manufacturer
Model: $model
Cycles: $cycles
Factory capacity: $chargefulldesign mAh
Capacity: $capacity%
Threshold: $threshold%
Charge: $charge%
Status: $status" | ${pkgs.fuzzel}/bin/fuzzel -d
  ''
