{ ... }:
{
  programs.obsidian = {
    enable = true;
    defaultSettings = {
      app = {
        promptDelete = false;
        showUnsupportedFiles = true;
        mobilePullAction = "switcher =open";
        attachmentFolderPath = "./media";
        trashOption = "local";
        alwaysUpdateLinks = true;
        mobileToolbarCommands = [
          "editor:undo"
          "editor:redo"
          "editor:swap-line-up"
          "editor:swap-line-down"
          "editor:insert-wikilink"
          "editor:insert-embed"
          "editor:insert-tag"
          "editor:attach-file"
          "editor:set-heading"
          "editor:toggle-bold"
          "editor:toggle-italics"
          "editor:toggle-strikethrough"
          "editor:toggle-highlight"
          "editor:toggle-code"
          "editor:insert-codeblock"
          "editor:toggle-blockquote"
          "editor:insert-callout"
          "editor:insert-link"
          "editor:toggle-bullet-list"
          "editor:toggle-numbered-list"
          "editor:toggle-checklist-status"
          "editor:indent-list"
          "editor:unindent-list"
          "editor:toggle-comments"
          "editor:insert-horizontal-rule"
          "editor:insert-mathblock"
          "editor:insert-footnote"
          "editor:go-start"
          "editor:go-end"
          "editor:delete-paragraph"
          "insert-current-date"
          "insert-current-time"
          "editor:insert-table"
          "editor:paste"
          "editor:table-row-copy"
          "editor:table-row-delete"
          "editor:table-col-copy"
          "editor:table-col-delete"
          "editor:table-col-align-left"
          "editor:table-col-align-center"
          "editor:table-col-align-right"
          "editor:configure-toolbar"
        ];
      };
      corePlugins = [
        "audio-recorder"
        "backlink"
        "bases"
        "bookmarks"
        "canvas"
        "command-palette"
        "daily-notes"
        "editor-status"
        "file-explorer"
        "file-recovery"
        "global-search"
        "graph"
        "markdown-importer"
        "note-composer"
        "outgoing-link"
        "outline"
        "page-preview"
        "properties"
        "publish"
        "random-note"
        "slash-command"
        "slides"
        "switcher"
        "tag-pane"
        "templates"
        "word-count"
        "zk-prefixer"
      ];
      extraFiles = {
        backlink.source = ./backlink.json;
        canvas.source = ./canvas.json;
        daily-notes.source = ./daily-notes.json;
      };
    };
    vaults.notebook = { };
  };
}
