if exists('b:loaded_SimpylFold')
    finish
endif
let b:loaded_SimpylFold = 1

call SimpylFold#BufferInit()
setlocal foldexpr=SimpylFold#FoldExpr(v:lnum)
setlocal foldmethod=expr

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'execute')

augroup SimpylFold
    autocmd! * <buffer>
    autocmd TextChanged,InsertLeave <buffer> call SimpylFold#Recache()
augroup END

if exists('g:SimpylFold_docstring_preview') && g:SimpylFold_docstring_preview
    setlocal foldtext=foldtext()\ ..\ SimpylFold#FoldText()
    let b:undo_ftplugin ..= ' | setl fdt<'
endif

command -bang -buffer SimpylFoldDocstrings let b:SimpylFold_fold_docstring = <bang>1 | call SimpylFold#Recache()
command -bang -buffer SimpylFoldImports let b:SimpylFold_fold_import = <bang>1 | call SimpylFold#Recache()

let b:undo_ftplugin ..= ' | unlet b:SimpylFold_fold_docstring'
        \ .. ' | unlet b:SimpylFold_fold_import'
        \ .. ' | delcommand SimpylFoldDocstrings'
        \ .. ' | delcommand SimpylFoldImports'
        \ .. ' | setl fde< fdm<'
        \ .. ' | execute "autocmd! SimpylFold * <buffer>"'
