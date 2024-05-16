import { Tile, makeTile } from "utils";

const bluetooth = await Service.import("bluetooth");

const BLUETOOTH_BATTERY_ICONS = [
  "\u{F093E}",
  "\u{F093F}",
  "\u{F0940}",
  "\u{F0941}",
  "\u{F0942}",
  "\u{F0943}",
  "\u{F0944}",
  "\u{F0945}",
  "\u{F0946}",
  "\u{F0948}",
];
const BLUETOOTH_BATTERY_UNKNOWN_ICON = "\u{F094A}";

export function Bluetooth() {
  const tileBinding = Utils.merge(
    [bluetooth.bind("enabled"), bluetooth.bind("connected_devices")],
    (enabled, connectedDevices): Tile => {
      if (!enabled) {
        return {
          icon: "\u{F00B2}",
          primary: "",
          secondary: "",
          visible: true,
        };
      } else {
        switch (connectedDevices.length) {
          case 0:
            return {
              icon: "\u{F00AF}",
              primary: "",
              secondary: "",
              visible: true,
            };
          case 1:
            const device = connectedDevices[0];
            const battery = device.battery_percentage || device.battery_level;
            return {
              icon: "\u{F00B1}",
              primary: "",
              secondary:
                battery > 0
                  ? BLUETOOTH_BATTERY_ICONS[
                      Math.min(
                        BLUETOOTH_BATTERY_ICONS.length - 1,
                        (BLUETOOTH_BATTERY_ICONS.length * battery) / 100,
                      )
                    ] || BLUETOOTH_BATTERY_UNKNOWN_ICON
                  : "",
              visible: true,
            };
          default:
            return {
              icon: "\u{F00B1}",
              primary: "",
              secondary: `${connectedDevices.length}`,
              visible: true,
            };
        }
      }
    },
  );

  return makeTile(tileBinding);
}

export {};
