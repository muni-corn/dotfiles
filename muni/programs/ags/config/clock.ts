import { makeTile } from "utils";

const TIME_FORMAT = "%-I:%M %P";
const DATE_FORMAT = "%a, %b %-d";
const CLOCK_ICONS = [
  "\u{F1456}",
  "\u{F144B}",
  "\u{F144C}",
  "\u{F144D}",
  "\u{F144E}",
  "\u{F144F}",
  "\u{F1450}",
  "\u{F1451}",
  "\u{F1452}",
  "\u{F1453}",
  "\u{F1454}",
  "\u{F1455}",
];

const transformer = (out: string) => [
  CLOCK_ICONS[new Date().getHours() % 12],
  ...out.split("/"),
];

const date = Variable([CLOCK_ICONS[0], "Hello", ""], {
  poll: [1000, `date "+${TIME_FORMAT}/${DATE_FORMAT}"`, transformer],
});

export function Clock() {
  return makeTile(
    date.bind().as((x) => ({
      icon: x[0],
      primary: x[1],
      secondary: x[2],
      visible: true,
    })),
  );
}
