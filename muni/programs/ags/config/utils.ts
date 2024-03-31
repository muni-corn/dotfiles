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
