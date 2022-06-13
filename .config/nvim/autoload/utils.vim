

let s:comment_map = { 'c': '\/\/', 'cpp': '\/\/', 'go': '\/\/', 'java': '\/\/',
            \ 'javascript': '\/\/', 'rust': '\/\/', 'python': '#', 'ruby': '#',
            \ 'sh': '#', 'conf': '#', 'lua': '--', 'vim': '"', 'tex': '%'}

function! utils#toggleComment()
    if has_key(s:comment_map, &filetype)
        let comment_leader = s:comment_map[&filetype]
        if getline('.') =~ '\v^\s*' . comment_leader
            " Uncomment the line if it's a comment
            execute 'silent s/\v^(\s*)' . comment_leader . '(\s?)/\1'
        elseif getline('.') !~ '\v^\s*$'
            " Comment the line if not empty
            execute 'silent s/\v^(\s*)/\1' . comment_leader . ' '
        end
    else
        echo 'No comment leader found for filetype'
    end
endfunction


function! utils#trimWhitespace()
    let l:save = winsaveview()
    keep %s/\s\+$//e
    call winrestview(l:save)
endfunction

