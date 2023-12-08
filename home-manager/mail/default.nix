{ pkgs
, config
, lib
, ...
}:

let
  enable = false;
  home = config.home.homeDirectory;
  # op = "${pkgs._1password}/bin/op";
  pass = "${pkgs.pass}/bin/pass";
  gpg = {
    key = "5261CBAC6980ED7219A373BCA9E68F266CC3879D";
    signByDefault = true;
  };
in
{
  programs = {
    mbsync.enable = enable;
    msmtp.enable = enable;
    mu.enable = enable;
    notmuch = {
      enable = enable;
      hooks = {
        preNew = "mbsync --all";
        postNew = ''
          notmuch tag +uchicago "path:uchicago/** AND tag:new"
          notmuch tag +rs "path:rs/** AND tag:new"
          notmuch tag +raydreww "path:raydreww/** AND tag:new"
          notmuch tag -new "tag:new"
          afew --tag --new
          afew --move-mails
        '';
      };
    };
    afew = {
      enable = enable;
      extraConfig = ''
        [SpamFilter]
        [KillThreadsFilter]
        [ListMailsFilter]
        [SentMailsFilter]
        sent_tag = sent
        [ArchiveSentMailsFilter]
        [MeFilter]
        me_tag = me

        [Filter.1]
        message = Tagging inbox
        query = folder:"/^.*/Inbox$/" AND not tag:inbox
        tags = +inbox;-archived

        [Filter.2]
        message = Tagging Archive
        query = folder:"/^.*/Archive$/"
        tags = +archived

        [Filter.3]
        message = Tagging Trash
        query = folder:"/^.*/Trash$/"
        tags = +deleted;-archived

        [Filter.4]
        message = Tagging Facebook
        query = from:facebookmail.com
        tags = +facebook;+unread;-new

        [Filter.5]
        message = Tagging UCARE
        query = from:ucare-* OR to:ucare-*
        tags = +ucare;+unread;-new

        [Filter.6]
        message = Tagging Haryadi
        query = from:haryadi*
        tags = +haryadi;+unread;-new

        [Filter.7]
        message = Tagging PDFs
        query = mimetype:application/pdf
        tags = +pdf

        [Filter.8]
        message = Tagging patches
        query = miwmetype:text/x-patch
        tags = +patch

        [Filter.9]
        message = Tagging Important
        query = folder:"/^.*/Important$/"
        tags = +important

        [Filter.10]
        message = Tagging CS230
        query = CS230
        tags = +cs230;+teaching

        [InboxFilter]

        [HeaderMatchingFilter]
        header = X-Forefront-Antispam-Report
        pattern = SFV:SPM
        tags = +spam; -new

        [HeaderMatchingFilter.1]
        header = X-Microsoft-Antispam
        pattern = BCL:[456789]
        tags = +spam; -new

        [HeaderMatchingFilter.2]
        header = X-Forefront-Antispam-Report
        pattern = SCL:[569]
        tags = +spam; -new

        [MailMover]
        folders = raydreww/Inbox raydreww/[Gmail]/Trash raydreww/[Gmail]/Spam raydreww/[Gmail]/Teaching raydreww/Important uchicago/Inbox uchicago/Trash uchicago/Important uchicago/Teaching rs/Inbox rs/Trash rs/Important rs/Spam
        rename = True
        max_age = 15

        # rules
        raydreww/Inbox = 'tag:spam':raydreww/[Gmail]/Spam 'tag:archived':raydreww/Archive 'tag:important':raydreww/Important 'tag:deleted':raydreww/[Gmail]/Trash 'tag:teaching':raydreww/[Gmail]/Teaching
        raydreww/Important = 'tag:archived':raydreww/Archive
        raydreww/[Gmail]/Spam = 'NOT tag:spam':raydreww/Inbox
        raydreww/[Gmail]/Trash = 'NOT tag:deleted':raydreww/Inbox
        raydreww/[Gmail]/Teaching = 'NOT tag:teaching':raydreww/Inbox

        uchicago/Inbox = 'tag:spam':uchicago/Junk 'tag:archived':uchicago/Archive 'tag:important':uchicago/Important 'tag:deleted':uchicago/Trash 'tag:teaching':uchicago/Teaching
        uchicago/Important = 'tag:archived':uchicago/Archive
        uchicago/Junk = 'NOT tag:spam':uchicago/Inbox
        uchicago/Trash = 'NOT tag:deleted':uchicago/Inbox
        uchicago/Teaching = 'NOT tag:teaching': uchicago/Inbox

        rs/Inbox = 'tag:spam':rs/Spam 'tag:archived':rs/Archive 'tag:important':rs/Important 'tag:deleted':rs/Trash
        rs/Important = 'tag:archived':rs/Archive
        rs/Spam = 'NOT tag:spam':rs/Inbox
        rs/Trash = 'NOT tag:deleted':rs/Inbox
      '';
    };
  };
  accounts.email = {
    maildirBasePath = "${home}/.mail";
    accounts = {
      rs = {
        inherit gpg;
        primary = true;
        realName = "Ray Sinurat";
        userName = "rs@rs.ht";
        address = "rs@rs.ht";
        # passwordCommand = "${op} item get rs@rs.ht --fields \"app password\"";
        passwordCommand = "${pass} show rs-rs-ht-app-password";
        imap = {
          host = "imappro.zoho.com";
          port = 993;
          tls = {
            enable = enable;
          };
        };
        smtp = {
          host = "smtppro.zoho.com";
          port = 465;
          tls = {
            enable = true;
          };
        };
        mbsync = {
          enable = enable;
          create = "both";
        };
        msmtp.enable = enable;
        notmuch.enable = enable;
        aerc.enable = enable;
        mu.enable = enable;
      };
      raydreww = {
        inherit gpg;
        realName = "Ray Andrew";
        address = "raydreww@gmail.com";
        flavor = "gmail.com";
        # passwordCommand = "${op} item get g-raydreww --fields app-password";
        passwordCommand = "${pass} show g-raydreww-app-password";
        mbsync = {
          enable = enable;
          create = "both";
          extraConfig = {
            account = {
              AuthMechs = "LOGIN";
            };
          };
        };
        msmtp.enable = enable;
        notmuch.enable = enable;
        aerc.enable = enable;
        mu.enable = enable;
      };
      uchicago = {
        inherit gpg;
        realName = "Ray Andrew";
        userName = "rayandrew@uchicago.edu";
        address = "rayandrew@uchicago.edu";
        # passwordCommand = "${op} item get Uchicago --fields password";
        passwordCommand = "${pass} show uchicago";
        imap = {
          host = "127.0.0.1";
          port = 1143;
          tls = {
            enable = false;
          };
        };
        smtp = {
          host = "127.0.0.1";
          port = 1025;
          tls = {
            enable = false;
            # useStartTls = true;
          };
        };
        mbsync = {
          enable = enable;
          create = "both";
          extraConfig = {
            account = {
              AuthMechs = "LOGIN";
            };
          };
        };
        msmtp = {
          enable = enable;
          extraConfig = {
            auth = "plain";
          };
        };
        notmuch.enable = enable;
        aerc.enable = enable;
        mu.enable = enable;
      };
    };
  };
}
