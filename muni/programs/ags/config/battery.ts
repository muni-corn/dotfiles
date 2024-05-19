import { Attention, Tile, makeTile, percentageToIconFromList } from "utils";

const battery = await Service.import("battery");

const ICONS = {
  discharging: [
    "\u{f008e}",
    "\u{f007a}",
    "\u{f007b}",
    "\u{f007c}",
    "\u{f007d}",
    "\u{f007e}",
    "\u{f007f}",
    "\u{f0080}",
    "\u{f0081}",
    "\u{f0082}",
    "\u{f0079}",
  ],
  charging: [
    "\u{f089f}",
    "\u{f089c}",
    "\u{f0086}",
    "\u{f0087}",
    "\u{f0088}",
    "\u{f089d}",
    "\u{f0089}",
    "\u{f089e}",
    "\u{f008a}",
    "\u{f008b}",
    "\u{f0085}",
  ],
  full: "\u{f0084}",
  unknown: "\u{f0091}",
};

const DATE_FORMAT = new Intl.DateTimeFormat("en-US", {
  hour: "numeric",
  minute: "numeric",
});

export function Battery() {
  function getIcon(charged: boolean, charging: boolean, percent: number) {
    if (charged) {
      return ICONS.full;
    } else if (charging) {
      return percentageToIconFromList(percent, ICONS.charging);
    } else return percentageToIconFromList(percent, ICONS.discharging);
  }

  function getReadableTime(
    charged: boolean,
    charging: boolean,
    secondsRemaining: number,
  ): string {
    if (charged) {
      return "Plugged in";
    } else if (secondsRemaining > 0) {
      if (secondsRemaining < 30 * 60) {
        const minutes = Math.ceil(secondsRemaining / 60);
        return `${minutes} min left`;
      } else {
        const timeToCompletion = new Date(Date.now() + secondsRemaining * 1000);
        const formatted = DATE_FORMAT.format(timeToCompletion).toLowerCase();
        if (charging) {
          return `Full at ${formatted}`;
        } else {
          return `Until ${formatted}`;
        }
      }
    } else {
      return "";
    }
  }

  let tileBinding = Utils.merge(
    [
      battery.bind("available"),
      battery.bind("percent"),
      battery.bind("time_remaining"),
      battery.bind("charging"),
      battery.bind("charged"),
    ],
    (available, percent, time_remaining, charging, charged): Tile => {
      let attention = Attention.Normal;
      if (!charging && !charged && time_remaining > 0 && percent > 0) {
        if (percent <= 10 || time_remaining <= 1800) {
          attention = Attention.Alarm;
        } else if (percent <= 20 || time_remaining <= 3600) {
          attention = Attention.Warning;
        }
      }

      return {
        icon: getIcon(charged, charging, percent) || ICONS.unknown,
        primary: charged ? "Full" : `${percent}%`,
        secondary: getReadableTime(charged, charging, time_remaining),
        visible: available,
        attention,
      };
    },
  );

  return makeTile(tileBinding);
}

export {};
