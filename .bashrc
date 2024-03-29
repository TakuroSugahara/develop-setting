
#bashの設定
alias mkal="vim ~/.bashrc"
alias ldbash="source ~/.bash_profile"

#gitの設定
alias gs='git status'
alias ga="git add"
alias gc="git commit -m"
alias gps="git push origin HEAD"
alias gpl="git pull origin"
alias gplm="git pull origin master"
alias gpsm="git push origin master"
alias gck="git checkout"
alias gb="git branch"
alias gdl="git push --delete"
alias gd="git diff"
alias gdd="git difftool"
alias gl="git log --graph --oneline --decorate=full"
alias ggraph="git log --graph"
alias gst="git stash"

# 辞書を開く
dict () { open dict:///"$1" ; }

#コマンドの設定
alias his="history"
alias hg="his | grep"

#phpの設定
alias lp="php -S localhost:8080"

# 翻訳機能
alias trans="trans -b"

alias line="open ~/../../Applications/LINE.app"

alias ll="ls -la"

alias ..="cd .."

# docker設定
alias dp="docker ps"
alias dpa="dp -a"
alias dst="docker start"
alias dsp="docker stop"

export DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer"

# gitで保管できるようにする
source /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash

# vimでclipboardにcopyできるようにする
# https://qiita.com/cawpea/items/3ca4ab80fc465d8eed7e
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
export MANPATH=/opt/local/man:$MANPATH

# fzf setting {{{
# git checkout
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
fgb() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}
# git log
fgl() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}
# enterでpreview
# ctrl-uでgit add
fgs() {
  modified_files=$(git status --short | awk '{print $2}') &&
  selected_files=$(echo "$modified_files" | fzf -m --preview 'git diff --color {}') &&
  git add $selected_files
}
# }
function cd() {
    if [[ "$#" != 0 ]]; then
        builtin cd "$@";
        return
    fi
    while true; do
        local lsd=$(echo ".." && ls -p | grep '/$' | sed 's;/$;;')
        local dir="$(printf '%s\n' "${lsd[@]}" |
            fzf --reverse --preview '
                __cd_nxt="$(echo {})";
                __cd_path="$(echo $(pwd)/${__cd_nxt} | sed "s;//;/;")";
                echo $__cd_path;
                echo;
                ls -p --color=always "${__cd_path}";
        ')"
        [[ ${#dir} != 0 ]] || return 0
        builtin cd "$dir" &> /dev/null
    done
}

