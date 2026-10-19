{
  # local mail relay for nextcloud and peertube notifications
  services.postfix = {
    enable = true;
    settings.main = {
      myhostname = "mail.musicaloft.com";

      # only local services hand mail to postfix (nextcloud uses
      # 127.0.0.1:25), so don't listen on any other interface
      inet_interfaces = "loopback-only";
    };
  };
}
