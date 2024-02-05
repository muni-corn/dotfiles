# Integration with nnn:
#   1. Export the required config:
#         export NNN_OPENER=/absolute/path/to/nuke
#         # Otherwise, if nuke is in $PATH
#         # export NNN_OPENER=nuke
#   2. Run nnn with the program option to indicate a CLI opener
#         nnn -c
#         # The -c program option overrides option -e
#   3. nuke can use nnn plugins (e.g. mocq is used for audio), $PATH is updated.
#
# Details:
#   Inspired by ranger's scope.sh, modified for usage with nnn.
#
#   Guards against accidentally opening mime types like executables, shared libs etc.
#
#   Tries to play 'file' (1st argument) in the following order:
#     1. by extension
#     2. by mime (image, video, audio, pdf)
#     3. by mime (other file types)
#     4. by mime (prompt and run executables)
#
# Modification tips:
#   1. Invokes CLI utilities by default. Set GUI to 1 to enable GUI apps.
#   2. PAGER is "less -R".
#   3. Start GUI apps in bg to unblock. Redirect stdout and strerr if required.
#   4. Some CLI utilities are piped to the $PAGER, to wait and quit uniformly.
#   5. If the output cannot be paged use "read -r _" to wait for user input.
#   6. On a DE, try 'xdg-open' or 'open' in handle_fallback() as last resort.
#
#   Feel free to change the utilities to your favourites and add more mimes.
#
# TODO:
#   1. Adapt, test and enable all mimes
#   2. Clean-up the unnecessary exit codes

# set GUI to 1 to enable GUI apps and/or BIN execution
if not set -q GUI
    set GUI 1
end
if not set -q BIN
    set BIN 0
end

# set more default variables
if not set -q TMPDIR
    set TMPDIR /tmp
end
if not set -q XDG_CONFIG_HOME
    set XDG_CONFIG_HOME $HOME/.config
end

# unsure if there's a fish equivalent
# set -euf -o noclobber -o noglob -o nounset

set PATH $PATH $XDG_CONFIG_HOME/nnn/plugins
set image_cache_path "$(dirname $argv[1])/.thumbs"

set file_path $argv[1]
set filename (basename $argv[1])
set ext (string lower (path extension $filename))

function handle_pdf
    if test "$GUI" -ne 0
        if type zathura
            nohup zathura $file_path & disown
        else
            return
        end
    else if type pdftotext
        # preview as text conversion
        pdftotext -l 10 -nopgbrk -q -- $file_path - | $PAGER
    else if type mutool
        mutool draw -F txt -i -- $file_path 1-10 | $PAGER
    else if type exiftool
        exiftool $file_path | $PAGER
    else
        return
    end &> /dev/null
    exit 0
end


function handle_audio
    if type mocp
        and type mocq
        mocq $file_path "opener"
    else if type mpv
        mpv $file_path & disown
    else if type media_client
        media_client play $file_path & disown
    else if type mediainfo
        mediainfo $file_path | $PAGER
    else if type exiftool
        exiftool $file_path| $PAGER
    else
        return
    end &> /dev/null
    exit 0
end

function handle_video
    if test "$GUI" -ne 0
        if type smplayer
            nohup smplayer $file_path & disown
        else if type mpv
            nohup mpv $file_path & disown
        else
            return
        end
    else if type ffmpegthumbnailer
        # make thumbnail
        test -d $image_cache_path
        or mkdir $image_cache_path

        ffmpegthumbnailer -i $file_path -o $image_cache_path/$filename.jpg -s 0
        viu -n $image_cache_path/$filename.jpg | $PAGER
    else if type mediainfo
        mediainfo $file_path | $PAGER
    else if type exiftool
        exiftool $file_path | $PAGER
    else
        return
    end &> /dev/null
    exit 0
end

# handle an extension and exit
function handle_extension
    switch $ext
        # Archive
    case a ace alz arc arj bz bz2 cab cpio deb gz jar lha lz lzh lzma lzo rpm rz t7z tar tbz tbz2 tgz tlz txz tz tzo war xpi xz z zip
        if type atool
            atool --list -- $file_path | $PAGER
            exit 0
        else if type bsdtar
            bsdtar --list --file $file_path | $PAGER
            exit 0
        end
        exit 1
    case rar
        if type unrar
            # Avoid password prompt by providing empty password
            unrar lt -p- -- $file_path | $PAGER
            exit 0
        end
        exit 1
    case 7z
        if type 7z
            # Avoid password prompt by providing empty password
            7z l -p -- $file_path | $PAGER
            exit 0
        end
        exit 1

        # PDF
    case pdf
        handle_pdf
        exit 1

        # Audio
    case aac flac m4a mid midi mpa mp2 mp3 ogg wav wma
        handle_audio
        exit 1

        # Video
    case avi mkv mp4
        handle_video
        exit 1

        # Log files
    case log
        $EDITOR $file_path
        exit 0

        # BitTorrent
    case torrent
        if type rtorrent
            rtorrent $file_path
            exit 0
        else if type transmission-show
            transmission-show -- $file_path
            exit 0
        end
        exit 1

        # OpenDocument
    case odt ods odp sxw
        if type odt2txt
            # Preview as text conversion
            odt2txt $file_path | $PAGER
            exit 0
        end
        exit 1

        # Markdown
    case md
        if type glow
            glow -sdark $file_path | $PAGER
            exit 0
        else if type lowdown
            lowdown -Tterm $file_path | $PAGER
            exit 0
        end

        # Neorg
    case norg
        $EDITOR $file_path
        exit 0

        # HTML
    case htm html xhtml
        # Preview as text conversion
        if type w3m
            w3m -dump $file_path | $PAGER
            exit 0
        else if type lynx
            lynx -dump -- $file_path | $PAGER
            exit 0
        else if type elinks
            elinks -dump $file_path | $PAGER
            exit 0
        end

    case json
        # JSON
        if type jq
            jq --color-output . $file_path | $PAGER
            exit 0
        else if type python
            python -m json.tool -- $file_path | $PAGER
            exit 0
        end
    end &> /dev/null
end

# storing the result to a tmp file is faster than calling populate_image_list twice
function populate_image_list -a img_file
    fd -0 -L -d1 -t file -t symlink "\.(jpe?g|png|gif|webp|tiff|bmp|ico|svg)\$" (path dirname $img_file) | sort -z | tee "$tmp"
end

function load_img_dir -a program img_file
    set abs_path (realpath -s $img_file)
    set tmp $TMPDIR/nuke_{$fish_pid}
    trap "rm -f $tmp" EXIT
    set count (populate_image_list "$abs_path" | grep -a -m 1 -ZznF "$abs_path" | cut -d: -f1)

    if test -n $count
        if test $GUI -ne 0
            xargs -0 nohup $program -n $count -- < $tmp
        else
            xargs -0 $program -n $count -- < $tmp
        end
    else
        set program $img_file
        $program -- $argv[3..-1] # fallback
    end
end

function handle_multimedia -a mimetype
    switch $mimetype
        # Image
        case 'image/*'
            if test "$GUI" -ne 0
                if type imv
                    load_img_dir imv $file_path & disown
                    exit 0
                else if type imvr
                    load_img_dir imvr $file_path & disown
                    exit 0
                else if type sxiv
                    load_img_dir sxiv $file_path & disown
                    exit 0
                else if type nsxiv
                    load_img_dir nsxiv $file_path & disown
                    exit 0
                end
            else if type viu
                viu -n $file_path | $PAGER
                exit 0
            else if type img2txt
                img2txt --gamma=0.6 -- $file_path | $PAGER
                exit 0
            else if type exiftool
                exiftool $file_path | $PAGER
                exit 0
            end
            exit 7

        # PDF
        case application/pdf
            handle_pdf
            exit 1

        # Audio
        case 'audio/*'
            handle_audio
            exit 1

        # Video
        case 'video/*'
            handle_video
            exit 1
    end &> /dev/null
end

function handle_mime
    set mimetype $argv[1]
    switch $mimetype
        # Manpages
        case text/troff
            man -l $file_path
            exit 0

        # Text
        case 'text/*' '*/xml'
            "$EDITOR" $file_path
            exit 0

        # DjVu
        case image/vnd.djvu
            if type djvutxt
                # Preview as text conversion (requires djvulibre)
                djvutxt $file_path | $PAGER
                exit 0
            else if type exiftool
                exiftool $file_path | $PAGER
                exit 0
            end
            exit 1
    end &> /dev/null
end

function handle_fallback
    if test "$GUI" -ne 0
        if type xdg-open
            nohup xdg-open $file_path & disown
            exit 0
        else if type open
            nohup open $file_path & disown
            exit 0
        end
    end &> /dev/null

    echo '----- File details -----'
    file --dereference --brief -- $file_path
    exit 1
end

function handle_blocked
    switch $mimetype
        case application/x-sharedlib application/x-shared-library-la application/x-executable application/x-shellscript application/octet-stream
            exit 0
    end
end

function handle_bin
    switch $mimetype
        case application/x-executable application/x-shellscript
            clear
            echo '-------- Executable File --------'
            file --dereference --brief -- $file_path
            printf "Run executable (y/N/'a'rgs)? "
            read -r answer
            switch "$answer"
                case '[Yy]*'
                    exec $file_path
                case '[Aa]*'
                    printf "args: "
                    read -r args
                    exec $file_path "$args"
                case '[Nn]*'
                    exit
            end
    end
end

# get mimetype first
set mimetype (file -bL --mime-type -- $file_path)

handle_extension
handle_multimedia $mimetype
handle_mime $mimetype
test $BIN -ne 0
and test -x $file_path
and handle_bin
handle_blocked $mimetype
handle_fallback

exit 1
