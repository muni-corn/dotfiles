for file in $argv
    if ! test -f $file
        echo "skipping '$file': not a file"
        continue
    end

    set -l basename (path basename $file)
    if string match -q --regex "^\d{4}_\d{2}_\d{2}__" $basename
        echo "skipping '$file': already prefixed with date"
        continue
    end

    set -l cdate (stat -L -c %W $file) # creation date (can be 0 if unknown)
    set -l mdate (stat -L -c %Y $file) # modification date

    # get the earliest of the two dates, or just mdate if cdate is unknown
    set -l earliest_date $cdate
    if test $cdate -eq 0 -o $mdate -le $cdate
        set earliest_date $mdate
    end

    set -l formatted_date (date --date="@$earliest_date" +%Y_%m_%d)

    set -l dirname (path dirname $file)
    set -l new_basename {$formatted_date}__$basename
    set -l new_name "$dirname/$new_basename"

    mv -v $file $new_name
end
