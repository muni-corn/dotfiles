set -l cmd $argv[1]
set -l path $argv[2]

# exit if either the command or the path are empty
if test -z "$cmd" -o -z "$path"
    echo "usage: vault {new|unlock|lock} <path>"
    return 1
end

# resolve to absolute path
set -l abs_path (realpath -m $path)

# strip $HOME prefix to get relative dir
set -l dir (string replace -r "^$HOME/" "" $abs_path)

# for pass key, strip .vault and .unlocked extensions
set -l pass_dir (string replace -r '\.(vault|unlocked)$' '' $dir)

switch $cmd
    case n new
        # check if vault already exists
        if test -e "$HOME/$dir.vault"
            echo "error: vault already exists at $HOME/$dir.vault"
            return 1
        end

        # generate password
        pass generate "vaults/$pass_dir" >/dev/null
        and echo "password generated for vault"
        or begin
            echo "couldn't generate password for vault"
            return 2
        end

        # create vault
        gocryptfs -init "$HOME/$dir.vault" -extpass "pass vaults/$pass_dir"

    case u unlock
        # get paths (strip .vault, add .unlocked)
        set -l vault_path $abs_path
        set -l base_path (string replace -r '\.vault$' '' $abs_path)
        set -l unlocked_path "$base_path.unlocked"

        # create unlocked directory
        mkdir -p $unlocked_path

        # mount vault
        gocryptfs $vault_path $unlocked_path -extpass "pass vaults/$pass_dir"

    case l lock
        # determine unlocked path
        set -l unlocked_path

        if string match -q "*.vault" $abs_path
            # strip .vault, add .unlocked
            set -l base_path (string replace -r '\.vault$' '' $abs_path)
            set unlocked_path "$base_path.unlocked"
        else if string match -q "*.unlocked" $abs_path
            # already .unlocked
            set unlocked_path $abs_path
        else
            # no extension, add .unlocked
            set unlocked_path "$abs_path.unlocked"
        end

        # unmount
        umount $unlocked_path

        # remove directory only if empty
        if test -d $unlocked_path
            rmdir -v $unlocked_path 2>/dev/null || echo "warning: unlocked directory wasn't empty after unmount; not removing"
        end

    case '*'
        echo "unknown command: $cmd"
        echo "usage: vault {new|unlock|lock} <path>"
        return 1
end
