if [ -f $HOME/.config/fish/colors.fish ]
    source $HOME/.config/fish/colors.fish
end > /dev/null

if [ -f $HOME/.config/fish/private.fish ]
    source $HOME/.config/fish/private.fish
end > /dev/null

set fish_greeting ""

function fish_prompt --description 'Write out the prompt'
    set -l color_cwd
    set -l suffix
    switch "$USER"
        case root toor
            if set -q fish_color_cwd_root
                set color_cwd $fish_color_cwd_root
            else
                set color_cwd $fish_color_cwd
            end
            set suffix '#'
        case '*'
            set color_cwd $fish_color_cwd
            set suffix '$'
    end

    echo -n -s (set_color $color_cwd) (prompt_pwd) (set_color normal) ' ' "$suffix "
end

function nohup
    command nohup $argv </dev/null >/dev/null 2>&1 & disown
end

function encrypt
    gpg -c $argv[1] && rm $argv[1]
end

# ??? TODO
# function decrypt
#     gpg -d $argv[1] && rm $argv[1]
# end

function crypt-edit
    if count $argv > /dev/null
        # set temp file
        set temp (mktemp)

        if test -e $argv[1]
            # decrypt the file
            echo "decrypting file..."
            gpg --yes -o $temp -d $argv[1]
        else
            echo "$argv[1] doesn't exist, but we'll create it"
        end

        # edit it, if successful
        and begin
            $EDITOR $temp

            # re-encrypt the file
            echo "encrypting file..."
            gpg --yes -o $argv[1] -c $temp
        end

        # or, don't
        or begin
            echo "file wasn't decrypted successfully, quitting"
            return 1
        end

        # remove decrypted file
        rm -f $temp

        echo "all done!"
    else
        echo "no file given."
    end
end

function encrypt-folder
    set folder (string replace -r '/$' '' $argv[1])
    tar --zstd -cvf $folder.tar.zst $folder
    and gpg -c $folder.tar.zst
    and rm -rf $folder.tar.zst $folder
end

function decrypt-folder
    set folder (string replace -r '/$' '' $argv[1])
    gpg --decrypt-files $folder.tar.zst.gpg
    and tar --same-owner -xpvf $folder.tar.zst
    and rm $folder.tar.zst.gpg $folder.tar.zst
end

function sleep-timer
    set seconds (math "$argv[1] * 60")
    for i in (seq $seconds)
        set left (math $seconds - $i)
        echo -n -e "\r\033[Kgoing to sleep in $left seconds"
        sleep 1
    end
    echo -e "\r\033[Ksweet dreams :)"
    systemctl suspend
    echo -e "\r\033[Kgood morning!"
end

function qr
    set file (mktemp)
    qrencode $argv -o $file
    imv $file
end

function unlock-keychain
    eval (keychain -q --gpg2 --agents "gpg,ssh" --eval id_rsa_github id_rsa_bitbucket id_ed25519 4B21310A52B15162) 2> /dev/null
end

function btrfs-du
    sudo btrfs fi du --si $argv | tee du_full.txt | sort -h | tee du_sorted.txt | tail -n3000 | tee du.txt
end
