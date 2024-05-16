import { Media } from "mpris";
import { Clock } from "clock";
import { Volume } from "volume";
import { Weather } from "weather/index";
import { Battery } from "battery";
import { Bluetooth } from "bluetooth";
import { Network } from "network";

const hyprland = await Service.import("hyprland");
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

const MAX_CLIENT_TITLE_LENGTH = 48;
function ClientTitle(monitor: number) {
  return Widget.Label({
    classNames: ["secondary", "client-title"],
    label: hyprland.bind("active").as((active) => {
      if (active.monitor.id === monitor) {
        let title = active.client.title;
        if (title.length > MAX_CLIENT_TITLE_LENGTH)
          title = title.slice(0, MAX_CLIENT_TITLE_LENGTH) + "…";
        return title;
      } else return "";
    }),
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
    spacing: 20,
    children: [Workspaces(monitor), ClientTitle(monitor)],
  });
}

function Center() {
  return Widget.Box({
    spacing: 20,
    children: [Clock(), Weather(), Media()],
  });
}

function Right() {
  return Widget.Box({
    hpack: "end",
    spacing: 20,
    children: [Volume(), Bluetooth(), Network(), Battery(), SysTray()],
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
      spacing: 40,
    }),
  });
}

const windows = [Bar(0)];
for (let i = 1; i < hyprland.monitors.length; i++) {
  windows.push(Bar(i));
}

App.config({
  style: "./style.css",
  windows,
});

export {};
