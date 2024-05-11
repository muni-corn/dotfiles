import { Align } from "types/@girs/gtk-3.0/gtk-3.0.cjs";
import { Binding } from "types/service";

export interface Tile {
  icon: string;
  primary: string;
  secondary: string;
  visible: boolean;
}

export function makeTile(data: Tile | Binding<any, any, Tile>) {
  if ("as" in data) {
    return Widget.Box({
      children: [
        Widget.Label({
          label: data.as((d) => d.icon),
          visible: data.as((d) => d.icon?.length > 0),
          classNames: ["icon", "primary"],
          widthRequest: 16,
        }),
        Widget.Label({
          label: data.as((d) => d.primary),
          visible: data.as((d) => d.primary.length > 0),
          className: "primary",
        }),
        Widget.Label({
          label: data.as((d) => d.secondary),
          visible: data.as((d) => d.secondary.length > 0),
          className: "secondary",
        }),
      ],
      spacing: 16,
      visible: data.as((d) => d.visible),
    });
  } else {
    return Widget.Box({
      children: [
        Widget.Label({
          label: data.icon,
          visible: data.icon.length > 0,
          classNames: ["icon", "primary"],
          widthRequest: 16,
        }),
        Widget.Label({
          label: data.primary,
          visible: data.primary.length > 0,
          className: "primary",
        }),
        Widget.Label({
          label: data.secondary,
          visible: data.secondary.length > 0,
          className: "secondary",
        }),
      ],
      spacing: 16,
      visible: data.visible,
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
      spacing: 16,
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
      spacing: 16,
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
