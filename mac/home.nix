{
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
      LaunchAgents."alurm.tiddlywiki.plist" = ''
        <?xml version="1.0" encoding="utf-8"?>
        <plist version="1.0">
        <dict>

        <key>Label</key>
        <string>alurm.tiddlywiki</string>

        <key>KeepAlive</key> <true/>

        <key>ProgramArguments</key>
        <array>
        	<string>/bin/sh</string>
        	<string>-c</string>
        	<string>-l</string>
        	<string>
        		cd ~/Desktop/Syncthing/TiddlyWiki &amp;&amp; exec tiddlywiki --listen
        	</string>
        </array>

        </dict>
        </plist>
      '';

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

    ".config" = {
      git = {
        config = ''
          [init]
          defaultBranch = main

          [user]
          name = ${full-name}
          email = ${email}
        '';
        ignore = ''
          .DS_Store
        '';
      };

      jj."config.toml" = ''
        "$schema" = "https://jj-vcs.github.io/jj/latest/config-schema.json"

        [user]
        name = "${full-name}"
        email = "${email}"

        [ui]
        diff-editor = ":builtin"
        default-command = ["log", "-r", "all()"]

        [git]
        colocate = true
      '';

      fish = {
        functions."fish_prompt.fish" = ''
          function fish_prompt
            echo
            echo
          end
        '';

        "config.fish" = ''
          if status is-login
            # To-do: this should be somewhere else?
            set --export fish_greeting '''

            set --export EDITOR ed
            set --export --prepend PATH ~/.nix-profile/bin
            set --export PLAN9 ~/Desktop/System/plan9port
            # Use the default MacOS monospace font.
            set --export font /mnt/font/Menlo-Regular/15a/font
            set --export --append PATH \
              '/Applications/Visual Studio Code.app/Contents/Resources/app/bin' \
              /Applications/Emacs.app/Contents/MacOS \
              $PLAN9/bin \
              ~/go/bin \
            ;

            # Plan 9

            set --export prompt \n

            # End of Plan 9

            if status is-interactive
              if test $SHLVL = 1 && test "$(pwd)" = ~
                cd Desktop
              end
            end
          end
        '';
      };

      direnv.direnvrc = ''
        source ~/.nix-profile/share/nix-direnv/direnvrc
      '';

      helix = {
        "config.toml" = ''
          theme = "vim_dark_high_contrast"

          [editor]
          auto-pairs = false
          insert-final-newline = false

          [editor.file-picker]
          hidden = false

          [editor.soft-wrap]
          enable = true
        '';

        "languages.toml" = ''
          [language-server.rust-analyzer.config]
          check.command = "clippy"
        '';
      };
    };
  }
]
