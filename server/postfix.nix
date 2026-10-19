{
  # local mail relay for nextcloud and peertube notifications
  services.postfix = {
    enable = true;
    settings.main.myhostname = "mail.musicaloft.com";
  };
}
