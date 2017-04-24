# DANG Shell Presentation

Repository of example data and an outline for DANG presentation on being
productive on the command line.

Topics will probably include: shell scripting, piping, for-loops, unix tools
(some subset of of awk, sed, grep, cut, sort, etc.), useful additions (~tmux~
edit: not available on Windows),
and keyboard shortcuts.

## Rebuilding the data

`make_data.sh` is meant to rebuild the data from scratch, but it has not been
tested.

If it actually works, then the following software must be available in your
PATH to run:

-   diamond
-   seqtk

## Outline

### Instructor env setup

-   `for dotfile in ~/.{bashrc,bashrc_local,bashrc,bash_aliases,tmux.conf}; do mv $dotfile ${dotfile}~; done`
-   Restart shell
-   PS1='$ '

### Get data ready and check it out (et: 5)

-   Navigate to https://github.com/bsmith89/dang-shell
-   Select "Clone or Download" -> "Download Zip"
-   (TD) using the shell, unzip the data directory on the desktop and navigate
    into it
-   (TD) think/pair/share what tricks you used (or could have used) to make
    that process easier
    -   tab completion
    -   `~` for home
    -   relative paths
-   Check out the example data: `ls seq/ res/`,
    `less seq/mouse.sample-01.human-blastp.tsv`
    -   `less`!
-   Talk about context switching: make conscious effort to avoid, if possible

### Explore the data (et: 3)

-   `wc -l res/mouse.sample-01.human-blastp.tsv`
-   `<M-.>` for final argument history
-   `head res/mouse.sample-01.human-blastp.tsv`
-   Describe relevant columns.

### How many different query sequences? (et: 10)

-   `cut -f 1 res/mouse.sample-01.human-blastp.tsv > res/mouse.sample-01.human-blastp.col-1.list`
-   `sort < res/mouse.sample-01.human-blastp.col-1.list > res/mouse.sample-01.human-blastp.col-1.sorted.list`
-   `uniq res/mouse.sample-01.human-blastp.col-1.sorted.list > res/mouse.sample-01.human-blastp.col-1.sorted.list > res/mouse.sample-01.human-blastp.col-1.sorted.uniq.list`
-   `wc -l res/mouse.sample-01.human-blastp.col-1.sorted.uniq.list`
-   Remember `<M-.>`
-   Pipe everything together
    -   `cut -f 1 res/mouse.sample-01.human-blastp.tsv | sort | uniq | wc -l`
-   (TD) Think/pair/share What are the pros/cons of the piping approach?
-   (?) How would we count the number of unique references hit in sample-01?
-   Up arrow for history.
-   (TD) Count the number of unique query sequences in sample-02?

### Put our command into a script (et: 5)

-   `nano scripts/count_uniq_queries.sh`
-   (?) What's wrong with `cut -f 1 res/mouse.sample-01.human-blastp.tsv | sort | uniq | wc -l`?
-   `cut -f 1 $1 | sort | uniq | wc -l`
-   `<C-x>` -> `Y` -> `<CR>` (to exit nano and save the file).
-   `bash scripts/count_uniq_queries.sh res/mouse.sample-01.human-blastp.tsv`
-   Add documentation (and a shebang?)

### Repeat our command for all of the samples (et: 5)

-   (?) What's wrong with typing it out for each file?
-   `for file in res/mouse.sample*.human-blastp.tsv; do bash scripts/count_uniq_queries.sh $file; done`
-   Keyboard shortcuts:
    -   `<C-r>`, `<M-b>`, `<M-f>`, `<M-d>`, etc.

### Filtering low identity hits (et: 5)

-   (TD) T/P/S What's challenging about filtering your data using Excel?
-   Only hits that had higher than 90% identity:
    `awk '$3 > 90' res/mouse.sample-01.human-blastp.tsv | head`
-   (?) How would we filter for bitscores over 500?
-   NOTE: It is not trivial to use this new, filtered data as input to our
    counting script:
    -   We could save the output to a new file `*.hits.tsv`.
    -   We could change our script to accept standard input (`<&0`).
    -   Or we could redirect the output to a temporary file:
        `bash scripts/count_uniq_queries.sh <(awk '$3 > 90' res/mouse.sample-01.human-blastp.tsv)`

### Pulling sequences with grep (and sed) (et: 10)

-   `less ref/human.fa`
-   Notice that we have only one sequence per line (this is _super_ helpful,
    FASTA format is not so great)
-   `grep 'FER' seq/mouse.sample-01.fa | wc -l`
-   `grep -B1 'FER' seq/mouse.sample-01.fa | wc -l`
-   `grep -B1 'FER' seq/mouse.sample-01.fa | less`
-   `grep -B1 'FER' seq/mouse.sample-01.fa | sed '/^--$/d' | wc -l`
-   (TD) Pull sequences from all of the samples which include the '`FER`' motif and
    save them to a file.

### Summary of what we covered (et: 5)

### Questions?

### Stay after for TMUX?
