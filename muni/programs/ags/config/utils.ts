import { Align } from "types/@girs/gtk-3.0/gtk-3.0.cjs";
import { Binding } from "types/service";

export enum Attention {
  Alarm = "alarm",
  Warning = "warning",
  Normal = "",
}

export interface Tile {
  icon: string;
  primary: string;
  secondary: string;
  visible?: boolean;
  attention?: Attention
}

export function makeTile(
  data: Tile | Binding<any, any, Tile>
) {
  if ("as" in data) {
    return Widget.Box({
      children: [
        Widget.Label({
          label: data.as((d) => d.icon),
          visible: data.as((d) => d.icon?.length > 0),
          classNames: data.as((d) => ["icon", d.attention || "primary"]),
          widthRequest: 16,
        }),
        Widget.Label({
          label: data.as((d) => trunc(d.primary)),
          visible: data.as((d) => d.primary.length > 0),
          className: data.as((d) => d.attention || "primary"),
        }),
        Widget.Label({
          label: data.as((d) => trunc(d.secondary)),
          visible: data.as((d) => d.secondary.length > 0),
          className: data.as((d) => d.attention || "secondary"),
        }),
      ],
      spacing: 12,
      visible: data.as((d) => d.visible === undefined ? true : d.visible),
    });
  } else {
    return Widget.Box({
      children: [
        Widget.Label({
          label: data.icon,
          visible: data.icon.length > 0,
          classNames: ["icon", data.attention || "primary"],
          widthRequest: 16,
        }),
        Widget.Label({
          label: trunc(data.primary),
          visible: data.primary.length > 0,
          className: data.attention || "primary",
        }),
        Widget.Label({
          label: trunc(data.secondary),
          visible: data.secondary.length > 0,
          className: data.attention || "secondary",
        }),
      ],
      spacing: 12,
      visible: data.visible === undefined ? true : data.visible,
    });
  }
}

export interface ProgressTile {
  icon: string;
  progress: number;
  visible: boolean;
}

export function makeProgressTile(
  data: ProgressTile | Binding<any, any, ProgressTile>,
) {
  if ("as" in data) {
    return Widget.Box({
      children: [
        Widget.Label({
          label: data.as((d) => d.icon),
          visible: data.as((d) => d.icon.length > 0),
          classNames: ["icon", "dim"],
          widthRequest: 16,
        }),
        Widget.ProgressBar({
          value: data.as((d) => d.progress),
          hexpand: true,
          valign: Align.CENTER,
        }),
      ],
      spacing: 8,
      visible: data.as((d) => d.visible),
    });
  } else {
    return Widget.Box({
      children: [
        Widget.Label({
          label: data.icon,
          classNames: ["icon", "dim"],
          widthRequest: 16,
        }),
        Widget.ProgressBar({
          value: data.progress,
          hexpand: true,
          valign: Align.CENTER,
        }),
      ],
      spacing: 8,
      visible: data.visible,
    });
  }
}

/** Returns an icon from a list based on a percentage from 0 to 100 (not 0 to 1!) */
export function percentageToIconFromList(percentage: number, icons: string[]) {
  const listLength = icons.length;
  const index = Math.min(
    listLength - 1,
    Math.floor((listLength * percentage) / 100),
  );
  return icons[index];
}

export function trunc(s: string, n = 32) {
  return s.length > n ? s.slice(0, n) + "…" : s;
}
