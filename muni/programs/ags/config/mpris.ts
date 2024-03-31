import { makeTile } from "utils";

const mpris = await Service.import("mpris");

const MPRIS_PLAYING_ICON = "\u{F0F74}";
const MPRIS_PAUSED_ICON = "\u{F03E4}";

export function Media() {
  const fallback = {
    icon: MPRIS_PAUSED_ICON,
    primary: "Nothing is playing",
    secondary: "",
    visible: false,
  };

  const label = Utils.watch(fallback, mpris, "changed", () => {
    if (mpris.players[0]) {
      const { play_back_status, track_artists, track_title } = mpris.players[0];
      return {
        icon:
          play_back_status === "Playing"
            ? MPRIS_PLAYING_ICON
            : MPRIS_PAUSED_ICON,
        primary: track_title || `Media is ${play_back_status.toLowerCase()}`,
        secondary: track_artists.join(", ") || "",
        visible: play_back_status !== "Stopped",
      };
    } else {
      return fallback;
    }
  });

  return makeTile(label);
}

export {};
