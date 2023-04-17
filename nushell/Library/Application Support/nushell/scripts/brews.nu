# Script to list all installed brew formulae and casks
# Author: @oren-s-weiss
# Source: https://discord.com/channels/601130461678272522/814945974761947168/1097308007630647607
# Updated: change export def brews to export def main

export def main [] {
    let formulae = (
        brew leaves | str join | lines
        | brew deps ($in) --installed --for-each | str join | lines
        | split column ':'
        | rename formula deps
    )
    let casks = (
        brew list --cask | str join | lines
        | split column '|' 
        | rename casks
    )
    print $formulae;
    print $casks
}
