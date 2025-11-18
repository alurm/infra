my @ {
  pkgs,
  lib,
  enquote,
  enpath,
  
  username,
  full-name,
  email,
  system-dir,
}: builtins.foldl' lib.recursiveUpdate {} [
  (
    lib.setAttrByPath (
      system-dir ++ [ "plan9port" "mac" "9term.app" "Contents" "MacOS" "9term" ]
    ) [ "script" ''
      #!/usr/bin/env -S ''${SHELL} -l
      export NO_COLOR=1
      export PAGER=cat

      # I haven't found a saner way to do this without using "open".
      # Without having trouble with permissions, that is.
      exec \
      open \
      -a \
      /Users/${enquote username}/${enpath system-dir}/plan9port/bin/9term \
      --args \
      rc \
      -l \
      ;
    '' ]
  )
  {
    lib.profile = ''
      # Otherwise 9term.app seems to set it to the login shell for some reason.
      SHELL = rc
      cd $home/Desktop
    '';

    Library = {
      LaunchAgents = let
        make-service = { name, script }: {
          "${name}.plist" = ''
            <?xml version="1.0" encoding="utf-8"?>
            <plist version="1.0">
              <dict>
                <key>Label</key>
                <string>${lib.escapeXML name}</string>

                <key>KeepAlive</key>
                <true/>

                <key>ProgramArguments</key>
                <array>
                  <string>/usr/local/bin/fish</string>
                  <string>-l</string>
                  <string>-c</string>
                  <string>
                    ${lib.escapeXML script}
                  </string>
                </array>
              </dict>
            </plist>
          '';
        };
      in {}
        // make-service {
          name = "alurm.tiddlywiki.main";
          script = ''
            cd ~/Desktop/Syncthing/TiddlyWikis/Main &&
            exec \
            ${pkgs.nodePackages.tiddlywiki}/bin/tiddlywiki \
            --listen port=8080 host=127.0.0.1
          '';
        }
        // make-service {
          name = "alurm.tiddlywiki.webdav";
          script = ''
            cd ~/Desktop/Syncthing/TiddlyWikis/Webdav &&
            exec rclone serve webdav . --addr=127.0.0.1:8081
          '';
        }
	// make-service {
	  name = "alurm.macos.keyboard.caps.delay.disable";
	  script = ''
	    exec hidutil property set '{"CapsLockDelayOverride": 0}'
	  '';
	}
      ;

      "Application Support"."com.mitchellh.ghostty".config = ''
        cursor-style = bar

        cursor-style-blink = false

        shell-integration-features = no-cursor

        # It's not obvious how to do maximized properly at the moment.
        window-save-state = always

        macos-option-as-alt = true

        theme = Dark+
      '';
    };

    ".sqliterc" = ''
      .mode box
    '';

    ".hushlogin" = "";

    ".config" = import ./config my;
  }
]
