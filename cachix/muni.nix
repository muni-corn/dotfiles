{...}: {
  nix.settings = {
    substituters = ["https://municorn.cachix.org"];
    trusted-public-keys = ["municorn.cachix.org-1:o41vsB5U8BWCqjHaj8D9DpK+8BKwBgGotT5mr85t1s0="];
  };
}
