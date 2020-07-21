#!/usr/bin/env bash
# Try a different kind of shbang
_hugobin="$HOME/gocode/bin/hugo"
_editbin="/usr/local/bin/nova"
_gitbin="/usr/local/bin/git"
_workingdir="$HOME/dev/logr.cogley.info"
_contentdir="${_workingdir}/content/posts"
_datetime=$(date +'%Y%m%d-%H%M%S')
_hytitle=RC-Logr-${_datetime}

cd "${_workingdir}" || return
${_hugobin} new posts/"${_hytitle}.md"
cd "${_workingdir}" || return
${_gitbin} add ./*
${_gitbin} commit -m "Logr new post ${_datetime}"
${_gitbin} push origin master
${_editbin} "${_contentdir}/${_hytitle}".md
