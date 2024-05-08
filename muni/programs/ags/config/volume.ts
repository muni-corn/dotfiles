import { Align } from "types/@girs/gtk-3.0/gtk-3.0.cjs";
import { ProgressTile, makeProgressTile } from "utils";

const audio = await Service.import("audio");

const VOLUME_ICONS = ["\u{F057F}", "\u{F0580}", "\u{F057E}"];
const MUTE_ICON = "\u{F0581}";
const ZERO_ICON = "\u{F0E08}";

export function Volume() {
  function getIcon() {
    if (audio.speaker.is_muted?.valueOf()) {
      return MUTE_ICON;
    } else if (audio.speaker.volume.valueOf() === 0) {
      return ZERO_ICON;
    } else {
      let index = Math.floor(
        audio.speaker.volume.valueOf() * VOLUME_ICONS.length,
      );
      return VOLUME_ICONS[Math.min(index, VOLUME_ICONS.length - 1)];
    }
  }

  function getProgressTile(): ProgressTile {
    return {
      icon: getIcon(),
      progress: audio.speaker.volume || 0,
      visible: true,
    };
  }

  const watcher = Utils.watch(
    getProgressTile(),
    audio.speaker,
    getProgressTile,
  );

  return makeProgressTile(watcher);
}

export {};
