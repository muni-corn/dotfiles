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
          classNames: ["icon", "primary"],
          widthRequest: 16,
        }),
        Widget.Label({
          label: data.as((d) => d.primary),
          className: "primary",
        }),
        Widget.Label({
          label: data.as((d) => d.secondary),
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
          classNames: ["icon", "primary"],
          widthRequest: 16,
        }),
        Widget.Label({ label: data.primary, className: "primary" }),
        Widget.Label({ label: data.secondary, className: "secondary" }),
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
