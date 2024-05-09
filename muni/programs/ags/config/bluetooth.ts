import { Tile, makeTile } from "utils"

const bluetooth = await Service.import('bluetooth')

export function Bluetooth() {
  const tileBinding = Utils.merge([
    bluetooth.bind("enabled"),
    bluetooth.bind("connected_devices")
  ], (enabled, connectedDevices): Tile => {
    if (!enabled) {
      return {
        icon: "\u{F00B2}",
        primary: "",
        secondary: "",
        visible: true,
      }
    } else {
      switch (connectedDevices.length) {
        case 0:
          return {
            icon: "\u{F00AF}",
            primary: "",
            secondary: "",
            visible: true,
          }
        case 1:
          return {
            icon: "\u{F00B1}",
            primary: connectedDevices[0].name,
            secondary: "",
            visible: true,
          }
        default:
          return {
            icon: "\u{F00B1}",
            primary: `${connectedDevices.length} devices`,
            secondary: "",
            visible: true,
          }
      }
    }


  });

  return makeTile(tileBinding)
}

export {};
