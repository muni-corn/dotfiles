import { Wifi } from "types/service/network";
import { makeTile } from "utils";

const network = await Service.import("network");

function getIcon(iconList: string[], strength: number): string {
  const iconListLength = iconList.length;
  const index = Math.min(iconListLength - 1, (iconListLength * strength) / 100);
  return iconList[index];
}

const WIFI_ICONS = {
  connected: ["\u{F092F}", "\u{F091F}", "\u{F0922}", "\u{F0925}", "\u{F0928}"],
  packetLoss: ["\u{F092B}", "\u{F0920}", "\u{F0923}", "\u{F0926}", "\u{F0929}"],
  vpn: ["\u{F092C}", "\u{F0921}", "\u{F0924}", "\u{F0927}", "\u{F092A}"],
  disconnected: "\u{F092F}",
  disabled: "\u{F092E}",
  unknown: "\u{F092B}",
};
function getWifiIcon(): string {
  const wifi = network.wifi;

  switch (wifi.state) {
    case "activated":
      if (wifi.internet === "disconnected") {
        return getIcon(WIFI_ICONS.packetLoss, wifi.strength);
      } else if (network.vpn.activated_connections.length > 0) {
        return getIcon(WIFI_ICONS.vpn, wifi.strength);
      } else {
        return getIcon(WIFI_ICONS.connected, wifi.strength);
      }
    case "unavailable":
      return WIFI_ICONS.disabled;
    case "disconnected":
      return WIFI_ICONS.disconnected;
    default:
      return WIFI_ICONS.unknown;
  }
}

const WIRED_ICONS = {
  connected: "\u{F059F}",
  packetLoss: "\u{F0551}",
  vpn: "\u{F0582}",
  disabled: "\u{F0A8E}",
  unknown: "\u{F0A39}",
};
function getWiredIcon(): string {
  const wired = network.wired;

  switch (wired.state) {
    case "activated":
      if (wired.internet === "disconnected") {
        return WIRED_ICONS.packetLoss;
      } else if (network.vpn.activated_connections.length > 0) {
        return WIRED_ICONS.vpn;
      } else {
        return WIRED_ICONS.connected;
      }
    case "unavailable":
    case "disconnected":
      return WIRED_ICONS.disabled;
    default:
      return WIRED_ICONS.unknown;
  }
}

function transformState(state: Wifi["state"]): string {
  switch (state) {
    case "activated":
      return "";
    case "need_auth":
      return "Waiting for authorization";
    case "config":
      return "Configuring";
    case "prepare":
      return "Preparing";
    case "secondaries":
      return "Waiting for secondaries";
    default:
      let transformed = state as string;
      transformed = transformed.replace("_", " ");
      transformed = transformed.replace("ip", "IP");
      transformed = transformed.charAt(0).toUpperCase() + transformed.slice(1);

      return transformed;
  }
}

export function Network() {
  return makeTile(
    Utils.merge(
      [network.bind("primary"), network.bind("wifi"), network.bind("wired")],
      (primary, wifi, wired) => {
        if (primary === "wired") {
          return {
            icon: getWiredIcon(),
            primary: transformState(wired.state),
            secondary: "",
            visible: true,
          };
        } else {
          return {
            icon: getWifiIcon(),
            primary: wifi.ssid || transformState(wifi.state),
            secondary: wifi.ssid ? transformState(wifi.state) : "",
            visible: true,
          };
        }
      },
    ),
  );
}

export {};
