pkgs: {
  functions."fish_prompt.fish" = ''
    function fish_prompt
      echo
      echo
    end
  '';

  "config.fish" =
    let
      plan9 = ''
        # Plan 9 configuration

        set --export PLAN9 ~/Desktop/System/plan9port

        # Use the default MacOS monospace font.
        set --export font /mnt/font/Menlo-Regular/15a/font

        set --export prompt \n

        # End of Plan 9 configuration
      '';

      # Keep this in case I want to use Ki.
      ki-editor = ''
        # Ki Editor configuration
        
        set --export KI_EDITOR_THEME 'Mqual Blue'

        # End of Ki Editor configuration
      '';
    in
    ''
      if status is-login
        if [ "$(pwd)" = ~ ]
          cd ~/My
        end

        # To-do: should this be set somehow differently?
        set --export fish_greeting '''

        set --export EDITOR hx

        ${ki-editor}

        ${plan9}

        # Set somewhere else, apparently, not needed.
        # set --export --prepend PATH ~/.nix-profile/bin

        set --export --append PATH \
          '/Applications/Visual Studio Code.app/Contents/Resources/app/bin' \
          /Applications/Emacs.app/Contents/MacOS \
          $PLAN9/bin \
          ~/go/bin \
          ${pkgs.nodePackages.tiddlywiki}/bin \
        ;
      end
    '';
}
