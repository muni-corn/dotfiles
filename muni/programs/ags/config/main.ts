import { Media } from "mpris";
import { Clock } from "clock";
import { Volume } from "volume";

const hyprland = await Service.import("hyprland");
const battery = await Service.import("battery");
const network = await Service.import("network");
const systemtray = await Service.import("systemtray");

// widgets can be only assigned as a child in one container
// so to make a reuseable widget, make it a function
// then you can simply instantiate one by calling it

function Workspaces(monitor: number) {
  const activeId = hyprland.active.workspace.bind("id");
  const workspaces = hyprland.bind("workspaces").as((ws) =>
    ws
      .filter(({ id, monitorID }) => id > 0 && monitorID === monitor)
      .sort(({ id: idA }, { id: idB }) => idA - idB)
      .map(({ id }) =>
        Widget.Button({
          on_clicked: () => hyprland.messageAsync(`dispatch workspace ${id}`),
          child: Widget.Label(`${id}`),
          class_name: activeId.as(
            (i) => `${i === id ? "primary" : "secondary"}`,
          ),
        }),
      ),
  );

  return Widget.Box({
    class_name: "workspaces",
    children: workspaces,
  });
}

function ClientTitle(monitor: number) {
  return Widget.Label({
    classNames: ["secondary", "client-title"],
    label: hyprland.bind("active").as((active) => {
      if (active.monitor.id === monitor) {
        return active.client.title;
      } else return "";
    }),
  });
}

function BatteryLabel() {
  const value = battery.bind("percent").as((p) => (p > 0 ? p / 100 : 0));
  const icon = battery
    .bind("percent")
    .as((p) => `battery-level-${Math.floor(p / 10) * 10}-symbolic`);

  return Widget.Box({
    class_name: "battery",
    visible: battery.bind("available"),
    children: [
      Widget.Icon({ icon }),
      Widget.LevelBar({
        widthRequest: 140,
        vpack: "center",
        value,
      }),
    ],
  });
}

function SysTray() {
  const items = systemtray.bind("items").as((items) =>
    items.map((item) =>
      Widget.Button({
        child: Widget.Icon({ icon: item.bind("icon") }),
        on_primary_click: (_, event) => item.activate(event),
        on_secondary_click: (_, event) => item.openMenu(event),
        tooltip_markup: item.bind("tooltip_markup"),
      }),
    ),
  );

  return Widget.Box({
    children: items,
  });
}

// layout of the bar
function Left(monitor: number) {
  return Widget.Box({
    spacing: 32,
    children: [Workspaces(monitor), ClientTitle(monitor)],
  });
}

function Center() {
  return Widget.Box({
    spacing: 32,
    children: [Clock(), Media()],
  });
}

function Right() {
  return Widget.Box({
    hpack: "end",
    spacing: 32,
    children: [Volume(), SysTray()],
  });
}

function Bar(monitor: number) {
  return Widget.Window({
    name: `bar-${monitor}`, // name has to be unique
    class_name: "bar",
    monitor,
    anchor: ["top", "left", "right"],
    exclusivity: "exclusive",
    heightRequest: 32,
    child: Widget.CenterBox({
      start_widget: Left(monitor),
      center_widget: Center(),
      end_widget: Right(),
      spacing: 32,
    }),
  });
}

App.config({
  style: "./style.css",
  windows: [Bar(0), Bar(1), Bar(2)],
});

export {};
